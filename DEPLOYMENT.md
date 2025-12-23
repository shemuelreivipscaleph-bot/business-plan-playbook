# Deployment Guide - Business Plan Playbook

This guide covers deploying your Business Plan Playbook application to production.

## Table of Contents
1. [Vercel Deployment (Recommended)](#vercel-deployment)
2. [Docker Deployment](#docker-deployment)
3. [n8n Cloud Setup](#n8n-cloud-setup)
4. [Environment Variables](#environment-variables)
5. [Database Setup](#database-setup)
6. [Post-Deployment Checklist](#post-deployment-checklist)

---

## Vercel Deployment (Recommended)

Vercel is the recommended platform for deploying Next.js applications.

### Step 1: Prepare Your Repository

1. Initialize git (if not already done):
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. Push to GitHub, GitLab, or Bitbucket:
   ```bash
   git remote add origin YOUR_REPO_URL
   git push -u origin main
   ```

### Step 2: Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "New Project"
3. Import your repository
4. Configure project:
   - **Framework Preset**: Next.js
   - **Root Directory**: `./` (or `business-plan-playbook` if in subdirectory)
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`

### Step 3: Set Environment Variables

In Vercel project settings, add:
```
NEXT_PUBLIC_N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook
NEXT_PUBLIC_API_BASE_URL=https://your-n8n-instance.com/api
NEXT_PUBLIC_APP_NAME=Business Plan Playbook
NEXT_PUBLIC_APP_VERSION=1.0.0
```

### Step 4: Deploy

Click "Deploy" and wait for the build to complete.

Your app will be available at: `https://your-project.vercel.app`

---

## Docker Deployment

### Create Dockerfile

```dockerfile
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package*.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["node", "server.js"]
```

### Create docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_N8N_WEBHOOK_URL=http://n8n:5678/webhook
      - NEXT_PUBLIC_API_BASE_URL=http://n8n:5678/api
    depends_on:
      - n8n
      - postgres

  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=changeme
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      - postgres

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n
      - POSTGRES_DB=n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database-schema.sql:/docker-entrypoint-initdb.d/schema.sql

volumes:
  n8n_data:
  postgres_data:
```

### Build and Run

```bash
docker-compose up -d
```

Access:
- App: http://localhost:3000
- n8n: http://localhost:5678

---

## n8n Cloud Setup

### Option 1: n8n Cloud (Easiest)

1. Sign up at [n8n.cloud](https://n8n.cloud)
2. Create a new workflow
3. Import the `n8n-workflow-template.json` file
4. Configure your AI credentials (OpenAI, Anthropic, etc.)
5. Activate the workflow
6. Copy your webhook URLs
7. Update your app's environment variables

### Option 2: Self-Hosted n8n

1. **Install n8n**:
   ```bash
   npm install -g n8n
   ```

2. **Start n8n**:
   ```bash
   n8n start
   ```

3. **Configure for Production**:
   ```bash
   export N8N_HOST=your-domain.com
   export N8N_PORT=5678
   export N8N_PROTOCOL=https
   export WEBHOOK_URL=https://your-domain.com/
   n8n start
   ```

4. **Use PM2 for Process Management**:
   ```bash
   npm install -g pm2
   pm2 start n8n
   pm2 save
   pm2 startup
   ```

---

## Environment Variables

### Production Environment Variables

Create a `.env.production` file:

```env
# n8n Configuration
NEXT_PUBLIC_N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook
NEXT_PUBLIC_API_BASE_URL=https://your-n8n-instance.com/api

# Application
NEXT_PUBLIC_APP_NAME=Business Plan Playbook
NEXT_PUBLIC_APP_VERSION=1.0.0

# Optional: Analytics
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX
```

### Security Best Practices

1. Never commit `.env` files to git
2. Use different credentials for production
3. Enable HTTPS for all endpoints
4. Implement rate limiting
5. Add authentication if needed

---

## Database Setup

### PostgreSQL (Recommended)

1. **Create Database**:
   ```sql
   CREATE DATABASE business_plan_playbook;
   ```

2. **Run Schema**:
   ```bash
   psql -U postgres -d business_plan_playbook -f database-schema.sql
   ```

3. **Configure n8n Connection**:
   - In n8n, add PostgreSQL credentials
   - Update workflow nodes with your database details

### MongoDB Alternative

1. **Create Database**:
   ```javascript
   use business_plan_playbook
   ```

2. **Create Collections**:
   ```javascript
   db.createCollection("business_plan_history")
   db.business_plan_history.createIndex({ "promptId": 1 })
   db.business_plan_history.createIndex({ "timestamp": -1 })
   ```

---

## Post-Deployment Checklist

### Before Going Live

- [ ] Test all prompt categories
- [ ] Verify n8n webhooks are working
- [ ] Test database connections
- [ ] Check mobile responsiveness
- [ ] Verify SSL certificates
- [ ] Set up monitoring (Vercel Analytics, Sentry, etc.)
- [ ] Configure custom domain
- [ ] Test error handling
- [ ] Verify environment variables
- [ ] Set up backups for database

### Performance Optimization

- [ ] Enable Next.js Image Optimization
- [ ] Configure CDN for static assets
- [ ] Enable caching headers
- [ ] Optimize database queries
- [ ] Set up Redis for caching (optional)

### Security

- [ ] Enable CORS properly
- [ ] Implement rate limiting
- [ ] Add input validation
- [ ] Sanitize user inputs
- [ ] Enable HTTPS only
- [ ] Add security headers

### Monitoring

- [ ] Set up error tracking (Sentry)
- [ ] Configure analytics (Google Analytics, Plausible)
- [ ] Monitor API response times
- [ ] Track database performance
- [ ] Set up uptime monitoring

---

## Scaling Considerations

### When to Scale

- High traffic (>10,000 requests/day)
- Slow response times (>2 seconds)
- Database bottlenecks
- n8n workflow timeouts

### Scaling Strategies

1. **Horizontal Scaling**:
   - Deploy multiple Next.js instances
   - Use load balancer
   - Scale n8n workers

2. **Database Optimization**:
   - Add read replicas
   - Implement caching layer
   - Optimize indexes

3. **CDN Integration**:
   - Use Cloudflare or similar
   - Cache static assets
   - Enable edge caching

---

## Troubleshooting

### Common Issues

**Issue**: Webhook not receiving data
- **Solution**: Check CORS settings, verify webhook URL, check n8n logs

**Issue**: Slow AI responses
- **Solution**: Increase timeout, optimize prompts, consider caching

**Issue**: Database connection errors
- **Solution**: Verify credentials, check firewall rules, test connection

**Issue**: Build failures
- **Solution**: Clear `.next` folder, check dependencies, verify Node version

---

## Support Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [n8n Documentation](https://docs.n8n.io)
- [Vercel Documentation](https://vercel.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Ready for Production!** 🚀

Your Business Plan Playbook is now ready to help entrepreneurs worldwide build better businesses.
