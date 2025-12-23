# Environment Setup

Create a `.env.local` file in the root directory with the following variables:

```env
# n8n Backend Configuration
NEXT_PUBLIC_N8N_WEBHOOK_URL=http://localhost:5678/webhook
NEXT_PUBLIC_API_BASE_URL=http://localhost:5678/api

# Application Configuration
NEXT_PUBLIC_APP_NAME=Business Plan Playbook
NEXT_PUBLIC_APP_VERSION=1.0.0
```

## n8n Setup

1. Install n8n: `npm install -g n8n`
2. Start n8n: `n8n start`
3. Access n8n at: `http://localhost:5678`
4. Create workflows for each prompt category
5. Set up webhook endpoints for the application

## Development

Run the development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Production Build

```bash
npm run build
npm start
```
    