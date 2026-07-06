# AI 일기장 프로젝트 전체 계획서

**프로젝트명**: AI 일기장 (AI Diary)  
**작성일**: 2026-07-06  
**버전**: 1.0  

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [서비스 기획](#2-서비스-기획)
3. [기술 스택](#3-기술-스택)
4. [개발 계획](#4-개발-계획)
5. [데이터베이스 설계](#5-데이터베이스-설계)
6. [API 설계](#6-api-설계)
7. [UI/UX 설계](#7-uiux-설계)
8. [개발 일정](#8-개발-일정)
9. [배포 전략](#9-배포-전략)
10. [향후 계획](#10-향후-계획)

---

## 1. 프로젝트 개요

### 1.1 서비스 컨셉
사용자가 작성한 일기를 AI가 분석하여 감정 상태를 파악하고, 맞춤형 위로와 응원 메시지를 제공하는 웹 서비스

### 1.2 핵심 가치 제안

**문제 정의**
- 많은 사람들이 일기를 쓰지만, 자신의 감정 상태를 객관적으로 파악하기 어려움
- 힘들 때 위로받고 싶지만 주변에 털어놓기 어려운 경우가 많음
- 일기 작성 습관을 유지하기 어려움

**솔루션**
- AI가 일기를 분석하여 감정 상태를 객관적으로 파악
- 일기 내용에 맞는 따뜻한 위로와 응원 메시지 제공
- AI와의 감정적 교감으로 일기 작성 동기 부여

**차별점**
- 단순 기록이 아닌 AI와의 감정적 소통
- 프라이버시 보장 (개인 공간)
- 한국어 감정 분석에 최적화된 AI 사용

### 1.3 타겟 사용자
- **주 타겟**: 감정 관리에 관심 있는 20-40대
- **부 타겟**: 일기 작성을 시작하고 싶은 사람들
- **잠재 타겟**: 정서적 지지가 필요한 모든 연령대

### 1.4 성공 지표 (KPI)
- DAU (Daily Active Users): 100명 (3개월 목표)
- 평균 주간 작성 빈도: 3회 이상
- 사용자 리텐션율: 30% (월간)
- AI 응답 만족도: 4.0/5.0 이상

---

## 2. 서비스 기획

### 2.1 핵심 기능 (MVP)

#### 기능 1: 사용자 인증
- **Google 소셜 로그인**
  - 간편한 가입/로그인 프로세스
  - 별도 회원가입 절차 불필요
  - OAuth 2.0 보안 프로토콜

#### 기능 2: 일기 작성
- **텍스트 에디터**
  - 자유로운 텍스트 입력 (글자 수 제한 없음)
  - 작성 날짜 자동 기록
  - 작성 중 임시 저장 (선택 사항)

#### 기능 3: AI 분석 (핵심)
- **감정 분석**
  - 분류: positive (긍정적) / negative (부정적) / neutral (중립적)
  - 점수: -1.0 (매우 부정) ~ 1.0 (매우 긍정)
  
- **맞춤형 응답**
  - 일기 내용 기반 공감적 메시지
  - 2-3문장의 따뜻한 위로와 응원
  - 한국어 자연스러운 표현

- **키워드 추출**
  - 일기의 핵심 주제 5개 추출
  - 해시태그 형태로 시각화
  - 검색 및 필터링에 활용

#### 기능 4: 일기 히스토리
- **목록 보기**
  - 최신순 정렬
  - 날짜별 그룹핑
  - 감정 상태 아이콘 표시
  - AI 응답 요약 미리보기

### 2.2 사용자 플로우

#### 신규 사용자 플로우
```
1. 랜딩 페이지 접속
   ↓
2. 서비스 소개 확인
   ↓
3. "Google로 시작하기" 클릭
   ↓
4. Google 계정 선택 및 권한 승인
   ↓
5. 메인 대시보드 진입
   ↓
6. 환영 메시지 확인
   ↓
7. 첫 일기 작성
   ↓
8. AI 분석 대기 (5-10초)
   ↓
9. AI 응답 확인
   ↓
10. 일기 저장 완료
```

#### 재방문 사용자 플로우
```
1. 자동 로그인
   ↓
2. 메인 대시보드 진입
   ↓
3. 이전 일기 목록 확인 (선택)
   ↓
4. 새 일기 작성
   ↓
5. AI 분석 및 응답 확인
   ↓
6. 과거 감정과 비교 (선택)
```

### 2.3 화면 구성

#### 화면 1: 로그인 페이지 (`/auth/signin`)
```
┌─────────────────────────────────────┐
│                                     │
│        🌙 AI 일기장                  │
│    당신의 이야기를 들려주세요          │
│                                     │
│   ┌───────────────────────────┐    │
│   │  🔵 Google로 시작하기      │    │
│   └───────────────────────────┘    │
│                                     │
│   AI가 당신의 일기를 분석하고         │
│   따뜻한 응원을 보내드립니다          │
│                                     │
└─────────────────────────────────────┘
```

#### 화면 2: 메인 대시보드 (`/`)
```
┌────────────────────────────────────────────────────────┐
│ 🌙 AI 일기장          👤 사용자명    🚪 로그아웃         │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌─────────────────────┐  ┌─────────────────────┐    │
│  │   오늘의 일기        │  │   이전 일기          │    │
│  │                     │  │                     │    │
│  │  ┌───────────────┐  │  │  ┌───────────────┐  │    │
│  │  │               │  │  │  │ 📅 2026-07-05 │  │    │
│  │  │  텍스트        │  │  │  │ 😊 긍정적      │  │    │
│  │  │  에디터        │  │  │  │ #행복 #감사    │  │    │
│  │  │               │  │  │  └───────────────┘  │    │
│  │  └───────────────┘  │  │  ┌───────────────┐  │    │
│  │                     │  │  │ 📅 2026-07-04 │  │    │
│  │  [💾 저장하고      │  │  │ 😐 중립적      │  │    │
│  │   AI 분석받기]      │  │  │ #일상 #평범    │  │    │
│  │                     │  │  └───────────────┘  │    │
│  │  ┌───────────────┐  │  │                     │    │
│  │  │ 🤖 AI의 응답   │  │  │  [더보기...]        │    │
│  │  │               │  │  │                     │    │
│  │  │ 😊 긍정적      │  │  │                     │    │
│  │  │ 점수: 0.8      │  │  │                     │    │
│  │  │               │  │  │                     │    │
│  │  │ 오늘 하루...   │  │  │                     │    │
│  │  │ #키워드들      │  │  │                     │    │
│  │  └───────────────┘  │  │                     │    │
│  └─────────────────────┘  └─────────────────────┘    │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## 3. 기술 스택

### 3.1 Frontend
- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 4
- **Typography**: 
  - Pretendard Variable (Display)
  - Noto Sans KR (Body)
  - Gowun Batang (Accent)
  - JetBrains Mono (Monospace)
- **Animation**: Framer Motion 11
- **UI Components**: Custom components with Tailwind
- **Icons**: react-icons
- **Date Handling**: date-fns (한국어 로케일 포함)

### 3.2 Backend
- **Runtime**: Next.js API Routes (서버리스)
- **Language**: TypeScript 5
- **API Design**: RESTful API

### 3.3 Database
- **Database**: PostgreSQL 14+
- **ORM**: Prisma 7
- **Migration**: Prisma Migrate

### 3.4 Authentication
- **Library**: NextAuth.js v5
- **Provider**: Google OAuth 2.0
- **Session**: Database sessions (Prisma Adapter)

### 3.5 AI Service
- **Provider**: Anthropic
- **Model**: Claude Sonnet 4
- **SDK**: @anthropic-ai/sdk v0.110.0
- **Features**: 
  - 감정 분석
  - 공감 메시지 생성
  - 키워드 추출

### 3.6 개발 도구
- **Version Control**: Git
- **Package Manager**: npm
- **Code Editor**: VS Code (권장)
- **Linting**: ESLint 9
- **Type Checking**: TypeScript Compiler

### 3.7 아키텍처

```
┌─────────────────────────────────────────┐
│         클라이언트 (브라우저)             │
│    React Components + Tailwind CSS      │
└───────────────┬─────────────────────────┘
                │ HTTP/HTTPS
                ↓
┌─────────────────────────────────────────┐
│        Next.js Application              │
│  ┌─────────────────────────────────┐   │
│  │    Frontend (Server Components)  │   │
│  │    - Page Rendering              │   │
│  │    - Client Components           │   │
│  └─────────────┬───────────────────┘   │
│                │                        │
│  ┌─────────────▼───────────────────┐   │
│  │    API Routes (Backend)          │   │
│  │    - /api/auth/[...nextauth]     │   │
│  │    - /api/diary                  │   │
│  └──┬──────────────────────┬────────┘   │
└─────┼──────────────────────┼────────────┘
      │                      │
      ↓                      ↓
┌─────────────┐    ┌─────────────────────┐
│  NextAuth   │    │   Anthropic API     │
│   Google    │    │   Claude Sonnet 4   │
│   OAuth     │    │   - 감정 분석        │
└──────┬──────┘    │   - 응답 생성        │
       │           │   - 키워드 추출      │
       │           └─────────────────────┘
       ↓
┌─────────────────────────────────────────┐
│    PostgreSQL Database                  │
│    (Prisma ORM)                         │
│  ┌─────────────────────────────────┐   │
│  │  Tables:                         │   │
│  │  - User                          │   │
│  │  - Account (OAuth)               │   │
│  │  - Session                       │   │
│  │  - DiaryEntry                    │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## 4. 개발 계획

### 4.1 개발 환경 설정

#### 필수 소프트웨어
- Node.js v20+ 설치
- PostgreSQL v14+ 설치
- Git 설치
- VS Code (또는 선호하는 에디터)

#### 프로젝트 초기화
```bash
# Next.js 프로젝트 생성
npx create-next-app@latest ai-diary --typescript --tailwind --app

# 디렉토리 이동
cd ai-diary

# 필수 패키지 설치
npm install @prisma/client next-auth@beta @auth/prisma-adapter
npm install @anthropic-ai/sdk zod react-icons date-fns
npm install framer-motion

# 개발 의존성 설치
npm install -D prisma @tailwindcss/typography
```

#### 환경 변수 설정
`.env` 파일 생성:
```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/ai_diary"

# NextAuth
AUTH_SECRET="생성된-랜덤-시크릿"
AUTH_GOOGLE_ID="구글-클라이언트-ID"
AUTH_GOOGLE_SECRET="구글-클라이언트-시크릿"

# Anthropic
ANTHROPIC_API_KEY="앤스로픽-API-키"
```

### 4.2 폴더 구조

```
ai-diary/
├── app/                          # Next.js App Router
│   ├── api/                      # API Routes
│   │   ├── auth/
│   │   │   └── [...nextauth]/
│   │   │       └── route.ts      # NextAuth API
│   │   └── diary/
│   │       └── route.ts          # 일기 CRUD API
│   ├── auth/
│   │   └── signin/
│   │       └── page.tsx          # 로그인 페이지
│   ├── layout.tsx                # Root Layout
│   ├── page.tsx                  # 메인 페이지
│   └── globals.css               # Global styles
├── components/                   # React 컴포넌트
│   ├── DiaryApp.tsx              # 메인 앱 컨테이너
│   ├── DiaryEditor.tsx           # 일기 작성 에디터
│   ├── DiaryList.tsx             # 일기 목록
│   ├── AIResponse.tsx            # AI 응답 표시
│   ├── animations/               # 애니메이션 컴포넌트
│   │   ├── StaggerContainer.tsx  # Stagger 애니메이션
│   │   └── TypewriterText.tsx    # 타이핑 효과
│   └── ui/                       # UI 컴포넌트
│       ├── Button.tsx            # 버튼 컴포넌트
│       └── Card.tsx              # 카드 컴포넌트
├── lib/                          # 유틸리티
│   ├── db.ts                     # Prisma 클라이언트
│   ├── ai.ts                     # AI 분석 로직
│   └── utils.ts                  # 공통 유틸
├── prisma/                       # Prisma 설정
│   ├── schema.prisma             # DB 스키마
│   └── migrations/               # 마이그레이션 파일
├── types/                        # TypeScript 타입
│   └── next-auth.d.ts            # NextAuth 타입 확장
├── public/                       # 정적 파일
├── documents/                    # 문서
│   └── plan.md                   # 이 파일
├── .env                          # 환경 변수
├── .env.example                  # 환경 변수 예시
├── .gitignore                    # Git 제외 파일
├── auth.ts                       # NextAuth 설정
├── package.json                  # 패키지 정보
├── tsconfig.json                 # TypeScript 설정
├── tailwind.config.ts            # Tailwind 설정
└── README.md                     # 프로젝트 설명
```

### 4.3 개발 단계

#### Phase 1: 기본 설정 (1일)
- [x] Next.js 프로젝트 생성
- [x] Tailwind CSS 설정
- [x] TypeScript 설정
- [ ] ESLint 설정
- [ ] Git 초기화

#### Phase 2: 데이터베이스 (1일)
- [ ] PostgreSQL 설치 및 설정
- [ ] Prisma 스키마 작성
- [ ] 초기 마이그레이션 실행
- [ ] Prisma Studio로 확인

#### Phase 3: 인증 시스템 (1일)
- [ ] NextAuth.js 설정
- [ ] Google OAuth 연동
- [ ] 로그인 페이지 UI
- [ ] 세션 관리 구현

#### Phase 4: 일기 작성 기능 (2일)
- [ ] 일기 에디터 UI
- [ ] API 엔드포인트 (/api/diary POST)
- [ ] 데이터베이스 저장
- [ ] 클라이언트 상태 관리

#### Phase 5: AI 분석 (2일)
- [ ] Anthropic API 연동
- [ ] 감정 분석 로직
- [ ] 응답 메시지 생성
- [ ] 키워드 추출
- [ ] 에러 처리 및 폴백

#### Phase 6: 일기 히스토리 (1일)
- [ ] 목록 API (/api/diary GET)
- [ ] 목록 UI 컴포넌트
- [ ] 날짜 포맷팅
- [ ] 무한 스크롤 (선택)

#### Phase 7: UI/UX 개선 (1일)
- [ ] 반응형 디자인
- [ ] 로딩 애니메이션
- [ ] 에러 메시지
- [ ] 빈 상태 UI

#### Phase 8: 테스트 및 디버깅 (1일)
- [ ] 기능 테스트
- [ ] 브라우저 호환성 테스트
- [ ] 성능 최적화
- [ ] 버그 수정

---

## 5. 데이터베이스 설계

### 5.1 ERD (Entity Relationship Diagram)

```
┌─────────────────┐
│      User       │
├─────────────────┤
│ id: String (PK) │
│ name: String?   │
│ email: String   │◄──────┐
│ emailVerified   │       │
│ image: String?  │       │
│ createdAt       │       │
└─────────────────┘       │
        △                 │
        │                 │
        │ 1:N             │ 1:N
        │                 │
┌───────┴─────────┐  ┌────┴──────────────┐
│    Account      │  │   DiaryEntry      │
├─────────────────┤  ├───────────────────┤
│ id: String (PK) │  │ id: String (PK)   │
│ userId (FK)     │  │ userId (FK)       │
│ provider        │  │ content: String   │
│ providerAcctId  │  │ sentiment: String │
│ refresh_token   │  │ sentimentScore    │
│ access_token    │  │ aiResponse        │
│ expires_at      │  │ keywords: JSON    │
└─────────────────┘  │ createdAt         │
                     │ updatedAt         │
                     └───────────────────┘
        △
        │
        │ 1:N
        │
┌───────┴─────────┐
│     Session     │
├─────────────────┤
│ id: String (PK) │
│ sessionToken    │
│ userId (FK)     │
│ expires         │
└─────────────────┘
```

### 5.2 Prisma Schema

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// NextAuth Models
model Account {
  id                String  @id @default(cuid())
  userId            String
  type              String
  provider          String
  providerAccountId String
  refresh_token     String?
  access_token      String?
  expires_at        Int?
  token_type        String?
  scope             String?
  id_token          String?
  session_state     String?

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerAccountId])
  @@index([userId])
}

model Session {
  id           String   @id @default(cuid())
  sessionToken String   @unique
  userId       String
  expires      DateTime
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
}

model User {
  id            String       @id @default(cuid())
  name          String?
  email         String?      @unique
  emailVerified DateTime?
  image         String?
  accounts      Account[]
  sessions      Session[]
  entries       DiaryEntry[]
  createdAt     DateTime     @default(now())
}

model VerificationToken {
  identifier String
  token      String   @unique
  expires    DateTime

  @@unique([identifier, token])
}

// Application Models
model DiaryEntry {
  id             String   @id @default(cuid())
  userId         String
  user           User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  content        String   @db.Text
  
  // AI 분석 결과
  sentiment      String?  // "positive" | "negative" | "neutral"
  sentimentScore Float?   // -1.0 ~ 1.0
  aiResponse     String?  @db.Text
  keywords       String?  // JSON array string
  
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  @@index([userId, createdAt(sort: Desc)])
}
```

### 5.3 인덱스 전략
- `User.email`: 로그인 조회 최적화
- `DiaryEntry.userId + createdAt`: 사용자별 일기 목록 조회 최적화
- `Account.userId`: 사용자-계정 조인 최적화
- `Session.userId`: 세션 조회 최적화

---

## 6. API 설계

### 6.1 API 엔드포인트 목록

#### Authentication APIs
- `GET /api/auth/signin` - 로그인 페이지 이동
- `POST /api/auth/callback/google` - Google OAuth 콜백
- `GET /api/auth/signout` - 로그아웃

#### Diary APIs
- `GET /api/diary` - 일기 목록 조회
- `POST /api/diary` - 일기 작성 및 AI 분석
- `GET /api/diary/[id]` - 특정 일기 조회 (선택)
- `PUT /api/diary/[id]` - 일기 수정 (선택)
- `DELETE /api/diary/[id]` - 일기 삭제 (선택)

### 6.2 API 상세 스펙

#### POST /api/diary
**설명**: 새 일기 작성 및 AI 분석

**Request**
```typescript
{
  "content": "오늘은 정말 행복한 하루였다. 친구들과 오랜만에 만나서..."
}
```

**Response** (성공 - 200)
```typescript
{
  "id": "clxxx...",
  "userId": "clyyy...",
  "content": "오늘은 정말 행복한 하루였다...",
  "sentiment": "positive",
  "sentimentScore": 0.85,
  "aiResponse": "오늘 친구들과 함께한 시간이 정말 행복하셨군요! 소중한 인연과 함께하는 순간들이 당신의 하루를 더욱 빛나게 만들어주었네요.",
  "keywords": ["행복", "친구", "만남", "추억", "감사"],
  "createdAt": "2026-07-06T10:30:00Z",
  "updatedAt": "2026-07-06T10:30:00Z"
}
```

**Response** (에러 - 401)
```typescript
{
  "error": "Unauthorized",
  "message": "로그인이 필요합니다."
}
```

**Response** (에러 - 400)
```typescript
{
  "error": "Bad Request",
  "message": "일기 내용을 입력해주세요."
}
```

#### GET /api/diary
**설명**: 현재 사용자의 일기 목록 조회

**Query Parameters**
```
?page=1&limit=10 (선택 - 페이지네이션)
```

**Response** (성공 - 200)
```typescript
{
  "entries": [
    {
      "id": "clxxx...",
      "content": "오늘은...",
      "sentiment": "positive",
      "sentimentScore": 0.85,
      "aiResponse": "...",
      "keywords": ["행복", "친구"],
      "createdAt": "2026-07-06T10:30:00Z"
    },
    // ... more entries
  ],
  "total": 25,
  "page": 1,
  "totalPages": 3
}
```

---

## 7. UI/UX 설계

### 7.1 디자인 철학

**감성적이고 따뜻한 디지털 공간**
- 일기장의 개인적이고 친밀한 느낌
- 부드러운 애니메이션으로 편안함 전달
- AI의 공감을 시각적으로 표현
- 사용자의 감정 여정을 아름답게 기록

### 7.2 타이포그래피 시스템

#### 폰트 패밀리 조합

**Display Font (제목/강조)**: **Pretendard Variable**
- 한국어 최적화된 모던 서체
- 가변 폰트로 다양한 굵기 표현
- 깔끔하고 현대적인 느낌
- Google Fonts 대안으로 CDN 사용

**Body Font (본문)**: **Noto Sans KR**
- 가독성이 뛰어난 본문용 서체
- Google Fonts 제공
- 다양한 굵기 지원 (300, 400, 500, 700)
- 부드러운 곡선으로 편안한 읽기 경험

**Accent Font (특수 강조)**: **Gowun Batang**
- 손글씨 느낌의 세리프체
- 감성적인 문구에 사용
- AI 응답 메시지에 활용
- 따뜻하고 인간적인 느낌

**Monospace (코드/숫자)**: **JetBrains Mono**
- 날짜, 숫자 표시용
- 명확한 가독성

#### 폰트 설정 (Next.js)

```typescript
// app/layout.tsx
import { Noto_Sans_KR, Gowun_Batang, JetBrains_Mono } from 'next/font/google';

const notoSansKr = Noto_Sans_KR({
  subsets: ['latin'],
  weight: ['300', '400', '500', '700'],
  variable: '--font-noto-sans',
  display: 'swap',
});

const gowunBatang = Gowun_Batang({
  subsets: ['latin'],
  weight: ['400', '700'],
  variable: '--font-gowun',
  display: 'swap',
});

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  weight: ['400', '500'],
  variable: '--font-mono',
  display: 'swap',
});
```

```css
/* Pretendard CDN */
@import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css");
```

#### 타이포그래피 스케일

```css
/* 제목 (Pretendard Variable) */
.heading-1 {
  font-family: 'Pretendard Variable', var(--font-noto-sans);
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 800;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

.heading-2 {
  font-family: 'Pretendard Variable', var(--font-noto-sans);
  font-size: clamp(1.5rem, 4vw, 2.5rem);
  font-weight: 700;
  line-height: 1.3;
  letter-spacing: -0.01em;
}

.heading-3 {
  font-family: 'Pretendard Variable', var(--font-noto-sans);
  font-size: clamp(1.25rem, 3vw, 1.875rem);
  font-weight: 600;
  line-height: 1.4;
}

/* 본문 (Noto Sans KR) */
.body-large {
  font-family: var(--font-noto-sans);
  font-size: 1.125rem;
  font-weight: 400;
  line-height: 1.8;
  letter-spacing: -0.01em;
}

.body {
  font-family: var(--font-noto-sans);
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.7;
}

.body-small {
  font-family: var(--font-noto-sans);
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1.6;
}

/* 감성 강조 (Gowun Batang) */
.accent-text {
  font-family: var(--font-gowun);
  font-size: 1.125rem;
  font-weight: 400;
  line-height: 1.9;
  letter-spacing: 0.01em;
}

/* 날짜/숫자 (JetBrains Mono) */
.mono {
  font-family: var(--font-mono);
  font-size: 0.875rem;
  font-weight: 500;
  letter-spacing: -0.02em;
}
```

### 7.3 컬러 시스템

#### 메인 컬러 팔레트

```css
/* Primary - Warm Gradient (따뜻한 그라디언트) */
--primary-50: #FFF7ED;
--primary-100: #FFEDD5;
--primary-200: #FED7AA;
--primary-300: #FDBA74;
--primary-400: #FB923C;
--primary-500: #F97316; /* Orange - 메인 */
--primary-600: #EA580C;
--primary-700: #C2410C;
--primary-800: #9A3412;
--primary-900: #7C2D12;

/* Secondary - Deep Purple (깊이감) */
--secondary-50: #FAF5FF;
--secondary-100: #F3E8FF;
--secondary-200: #E9D5FF;
--secondary-300: #D8B4FE;
--secondary-400: #C084FC;
--secondary-500: #A855F7; /* Purple */
--secondary-600: #9333EA;
--secondary-700: #7E22CE;

/* Sentiment Colors (감정 색상) */
--sentiment-positive: #34D399; /* Emerald - 부드러운 녹색 */
--sentiment-positive-light: #D1FAE5;
--sentiment-negative: #FB7185; /* Rose - 부드러운 핑크레드 */
--sentiment-negative-light: #FFE4E6;
--sentiment-neutral: #94A3B8; /* Slate - 중립적인 회색 */
--sentiment-neutral-light: #F1F5F9;

/* Background Gradients */
--gradient-warm: linear-gradient(135deg, #FFF7ED 0%, #FED7AA 100%);
--gradient-cool: linear-gradient(135deg, #F3E8FF 0%, #E9D5FF 100%);
--gradient-sunset: linear-gradient(135deg, #FDBA74 0%, #E9D5FF 50%, #A5F3FC 100%);
--gradient-aurora: linear-gradient(135deg, #FCA5A5 0%, #FBBF24 25%, #34D399 50%, #60A5FA 75%, #A78BFA 100%);

/* Glass Morphism */
--glass-bg: rgba(255, 255, 255, 0.7);
--glass-border: rgba(255, 255, 255, 0.18);
--glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);

/* Shadows */
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
--shadow-glow: 0 0 20px rgba(249, 115, 22, 0.3);
```

### 7.4 Staggered Animations (순차 애니메이션)

#### 페이지 진입 애니메이션

```typescript
// components/animations/StaggerContainer.tsx
import { motion } from 'framer-motion';

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2,
    }
  }
};

const itemVariants = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 100,
      damping: 12
    }
  }
};

export function StaggerContainer({ children }) {
  return (
    <motion.div
      variants={containerVariants}
      initial="hidden"
      animate="visible"
    >
      {children}
    </motion.div>
  );
}

export function StaggerItem({ children }) {
  return (
    <motion.div variants={itemVariants}>
      {children}
    </motion.div>
  );
}
```

#### 일기 목록 Stagger 효과

```typescript
// 일기 카드가 순차적으로 나타나는 효과
const listVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.08,
    }
  }
};

