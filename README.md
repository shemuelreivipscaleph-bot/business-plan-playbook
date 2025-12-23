# Business Plan Playbook

A premium, AI-powered business planning application built with Next.js and n8n. Transform your business ideas into actionable plans with comprehensive prompts for strategy development, market research, financial planning, and more.

![Business Plan Playbook](https://img.shields.io/badge/Next.js-16.1-black?style=for-the-badge&logo=next.js)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue?style=for-the-badge&logo=typescript)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-38bdf8?style=for-the-badge&logo=tailwind-css)

## ✨ Features

- **🎯 7 Comprehensive Categories**: Strategy, Market Research, Financial Planning, Implementation, Risk Analysis, Performance Tracking, and Growth Strategy
- **📝 20+ AI-Powered Prompts**: Detailed, actionable prompts for every aspect of business planning
- **🤖 n8n Integration**: Seamless backend integration for AI processing and data management
- **💾 History Tracking**: Save and review all your generated business insights
- **🎨 Premium Dark Theme**: Modern, glassmorphic UI with smooth animations
- **📱 Fully Responsive**: Beautiful experience on all devices
- **⚡ Production Ready**: Optimized for deployment and scalability

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ installed
- npm or yarn package manager
- n8n instance (local or cloud)

### Installation

1. **Clone or navigate to the project**:
   ```bash
   cd business-plan-playbook
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up environment variables**:
   Create a `.env.local` file in the root directory:
   ```env
   NEXT_PUBLIC_N8N_WEBHOOK_URL=http://localhost:5678/webhook
   NEXT_PUBLIC_API_BASE_URL=http://localhost:5678/api
   NEXT_PUBLIC_APP_NAME=Business Plan Playbook
   NEXT_PUBLIC_APP_VERSION=1.0.0
   ```

4. **Run the development server**:
   ```bash
   npm run dev
   ```

5. **Open your browser**:
   Navigate to [http://localhost:3000](http://localhost:3000)

## 🔧 n8n Setup

### Install n8n

```bash
npm install -g n8n
```

### Start n8n

```bash
n8n start
```

Access n8n at [http://localhost:5678](http://localhost:5678)

### Configure Webhooks

You need to create the following webhook endpoints in n8n:

#### 1. Business Plan Prompt Webhook
- **URL**: `/webhook/business-plan-prompt`
- **Method**: POST
- **Purpose**: Process prompt submissions and generate AI responses

**Workflow Structure**:
1. Webhook node (receives prompt data)
2. Function node (process inputs)
3. AI node (OpenAI, Anthropic, or your preferred AI service)
4. Response node (return generated content)

**Example Workflow**:
```json
{
  "nodes": [
    {
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "parameters": {
        "path": "business-plan-prompt",
        "responseMode": "responseNode",
        "options": {}
      }
    },
    {
      "name": "Process Input",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "// Extract prompt data\nconst { promptId, category, inputs } = $json;\n\n// Build the complete prompt\nlet prompt = '';\nfor (const [key, value] of Object.entries(inputs)) {\n  prompt += `${key}: ${value}\\n`;\n}\n\nreturn { json: { prompt, promptId, category } };"
      }
    },
    {
      "name": "OpenAI",
      "type": "n8n-nodes-base.openAi",
      "parameters": {
        "resource": "text",
        "operation": "complete",
        "model": "gpt-4",
        "prompt": "={{ $json.prompt }}"
      }
    },
    {
      "name": "Respond",
      "type": "n8n-nodes-base.respondToWebhook",
      "parameters": {
        "respondWith": "json",
        "responseBody": "={{ { success: true, result: $json.choices[0].message.content } }}"
      }
    }
  ]
}
```

#### 2. Save Response Webhook
- **URL**: `/webhook/save-response`
- **Method**: POST
- **Purpose**: Save generated responses for history tracking

**Workflow Structure**:
1. Webhook node (receives response data)
2. Database node (save to your database - PostgreSQL, MySQL, MongoDB, etc.)

#### 3. Get History Webhook
- **URL**: `/webhook/get-history`
- **Method**: GET
- **Purpose**: Retrieve user's prompt history

**Workflow Structure**:
1. Webhook node
2. Database query node
3. Response node

## 📁 Project Structure

```
business-plan-playbook/
├── src/
│   ├── app/
│   │   ├── category/[id]/     # Category pages
│   │   ├── prompt/[id]/       # Individual prompt pages
│   │   ├── history/           # History page
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Home page
│   │   └── globals.css        # Global styles
│   ├── components/
│   │   ├── CategoryCard.tsx   # Category display component
│   │   ├── PromptCard.tsx     # Prompt display component
│   │   ├── PromptForm.tsx     # Interactive form component
│   │   └── Header.tsx         # Navigation header
│   ├── data/
│   │   └── prompts.ts         # All prompt definitions
│   ├── lib/
│   │   └── n8n.ts             # n8n API service
│   └── types/
│       └── index.ts           # TypeScript definitions
├── public/                     # Static assets
├── .env.local                 # Environment variables (create this)
├── package.json
├── tsconfig.json
└── README.md
```

## 🎨 Design System

The application features a premium dark theme with:

- **Glassmorphism**: Frosted glass effects for modern UI
- **Gradient Accents**: Dynamic color gradients for visual appeal
- **Smooth Animations**: Fade-ins, hover effects, and transitions
- **Custom Typography**: Inter and Space Grotesk fonts
- **Responsive Grid**: Mobile-first responsive design

### Color Palette

- Primary: `hsl(220 100% 60%)`
- Secondary: `hsl(280 80% 65%)`
- Accent: `hsl(160 85% 55%)`
- Background: `hsl(222 25% 8%)`

## 🔌 API Integration

### Sending a Prompt

```typescript
import { N8NService } from '@/lib/n8n';

