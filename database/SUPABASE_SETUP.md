# Supabase 설정 가이드

## 🚀 빠른 시작

### 방법 1: Supabase Dashboard에서 실행 (권장)

1. **Supabase 프로젝트 접속**
   - https://supabase.com/dashboard 접속
   - 프로젝트 선택

2. **SQL Editor 열기**
   - 좌측 메뉴에서 `SQL Editor` 클릭
   - `New query` 클릭

3. **스키마 실행**
   - `database/supabase_schema.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - `RUN` 버튼 클릭 (Ctrl/Cmd + Enter)

4. **확인**
   - 좌측 메뉴 `Table Editor`에서 테이블 확인
   - User, Account, Session, VerificationToken, DiaryEntry 5개 테이블이 있어야 함

### 방법 2: psql CLI 사용

1. **Supabase 연결 정보 가져오기**
   - Supabase Dashboard → Settings → Database
   - Connection string 복사 (Direct connection)
   
   예시:
   ```
   postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres
   ```

2. **psql 연결 및 실행**
   ```bash
   # 연결
   psql "postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres"
   
   # 또는 환경 변수 사용
   psql $DATABASE_URL
   
   # 스키마 실행
   \i database/supabase_schema.sql
   
   # 테이블 확인
   \dt
   ```

### 방법 3: Supabase CLI 사용

```bash
# Supabase CLI 설치
npm install -g supabase

# 로그인
supabase login

# 프로젝트 연결
supabase link --project-ref [YOUR-PROJECT-REF]

# 로컬에서 마이그레이션 실행
supabase db push

# 또는 원격에 직접 실행
supabase db execute -f database/supabase_schema.sql
```

---

## 📝 환경 변수 설정

### .env 파일 업데이트

Supabase 연결 정보를 `.env` 파일에 추가하세요:

```env
# Supabase Database URL
DATABASE_URL="postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true"

# Direct Connection (Prisma Migrate용)
DIRECT_URL="postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres"

# Supabase URL & Key (선택사항)
NEXT_PUBLIC_SUPABASE_URL="https://[PROJECT-REF].supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="your-anon-key"
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"

# NextAuth
AUTH_SECRET="l7XYjEylWXDgxO7/z5396GRB5eTIuuW61Jc+UFwWw1U="
AUTH_GOOGLE_ID="your-google-client-id"
AUTH_GOOGLE_SECRET="your-google-client-secret"

# Anthropic
ANTHROPIC_API_KEY="your-anthropic-api-key"
```

### Prisma Schema 업데이트

Connection pooling을 위해 `prisma/schema.prisma` 수정:

```prisma
datasource db {
  provider          = "postgresql"
  url               = env("DATABASE_URL")
  directUrl         = env("DIRECT_URL")
}
```

---

## 🔐 Row Level Security (RLS)

생성된 스키마는 RLS가 자동으로 설정됩니다:

### 사용자 권한
- ✅ 자신의 데이터만 조회/수정/삭제 가능
- ✅ 다른 사용자의 일기는 접근 불가
- ✅ NextAuth 서비스 역할은 모든 작업 가능

### 정책 확인

Supabase Dashboard에서:
1. `Authentication` → `Policies` 이동
2. 각 테이블별 정책 확인

생성된 정책:
- `Users can view own diary entries`
- `Users can insert own diary entries`
- `Users can update own diary entries`
- `Users can delete own diary entries`
- `Service role can manage all users/accounts/sessions`

---

## 🔍 연결 정보 찾기

### Dashboard에서 찾기

1. **Supabase 프로젝트** 선택
2. **Settings** → **Database** 클릭
3. **Connection string** 섹션에서:
   - **Transaction pooler**: `DATABASE_URL`로 사용
   - **Direct connection**: `DIRECT_URL`로 사용

### Connection Pooler vs Direct

| 구분 | Transaction Pooler | Direct Connection |
|-----|-------------------|-------------------|
| 포트 | 6543 | 5432 |
| 용도 | 일반 쿼리 (앱) | 마이그레이션 |
| 연결 수 | 무제한 (Pooling) | 제한 있음 |
| Prisma | `url` | `directUrl` |

---

## ✅ 설치 확인

### 1. 테이블 확인

Supabase Dashboard → Table Editor:
- ✅ User
- ✅ Account
- ✅ Session
- ✅ VerificationToken
- ✅ DiaryEntry

### 2. SQL로 확인

```sql
-- 테이블 목록
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- 인덱스 확인
SELECT indexname, tablename FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename, indexname;