const cardVariants = {
  hidden: { 
    x: -20, 
    opacity: 0,
    scale: 0.95
  },
  visible: {
    x: 0,
    opacity: 1,
    scale: 1,
    transition: {
      type: 'spring',
      stiffness: 120,
      damping: 14
    }
  }
};
```

### 7.5 마이크로인터랙션

#### 1. 버튼 Hover/Press 효과

```css
/* Magnetic Button (자석 효과) */
.magnetic-button {
  position: relative;
  overflow: hidden;
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.magnetic-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(249, 115, 22, 0.2);
}

.magnetic-button:active {
  transform: translateY(0);
}

/* Ripple Effect */
.magnetic-button::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.magnetic-button:active::after {
  width: 300px;
  height: 300px;
}
```

#### 2. 입력 필드 Focus 애니메이션

```typescript
// Framer Motion variant
const inputVariants = {
  idle: { 
    scale: 1,
    boxShadow: '0 0 0 0px rgba(249, 115, 22, 0)'
  },
  focus: { 
    scale: 1.02,
    boxShadow: '0 0 0 3px rgba(249, 115, 22, 0.1)',
    transition: {
      type: 'spring',
      stiffness: 300,
      damping: 20
    }
  }
};

// 사용
<motion.textarea
  variants={inputVariants}
  initial="idle"
  whileFocus="focus"
  className="diary-editor"
