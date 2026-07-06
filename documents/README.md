# 🌙 AI 일기장 (AI Diary)

> AI가 분석하고 위로와 응원을 보내주는 감성 일기 웹 서비스

[![Next.js](https://img.shields.io/badge/Next.js-16.2-black?logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue?logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![Framer Motion](https://img.shields.io/badge/Framer_Motion-11.0-ff69b4)](https://www.framer.com/motion/)

---

## ✨ 프로젝트 개요

일기를 작성하면 **Claude AI**가 자동으로 감정을 분석하고, 따뜻한 위로와 응원 메시지를 보내주는 서비스입니다.

### 핵심 기능

- 🔐 **Google 소셜 로그인** - 간편한 인증
- ✍️ **일기 작성** - 자유로운 텍스트 입력
- 🤖 **AI 감정 분석** - 긍정/부정/중립 분류 및 점수화
- 💬 **맞춤형 응답** - 일기 내용에 맞는 공감 메시지
- 🏷️ **키워드 추출** - 핵심 주제 자동 추출
- 📚 **일기 히스토리** - 과거 일기 및 분석 결과 조회

---

## 🎨 디자인 특징

### 아름다운 타이포그래피
- **Pretendard Variable** - 제목/강조
- **Noto Sans KR** - 본문
- **Gowun Batang** - AI 응답 (감성적)
- **JetBrains Mono** - 날짜/숫자

### Staggered 애니메이션
- 페이지 진입 시 순차적 등장
- 일기 카드 Cascade 효과
- 키워드 태그 Pop 애니메이션

### 마이크로인터랙션
- 자석 효과 버튼 (Magnetic Button)
- AI 응답 타이핑 효과
- 감정 아이콘 애니메이션
- 부드러운 Hover/Focus 상태

---

## 📁 프로젝트 문서

### 📋 [전체 계획서](./documents/plan.md)
프로젝트의 모든 것을 담은 완전한 계획서
- 서비스 기획
- 기술 스택
- 개발 계획
- 데이터베이스 설계
- API 설계
- UI/UX 설계 (폰트, 애니메이션 포함)
- 개발 일정
- 배포 전략

### 🎨 [디자인 가이드](./documents/design-guide.md)
상세한 디자인 시스템 문서
- 컬러 시스템
- 타이포그래피 상세
- 애니메이션 코드 예제
- 반응형 디자인
- 컴포넌트 스타일 가이드
- 디자인 체크리스트

### 🏗️ [기술 스택](./TECH_STACK.md)
기술 선정 이유와 아키텍처
- 선정된 기술 목록
- 아키텍처 다이어그램
- 패키지 목록
- 기술 선정 배경

### 📝 [서비스 기획](./PLANNING.md)
서비스 기획 개요
- 핵심 기능
- 사용자 시나리오
- 화면 구성

---

## 🛠️ 기술 스택

### Frontend
- **Next.js 15** - App Router
- **TypeScript 5** - 타입 안정성
- **Tailwind CSS 4** - 유틸리티 우선 스타일링
- **Framer Motion 11** - 애니메이션

### Backend
- **Next.js API Routes** - 서버리스 API
- **PostgreSQL** - 데이터베이스
- **Prisma** - ORM

### Authentication
- **NextAuth.js v5** - 인증
- **Google OAuth 2.0** - 소셜 로그인

### AI
- **Anthropic Claude** - 감정 분석 및 응답 생성
- **Claude Sonnet 4** - 최신 모델

---

## 🚀 시작하기

### 1. 환경 요구사항

- Node.js v20 이상
- PostgreSQL v14 이상
- npm 또는 yarn

### 2. 설치

```bash
# 저장소 클론
git clone https://github.com/yourusername/ai-diary.git
cd ai-diary

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env 파일 편집하여 실제 값 입력

# 데이터베이스 마이그레이션
npx prisma migrate dev

# 개발 서버 실행
npm run dev
```

### 3. 환경 변수 설정

`.env` 파일에 다음 값을 설정하세요:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/ai_diary"

# NextAuth
AUTH_SECRET="랜덤-생성-시크릿"
AUTH_GOOGLE_ID="구글-클라이언트-ID"
AUTH_GOOGLE_SECRET="구글-클라이언트-시크릿"

# Anthropic
ANTHROPIC_API_KEY="앤스로픽-API-키"
```

### 4. API 키 발급

#### Google OAuth
1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 프로젝트 생성
3. OAuth 2.0 Client ID 생성
4. Redirect URI: `http://localhost:3000/api/auth/callback/google`

#### Anthropic API
1. [Anthropic Console](https://console.anthropic.com/) 가입
2. API Key 생성
3. `.env`에 추가

---

## 📱 스크린샷

*개발 진행 후 추가 예정*

---

## 🗂️ 프로젝트 구조

```
ai-diary/
├── app/                    # Next.js App Router
│   ├── api/               # API Routes
│   ├── auth/              # 인증 페이지
│   ├── layout.tsx         # Root Layout
│   └── page.tsx           # 메인 페이지
├── components/            # React 컴포넌트
│   ├── animations/        # 애니메이션 컴포넌트
│   ├── ui/               # UI 컴포넌트
│   ├── DiaryApp.tsx      # 메인 앱
│   ├── DiaryEditor.tsx   # 일기 에디터
│   ├── DiaryList.tsx     # 일기 목록
│   └── AIResponse.tsx    # AI 응답 표시
├── lib/                   # 유틸리티
│   ├── db.ts             # Prisma 클라이언트
│   └── ai.ts             # AI 분석 로직
├── prisma/               # Prisma 설정
│   └── schema.prisma     # DB 스키마
├── documents/            # 문서
│   ├── plan.md          # 전체 계획서
│   └── design-guide.md  # 디자인 가이드
└── public/              # 정적 파일
```

---

## 📜 스크립트

```bash
# 개발 서버 실행
npm run dev

# 프로덕션 빌드
npm run build

# 프로덕션 서버 실행
npm run start

# Prisma Studio (DB GUI)
npx prisma studio

# 데이터베이스 마이그레이션
npm run db:migrate

# 데이터베이스 초기화
npm run db:reset
```

---

## 🎯 개발 로드맵

### Phase 1: MVP (10일) ✅ 계획 완료
- [x] 프로젝트 기획
- [x] 기술 스택 선정
- [x] 디자인 시스템 설계
- [ ] 개발 시작
- [ ] 기본 기능 구현
- [ ] 배포

### Phase 2: 기능 확장 (1-3개월)
- [ ] 감정 통계 대시보드
- [ ] 검색 및 필터 기능
- [ ] 일기 수정/삭제
- [ ] 다크 모드

### Phase 3: 고도화 (3-6개월)
- [ ] 사진 첨부
- [ ] 음성 일기
- [ ] AI 챗봇
- [ ] 커뮤니티 기능

---

## 🤝 기여

기여를 환영합니다! Pull Request를 보내주세요.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 라이선스

MIT License - 자유롭게 사용하세요!

---

## 👥 팀

- **기획/개발**: AI Diary Team
- **디자인**: Design System by Claude Code
- **AI 파트너**: Anthropic Claude

---

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 이슈를 등록해주세요.

---

**Made with ❤️ and AI**
