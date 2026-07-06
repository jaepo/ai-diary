# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI 일기장 (AI Diary) - A web service where users write diary entries and receive AI-powered emotional analysis with comforting messages from Claude AI.

**Core Flow**: User writes diary → Claude AI analyzes sentiment → Returns emotional score, keywords, and personalized supportive message

## Essential Commands

### Development
```bash
npm run dev          # Start dev server with Turbopack
npm run build        # Prisma generate + Next.js build
npm run start        # Production server
```

### Database (Prisma)
```bash
npm run db:generate  # Generate Prisma client
npm run db:migrate   # Create and apply migration
npm run db:reset     # Reset database (WARNING: deletes all data)
npm run db:studio    # Open Prisma Studio GUI
npm run setup        # Full setup: install + generate + migrate
```

### First-Time Setup
```bash
npm run setup                    # Install deps + Prisma setup
cp .env.example .env             # Copy env template
# Edit .env with actual credentials
npm run dev                      # Start development
```

## Architecture

### Tech Stack
- **Frontend**: Next.js 16.2 (App Router) + TypeScript + Tailwind CSS 4
- **Animation**: Framer Motion 12 (staggered animations, micro-interactions)
- **Auth**: NextAuth.js v5 (Google OAuth via Prisma adapter)
- **Database**: PostgreSQL + Prisma 7
- **AI**: Anthropic Claude Sonnet 4 (sentiment analysis, keyword extraction)

### Authentication Flow
- NextAuth.js with Prisma adapter stores sessions in PostgreSQL
- Google OAuth configured in `auth.ts`
- Session callback extends user object with `id` field
- Sign-in page: `/auth/signin`, API route: `/api/auth/[...nextauth]`

### AI Analysis (`lib/ai.ts`)
- **Function**: `analyzeDiary(content: string): Promise<DiaryAnalysis>`
- **Model**: claude-sonnet-4-20250514
- **Returns**: 
  - `sentiment`: "positive" | "negative" | "neutral"
  - `sentimentScore`: -1.0 to 1.0
  - `aiResponse`: 2-3 sentence empathetic message in Korean
  - `keywords`: Array of 5 key themes
- **Error handling**: Returns neutral sentiment with default message on failure

### Database Schema
```
User (NextAuth) → DiaryEntry (application)
  ↓
  - content: diary text
  - sentiment, sentimentScore: AI analysis results  
  - aiResponse: personalized message
  - keywords: JSON string array
  - createdAt, updatedAt
```

**Key Index**: `@@index([userId, createdAt(sort: Desc)])` for efficient user diary queries

### Typography System
Custom font stack loaded via Next.js fonts:
- **Pretendard Variable** (CDN): Display/headings
- **Noto Sans KR**: Body text
- **Gowun Batang**: AI responses (emotional/accent)
- **JetBrains Mono**: Dates/numbers

Font variables: `--font-noto-sans`, `--font-gowun`, `--font-jetbrains`

### Design System (Tailwind CSS 4)
**Color Palette** (defined in `globals.css`):
- Primary: Orange (#F97316) - warmth
- Secondary: Purple (#A855F7) - depth
- Sentiment: Green/Rose/Slate for positive/negative/neutral

**Custom Animations**:
- `fadeIn`, `slideUp`, `bounceGentle` keyframes
- Framer Motion for staggered entry animations (0.1s intervals)

## Environment Variables

Required in `.env`:
```env
DATABASE_URL="postgresql://..."           # PostgreSQL connection
AUTH_SECRET="..."                         # openssl rand -base64 32
AUTH_GOOGLE_ID="..."                      # Google OAuth Client ID
AUTH_GOOGLE_SECRET="..."                  # Google OAuth Secret
ANTHROPIC_API_KEY="..."                   # Anthropic API key
```

### OAuth Setup
Google OAuth redirect URI must include:
- Dev: `http://localhost:3000/api/auth/callback/google`
- Prod: `https://yourdomain.com/api/auth/callback/google`

## File Organization

```
app/
  api/           # API routes (to be created)
  auth/signin/   # Login page
  layout.tsx     # Font loading, metadata
  globals.css    # Design tokens, animations

components/
  animations/    # Framer Motion wrappers
  ui/           # Reusable UI components
  
lib/
  db.ts         # Prisma client singleton
  ai.ts         # Claude AI integration

prisma/
  schema.prisma # Database models (User, DiaryEntry, NextAuth)
```

## Development Notes

### When Adding API Routes
- Use Next.js 15 App Router conventions (`app/api/*/route.ts`)
- Authenticate with: `const session = await auth()` (from `@/auth`)
- Access database via: `import { prisma } from "@/lib/db"`

### When Creating UI Components
- Use Tailwind CSS 4 inline theme syntax (`@theme inline`)
- Sentiment colors available: `sentiment-positive`, `sentiment-negative`, `sentiment-neutral`
- Apply Framer Motion for entry animations (see `documents/design-guide.md`)

### Prisma Workflow
1. Modify `prisma/schema.prisma`
2. Run `npm run db:migrate -- --name descriptive_name`
3. Prisma Client auto-regenerates

### AI Integration
- Always handle `analyzeDiary()` failures gracefully
- Keywords stored as JSON string in DB - parse with `JSON.parse(entry.keywords)`
- AI responses are in Korean - maintain language consistency in UI

## Documentation

- **Full Plan**: `documents/plan.md` (architecture, API specs, timeline)
- **Design System**: `documents/design-guide.md` (colors, typography, animations)
- **Tech Stack**: `TECH_STACK.md` (technology decisions)

## Common Patterns

### Protected API Route
```typescript
import { auth } from "@/auth";
export async function GET() {
  const session = await auth();
  if (!session?.user?.id) return new Response("Unauthorized", { status: 401 });
  // ... handle request
}
```

### Using AI Analysis
```typescript
import { analyzeDiary } from "@/lib/ai";
const analysis = await analyzeDiary(diaryContent);
await prisma.diaryEntry.create({
  data: {
    content,
    sentiment: analysis.sentiment,
    sentimentScore: analysis.sentimentScore,
    aiResponse: analysis.aiResponse,
    keywords: JSON.stringify(analysis.keywords),
  }
});
```

### Framer Motion Stagger Container
```typescript
import { motion } from "framer-motion";
const container = {
  hidden: { opacity: 0 },
  visible: { 
    opacity: 1,
    transition: { staggerChildren: 0.1 }
  }
};
```