/>
```

#### 3. AI 응답 타이핑 효과

```typescript
// components/TypewriterText.tsx
import { useState, useEffect } from 'react';

export function TypewriterText({ text, speed = 30 }) {
  const [displayText, setDisplayText] = useState('');
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    if (currentIndex < text.length) {
      const timeout = setTimeout(() => {
        setDisplayText(prev => prev + text[currentIndex]);
        setCurrentIndex(prev => prev + 1);
      }, speed);
      return () => clearTimeout(timeout);
    }
  }, [currentIndex, text, speed]);

  return (
    <motion.p
      className="accent-text"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
    >
      {displayText}
      <motion.span
        animate={{ opacity: [1, 0] }}
        transition={{ repeat: Infinity, duration: 0.8 }}
      >
        |
      </motion.span>
    </motion.p>
  );
}
```

#### 4. 감정 아이콘 애니메이션

```typescript
const sentimentIconVariants = {
  positive: {
    rotate: [0, -10, 10, -10, 0],
    scale: [1, 1.2, 1],
    transition: {
      duration: 0.6,
      ease: 'easeInOut'
    }
  },
  negative: {
    y: [0, -5, 0],
    transition: {
      duration: 0.5,
      ease: 'easeInOut'
    }
  },
  neutral: {
    rotate: [0, 5, -5, 0],
    transition: {
      duration: 0.4
    }
  }
};

