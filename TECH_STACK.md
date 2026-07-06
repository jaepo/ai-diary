# AI 일기장 기술 스택

## 📋 선정된 기술 스택 (2026-07-06)

### Frontend
- **Framework**: Next.js 15 (React 기반)
- **Language**: TypeScript
- **Styling**: Tailwind CSS

### Backend
- **Runtime**: Next.js API Routes (서버리스)
- **Language**: TypeScript

### Database
- **Database**: PostgreSQL
- **ORM**: Prisma

### Authentication
- **Auth Library**: NextAuth.js v5
- **Provider**: Google OAuth 2.0

### AI Service
- **Provider**: Anthropic
- **Model**: Claude Sonnet 4
- **SDK**: @anthropic-ai/sdk

### Additional Libraries
- **Icons**: react-icons
- **Date**: date-fns
- **Validation**: zod

---

## 🏗️ 아키텍처 구조

\`\`\`
┌─────────────────────────────────────────┐
│         사용자 (브라우저)                │
└───────────────┬─────────────────────────┘
                │
                ↓
┌─────────────────────────────────────────┐
│   Next.js Frontend (React + Tailwind)   │
│   - 로그인 페이지                        │
│   - 일기 작성 UI                         │
│   - 일기 목록 UI                         │
└───────────────┬─────────────────────────┘
                │
                ↓
┌─────────────────────────────────────────┐
│      Next.js API Routes (Backend)       │
│   - /api/auth/[...nextauth]             │
│   - /api/diary (GET, POST)              │
└────┬──────────────────┬─────────────────┘
     │                  │
     ↓                  ↓
┌─────────┐    ┌────────────────────┐
│NextAuth │    │   Anthropic API    │
│  OAuth  │    │   (Claude AI)      │
└────┬────┘    └────────────────────┘
     │
     ↓
┌─────────────────────────────────────────┐
│    PostgreSQL Database (Prisma ORM)     │
│   - User                                │
│   - Account                             │
│   - Session                             │
│   - DiaryEntry                          │
└─────────────────────────────────────────┘
\`\`\`

---

## 📦 주요 패키지 목록

### Dependencies (프로덕션)
\`\`\`json
{
  "next": "^16.2.10",
  "react": "^19.2.4",
  "react-dom": "^19.2.4",
  "@prisma/client": "^7.x",
  "next-auth": "^5.0.0-beta",
  "@auth/prisma-adapter": "^2.x",
  "@anthropic-ai/sdk": "^0.110.0",
  "zod": "^4.x",
  "react-icons": "^5.x",
  "date-fns": "^4.x",
  "framer-motion": "^11.0.0"
}
\`\`\`

### DevDependencies (개발)
\`\`\`json
{
  "typescript": "^5",
  "@types/node": "^20",
  "@types/react": "^19",
  "@types/react-dom": "^19",
  "prisma": "^7.x",
  "tailwindcss": "^4",
  "@tailwindcss/postcss": "^4",
  "@tailwindcss/typography": "^0.5.10",
  "eslint": "^9",
  "eslint-config-next": "^16.2.10"
}
\`\`\`

---

## 🎯 기술 선정 이유

### 1. Next.js + TypeScript
- **이유**: 풀스택 개발 가능, SEO 우수, 타입 안정성
- **장점**: 빠른 개발, 우수한 DX, 대규모 커뮤니티
- **단점**: 학습 곡선 존재

### 2. PostgreSQL + Prisma
- **이유**: 프로덕션급 안정성, 타입 안전한 쿼리
- **장점**: 확장성, 마이그레이션 관리 용이
- **단점**: 별도 DB 서버 필요

### 3. NextAuth.js
- **이유**: Next.js 공식 권장, 보안성 우수
- **장점**: 간편한 소셜 로그인, 세션 관리 자동화
- **단점**: 설정 복잡도 약간 있음

### 4. Anthropic Claude
- **이유**: 한국어 감정 분석 우수, 공감 능력 뛰어남
- **장점**: 위로/응원 메시지 품질 우수
- **단점**: 종량제 비용

### 5. Tailwind CSS
- **이유**: 빠른 UI 개발, 일관된 디자인
- **장점**: 반응형 디자인 간편, 커스터마이징 용이
- **단점**: HTML이 길어질 수 있음

---

## 🔧 개발 환경 요구사항

### 필수 설치
- Node.js v20 이상
- PostgreSQL v14 이상
- npm 또는 yarn

### 권장 도구
- VS Code
- Prisma Studio (DB GUI)
- Postman (API 테스트)

### 필수 API 키
- Google OAuth Client ID/Secret
- Anthropic API Key

---

## 🚀 배포 계획

### 추천 플랫폼
1. **Vercel** (1순위)
   - Next.js 최적화
   - PostgreSQL 통합 (Vercel Postgres)
   - 자동 배포
   - 무료 플랜 제공

2. **Netlify** (2순위)
   - 간편한 배포
   - 환경 변수 관리

3. **Railway/Render** (3순위)
   - PostgreSQL 호스팅 포함
   - 합리적인 가격

---

**작성일**: 2026-07-06  
**검토자**: 개발팀