-- RLS 정책 확인
SELECT schemaname, tablename, policyname FROM pg_policies WHERE schemaname = 'public';
```

### 3. Prisma 연결 테스트

```bash
# Prisma 클라이언트 생성
npm run db:generate

# 연결 테스트 (스키마 가져오기)
npx prisma db pull

# 정상이면 기존 스키마와 일치해야 함
```

---

## 🔧 Prisma와 Supabase 연동

### 1. Prisma Migrate 사용

```bash
# 첫 마이그레이션 (이미 테이블이 있는 경우)
npx prisma db push

# 또는 마이그레이션 히스토리 생성
npx prisma migrate dev --name init
```

### 2. 주의사항

⚠️ **Supabase에서 Prisma Migrate 사용 시 주의**

Supabase는 `_prisma_migrations` 테이블 관리가 다를 수 있습니다.

**권장 워크플로우:**
1. 첫 설정: `supabase_schema.sql` 실행
2. 이후 변경: Prisma Migrate 사용
3. 충돌 시: `npx prisma db push --accept-data-loss` (개발 환경만)

---

## 🎯 NextAuth와 Supabase 연동

### auth.ts 설정 (이미 완료)

```typescript
import { PrismaAdapter } from "@auth/prisma-adapter";
import { prisma } from "@/lib/db";

export const { handlers, signIn, signOut, auth } = NextAuth({
  adapter: PrismaAdapter(prisma),
  // ... 기타 설정
});
```

### 동작 원리

1. 사용자가 Google 로그인
2. NextAuth가 Supabase에 User, Account, Session 생성
3. RLS 정책으로 사용자별 데이터 격리
4. 서비스 역할 키로 NextAuth가 모든 작업 수행

---

## 📊 유용한 Supabase 쿼리

### 사용자 통계

```sql
SELECT
    u.email,
    COUNT(de.id) as total_entries,
    AVG(de."sentimentScore") as avg_sentiment,
    MAX(de."createdAt") as last_entry
FROM "User" u
LEFT JOIN "DiaryEntry" de ON u.id = de."userId"
GROUP BY u.id, u.email
ORDER BY total_entries DESC;
```

### 감정 분포

```sql
SELECT
    sentiment,
    COUNT(*) as count,
    ROUND(AVG("sentimentScore")::numeric, 2) as avg_score
FROM "DiaryEntry"
WHERE sentiment IS NOT NULL
GROUP BY sentiment;
```

### 최근 활동

```sql
SELECT
    DATE("createdAt") as date,
    COUNT(*) as entries,
    AVG("sentimentScore") as avg_sentiment
FROM "DiaryEntry"
WHERE "createdAt" >= NOW() - INTERVAL '7 days'
GROUP BY DATE("createdAt")
ORDER BY date DESC;
```

---

## 🐛 문제 해결

### 연결 오류

```bash
# 연결 테스트
psql $DATABASE_URL -c "SELECT version();"

# Prisma 연결 테스트
npx prisma db pull
```

### RLS 오류 ("new row violates row-level security policy")

- NextAuth가 서비스 역할 키를 사용하는지 확인
- `.env`의 `DATABASE_URL`이 올바른지 확인
- Supabase의 서비스 역할 정책이 있는지 확인

### 마이그레이션 충돌

```bash
# 현재 상태 확인
npx prisma migrate status

# 강제 동기화 (⚠️ 개발 환경만)
npx prisma db push --accept-data-loss

# 마이그레이션 초기화
npx prisma migrate reset
```

---

## 🔒 보안 체크리스트

- [ ] RLS 정책이 모든 테이블에 활성화되었는지 확인
- [ ] 서비스 역할 키를 `.env`에만 저장 (커밋 금지)
- [ ] Anon 키는 클라이언트에서 사용 가능 (공개 가능)
- [ ] Production 환경에서는 IP 화이트리스트 설정
- [ ] SSL 모드 활성화 (`?sslmode=require`)

---

## 📖 추가 리소스

- [Supabase 문서](https://supabase.com/docs)
- [Prisma + Supabase 가이드](https://supabase.com/docs/guides/integrations/prisma)
- [NextAuth + Supabase](https://authjs.dev/reference/adapter/supabase)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

## ✨ 다음 단계

테이블 생성 완료 후:

1. ✅ Prisma 클라이언트 생성: `npm run db:generate`
2. ✅ 개발 서버 실행: `npm run dev`
3. ✅ Google OAuth 설정
4. ✅ Anthropic API 키 설정
5. ✅ 첫 일기 작성 테스트!

---

**Supabase + AI 일기장 = 완벽한 조합! 🎉**