<motion.div
  variants={sentimentIconVariants}
  animate={sentiment}
  className="sentiment-icon"
>
  {icon}
</motion.div>
```

#### 5. 키워드 태그 Bounce 효과

```typescript
const tagVariants = {
  hidden: { scale: 0, opacity: 0 },
  visible: (i: number) => ({
    scale: 1,
    opacity: 1,
    transition: {
      delay: i * 0.1,
      type: 'spring',
      stiffness: 260,
      damping: 20
    }
  }),
  hover: {
    scale: 1.1,
    transition: {
      type: 'spring',
      stiffness: 400,
      damping: 10
    }
  }
};

{keywords.map((keyword, i) => (
  <motion.span
    key={keyword}
    custom={i}
    variants={tagVariants}
    initial="hidden"
    animate="visible"
    whileHover="hover"
    className="keyword-tag"
  >
    #{keyword}
  </motion.span>
))}
```

#### 6. 저장 버튼 성공 애니메이션

```typescript
const buttonVariants = {
  idle: { scale: 1 },
  loading: {
    scale: [1, 0.95, 1],
    transition: {
      repeat: Infinity,
      duration: 1
    }
  },
  success: {
    scale: [1, 1.2, 1],
    backgroundColor: ['#F97316', '#34D399', '#F97316'],
    transition: {
      duration: 0.6
    }
  }
};