const response = await N8NService.sendPrompt({
  promptId: 'business-model-evaluation',
  category: 'strategy',
  inputs: {
    businessType: 'SaaS platform',
    targetMarket: 'Small businesses',
    // ... other inputs
  },
});
```

### Saving a Response

```typescript
await N8NService.saveResponse(
  promptId,
  inputs,
  generatedResponse
);
```

### Getting History

```typescript
const history = await N8NService.getHistory(userId);
```

## 🏗️ Production Build

### Build the application

```bash
npm run build
```

### Start production server

```bash
npm start
```

### Deploy

The application can be deployed to:
- **Vercel** (recommended for Next.js)
- **Netlify**
- **AWS Amplify**
- **Docker containers**
- Any Node.js hosting platform

## 📊 Prompt Categories

1. **Strategy Development** (3 prompts)
   - Business Model Evaluation
   - Mission & Vision Development
   - Competitive Analysis

2. **Market Research** (2 prompts)
   - Target Market Analysis
   - Market Size Calculation

3. **Financial Planning** (2 prompts)
   - Revenue Projection
   - Startup Costs Analysis

4. **Implementation Strategy** (2 prompts)
   - Milestone Planning
   - Marketing Strategy Development

5. **Risk Analysis** (2 prompts)
   - Risk Assessment
   - Contingency Planning

6. **Performance Tracking** (2 prompts)
   - KPI Development
   - Progress Review

7. **Growth Strategy** (2 prompts)
   - Scaling Planning
   - Market Expansion

## 🛠️ Customization

### Adding New Prompts

Edit `src/data/prompts.ts` and add your prompt to the appropriate category:

```typescript
{
  id: 'your-prompt-id',
  title: 'Your Prompt Title',
  description: 'Description of what this prompt does',
  category: 'category-id',
  template: 'Your prompt template with {variables}',
  fields: [
    {
      id: 'fieldId',
      label: 'Field Label',
      type: 'text',
      placeholder: 'Placeholder text',
      required: true,
    },
  ],
}
```

### Modifying Styles

Edit `src/app/globals.css` to customize:
- Color variables
- Typography
- Spacing
- Border radius
- Animations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Built with [Next.js](https://nextjs.org/)
- Powered by [n8n](https://n8n.io/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Icons from [Heroicons](https://heroicons.com/)

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Check the documentation
- Review n8n workflow examples

---

**Made with ❤️ for entrepreneurs and business builders**
