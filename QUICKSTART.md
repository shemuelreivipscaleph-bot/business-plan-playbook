# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### 1. Install Dependencies
```bash
npm install
```

### 2. Create Environment File
Create a `.env.local` file in the root directory:
```env
NEXT_PUBLIC_N8N_WEBHOOK_URL=http://localhost:5678/webhook
NEXT_PUBLIC_API_BASE_URL=http://localhost:5678/api
NEXT_PUBLIC_APP_NAME=Business Plan Playbook
NEXT_PUBLIC_APP_VERSION=1.0.0
```

### 3. Start Development Server
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## 🎯 What You Can Do Now

Even without n8n configured, you can:
- ✅ Browse all prompt categories
- ✅ View individual prompts
- ✅ Fill out prompt forms
- ✅ See the generated prompt preview
- ✅ Explore the entire UI

## 🔌 To Enable AI Features

### Option 1: Quick Test (Mock Mode)
The app will work without n8n, but won't generate AI responses.

### Option 2: Full Setup with n8n

1. **Install n8n**:
   ```bash
   npm install -g n8n
   ```

2. **Start n8n**:
   ```bash
   n8n start
   ```

3. **Import Workflow**:
   - Open http://localhost:5678
   - Import `n8n-workflow-template.json`
   - Add your OpenAI API key
   - Activate the workflow

4. **Test the Integration**:
   - Go back to http://localhost:3000
   - Fill out any prompt
   - Click "Generate Response"
   - See AI-powered insights!

## 📦 Production Build

Test the production build:
```bash
npm run build
npm start
```

## 🎨 Customization

- **Prompts**: Edit `src/data/prompts.ts`
- **Styles**: Edit `src/app/globals.css`
- **Components**: Check `src/components/`

## 📚 Documentation

- [README.md](./README.md) - Full documentation
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment guide
- [ENV_SETUP.md](./ENV_SETUP.md) - Environment setup

## 🆘 Need Help?

Check the troubleshooting section in README.md or review the n8n workflow template.

---

**Happy Building! 🎉**