const checkmarkVariants = {
  hidden: { pathLength: 0, opacity: 0 },
  visible: {
    pathLength: 1,
    opacity: 1,
    transition: {
      duration: 0.5,
      ease: 'easeInOut'
    }
  }
};
```

#### 7. 일기 카드 Hover 효과

```css
.diary-card {
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.diary-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: inherit;
  background: linear-gradient(135deg, rgba(249, 115, 22, 0.1) 0%, rgba(168, 85, 247, 0.1) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.diary-card:hover {
  transform: translateY(-4px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
}

.diary-card:hover::before {
  opacity: 1;
}
```

#### 8. 로딩 애니메이션 (Skeleton)

```typescript
const shimmerVariants = {
  initial: { backgroundPosition: '-200% 0' },
  animate: {
    backgroundPosition: '200% 0',
    transition: {
      repeat: Infinity,
      duration: 1.5,
      ease: 'linear'
    }
  }
};

<motion.div
  variants={shimmerVariants}
  initial="initial"
  animate="animate"
  className="skeleton"
  style={{
    background: 'linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%)',
    backgroundSize: '200% 100%'
  }}
/>
```

### 7.6 반응형 디자인

#### 브레이크포인트
```css
/* Mobile First Approach */
--breakpoint-sm: 640px;   /* Tablet */
--breakpoint-md: 768px;   /* Tablet Landscape */
--breakpoint-lg: 1024px;  /* Desktop */
--breakpoint-xl: 1280px;  /* Large Desktop */
--breakpoint-2xl: 1536px; /* Extra Large */
```

#### 레이아웃 전략

**Mobile (0-640px)**
```
┌─────────────────────┐
│      Header         │
├─────────────────────┤
│                     │
│   Diary Editor      │
│   (Full Width)      │
│                     │
├─────────────────────┤
│                     │
│   AI Response       │
│                     │
├─────────────────────┤
│                     │
│   Diary List        │
│   (Stacked)         │
│                     │
└─────────────────────┘
```

**Desktop (1024px+)**
```
┌─────────────────────────────────────────┐
│              Header                     │
├──────────────────┬──────────────────────┤
│                  │                      │
│  Diary Editor    │    Diary List        │
│  (Left Column)   │    (Right Column)    │
│                  │    (Sticky)          │
│  ┌────────────┐  │   ┌──────────────┐  │
│  │  Textarea  │  │   │  Card 1      │  │
│  │            │  │   ├──────────────┤  │
│  └────────────┘  │   │  Card 2      │  │
│                  │   ├──────────────┤  │
│  ┌────────────┐  │   │  Card 3      │  │
│  │ AI Response│  │   └──────────────┘  │
│  └────────────┘  │                      │
│                  │                      │
└──────────────────┴──────────────────────┘
```

### 7.7 필수 패키지

```json
{
  "dependencies": {
    "framer-motion": "^11.0.0",
    "tailwindcss": "^4.0.0",
    "@tailwindcss/typography": "^0.5.10"
  }
}
```

### 7.8 Tailwind 설정

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-noto-sans)', 'Pretendard Variable', 'system-ui'],
        accent: ['var(--font-gowun)', 'serif'],
        mono: ['var(--font-mono)', 'monospace'],
      },
      colors: {
        primary: {
          50: '#FFF7ED',
          500: '#F97316',
          600: '#EA580C',
        },
        sentiment: {
          positive: '#34D399',
          negative: '#FB7185',
          neutral: '#94A3B8',
        }
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in',
        'slide-up': 'slideUp 0.5s ease-out',
        'bounce-gentle': 'bounceGentle 0.6s ease-in-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        bounceGentle: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
};
export default config;
```

---

## 8. 개발 일정

### 8.1 타임라인 (총 10일)

```
Day 1-2: 환경 설정 및 기본 구조
├─ Next.js 프로젝트 생성
├─ PostgreSQL 설정
├─ Prisma 스키마 작성
└─ Git 저장소 초기화

Day 3-4: 인증 시스템
├─ NextAuth 설정
├─ Google OAuth 연동
├─ 로그인 UI
└─ 세션 관리

Day 5-6: 일기 작성 기능
├─ 에디터 UI
├─ API 구현
├─ 상태 관리
└─ DB 저장

Day 7-8: AI 분석 기능
├─ Anthropic API 연동
├─ 감정 분석
├─ 응답 생성
└─ 키워드 추출

Day 9: 일기 히스토리 & UI 개선
├─ 목록 조회
├─ UI 컴포넌트
├─ 반응형 디자인
└─ 애니메이션

Day 10: 테스트 & 디버깅
├─ 기능 테스트
├─ 버그 수정
├─ 성능 최적화
└─ 문서화
```

### 8.2 마일스톤

- **M1 (Day 2)**: 프로젝트 기본 구조 완성
- **M2 (Day 4)**: 사용자 인증 완료
- **M3 (Day 6)**: 일기 작성/저장 기능 완료
- **M4 (Day 8)**: AI 분석 기능 완료
- **M5 (Day 10)**: MVP 완성

---

## 9. 배포 전략

### 9.1 배포 플랫폼

#### 1순위: Vercel (추천)
**장점**
- Next.js 최적화
- 자동 배포 (Git 연동)
- 서버리스 함수 무료
- PostgreSQL 통합 (Vercel Postgres)
- 글로벌 CDN
- 무료 HTTPS

**배포 절차**
```bash
# 1. Vercel CLI 설치
npm i -g vercel

# 2. 로그인
vercel login

# 3. 프로젝트 배포
vercel

# 4. 프로덕션 배포
vercel --prod
```

**환경 변수 설정**
- Vercel Dashboard에서 환경 변수 추가
- Google OAuth redirect URI 업데이트
- PostgreSQL 연결 문자열 설정

#### 2순위: Railway
**장점**
- PostgreSQL 포함
- 간단한 배포
- 합리적인 가격

#### 3순위: Render
**장점**
- 무료 플랜 제공
- DB 호스팅 포함

### 9.2 배포 체크리스트

- [ ] 환경 변수 설정 확인
- [ ] DATABASE_URL 프로덕션 DB로 변경
- [ ] Google OAuth redirect URI 추가
- [ ] ANTHROPIC_API_KEY 설정
- [ ] AUTH_SECRET 새로 생성
- [ ] Prisma 마이그레이션 실행
- [ ] 빌드 에러 확인
- [ ] HTTPS 설정
- [ ] 도메인 연결 (선택)

### 9.3 배포 후 모니터링

- **성능**: Vercel Analytics
- **에러 추적**: Sentry (선택)
- **사용자 분석**: Google Analytics (선택)
- **로그**: Vercel Logs

---

## 10. 향후 계획

### 10.1 Phase 2 기능 (1-3개월)

#### 감정 통계 대시보드
- 주간/월간 감정 변화 그래프
- 가장 많이 사용한 키워드 워드클라우드
- 긍정/부정 비율 파이 차트
- 작성 빈도 히트맵

#### 검색 및 필터
- 키워드 검색
- 날짜 범위 필터
- 감정별 필터
- 전문 검색 (Full-text search)

#### 개선 사항
- 일기 수정 기능
- 일기 삭제 기능
- 일기 내보내기 (JSON, CSV)
- 다크 모드 토글

### 10.2 Phase 3 기능 (3-6개월)

#### 멀티미디어 지원
- 사진 첨부
- 음성 녹음 일기
- 이미지 감정 분석 (Vision API)

#### 소셜 기능
- 익명 일기 공유 (선택적)
- 커뮤니티 피드
- 좋아요/댓글

#### AI 고도화
- 대화형 AI 챗봇
- 일기 작성 도우미
- 개인화된 인사이트
- 감정 패턴 예측

### 10.3 Phase 4 기능 (6-12개월)

#### 웰빙 기능
- 명상 타이머
- 감사 일기 프롬프트
- 기분 추적 리마인더
- 정신 건강 리소스 추천

#### 프리미엄 플랜
- 무제한 AI 분석
- 고급 통계
- 음성 일기 무제한
- 우선 지원

#### 모바일 앱
- React Native
- iOS/Android 네이티브 앱
- 푸시 알림
- 오프라인 모드

### 10.4 기술 부채 관리

- Unit 테스트 추가 (Jest, React Testing Library)
- E2E 테스트 (Playwright)
- CI/CD 파이프라인 (GitHub Actions)
- 성능 최적화 (Lighthouse 100점 목표)
- 접근성 개선 (WCAG 2.1 AA 준수)
- SEO 최적화
- 다국어 지원 (i18n)

---

## 부록

### A. 필수 API 키 발급 가이드

#### Google OAuth
1. https://console.cloud.google.com/ 접속
2. 프로젝트 생성
3. "APIs & Services" → "Credentials"
4. OAuth 2.0 Client ID 생성
5. Authorized redirect URIs 추가:
   - 개발: `http://localhost:3000/api/auth/callback/google`
   - 프로덕션: `https://yourdomain.com/api/auth/callback/google`

#### Anthropic API
1. https://console.anthropic.com/ 가입
2. "API Keys" → "Create Key"
3. 크레딧 확인 (신규 가입 시 무료 크레딧 제공)

### B. 참고 문서

- Next.js: https://nextjs.org/docs
- Prisma: https://www.prisma.io/docs
- NextAuth.js: https://authjs.dev/
- Anthropic: https://docs.anthropic.com/
- Tailwind CSS: https://tailwindcss.com/docs

### C. 라이선스

MIT License

---

**문서 버전**: 1.0  
**최종 수정일**: 2026-07-06  
**작성자**: AI Diary Development Team
