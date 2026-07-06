# 환경 변수 설정 가이드

## 📋 개요

AI 일기장 프로젝트를 실행하기 위해서는 다음 3가지 서비스의 인증 정보가 필요합니다:

1. **Supabase** - PostgreSQL 데이터베이스
2. **Google OAuth** - 사용자 로그인
3. **Anthropic Claude** - AI 감정 분석

---

## 🗄️ 1. Supabase 데이터베이스 설정

### 연결 정보 확인

프로젝트 ID: `vchioloidufwzahaleoi`

1. **Supabase Dashboard 접속**
   ```
   https://supabase.com/dashboard/project/vchioloidufwzahaleoi
   ```

2. **Connect 버튼 클릭**
   - 상단 메뉴에서 녹색 "Connect" 버튼 클릭

3. **Direct 탭 선택**

4. **Transaction pooler 연결 문자열 복사**
   - Connection Method: "Transaction pooler" 선택
   - 연결 문자열 형식:
     ```
     postgresql://postgres.vchioloidufwzahaleoi:[YOUR-PASSWORD]@aws-0-ap-northeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
     ```
   - `.env` 파일의 `DATABASE_URL`에 붙여넣기

5. **Direct connection 연결 문자열 복사**
   - Connection Method: "Direct connection" 선택
   - 연결 문자열 형식:
     ```
     postgresql://postgres:[YOUR-PASSWORD]@db.vchioloidufwzahaleoi.supabase.co:5432/postgres
     ```
   - `.env` 파일의 `DIRECT_URL`에 붙여넣기

6. **비밀번호 교체**
   - `[YOUR-PASSWORD]`를 Supabase 프로젝트 생성 시 설정한 실제 데이터베이스 비밀번호로 교체
   - ⚠️ 비밀번호를 잊어버렸다면 "Reset password" 버튼으로 재설정 가능

### 연결 차이점

| 구분 | DATABASE_URL | DIRECT_URL |
|-----|--------------|------------|
| 포트 | 6543 | 5432 |
| 용도 | 일반 쿼리 (앱 실행) | 마이그레이션 |
| Pooling | ✅ pgbouncer | ❌ |
| 동시 연결 | 무제한 | 제한 있음 |

---

## 🔐 2. Google OAuth 설정

### Google Cloud Console 설정

1. **Google Cloud Console 접속**
   ```
   https://console.cloud.google.com/
   ```

2. **프로젝트 생성 또는 선택**
   - 상단에서 프로젝트 선택 드롭다운 클릭
   - "새 프로젝트" 클릭 (또는 기존 프로젝트 선택)
   - 프로젝트 이름: `AI-Diary` (원하는 이름 입력)

3. **OAuth 동의 화면 구성**
   - 좌측 메뉴: APIs & Services → OAuth consent screen
   - User Type: External 선택
   - 앱 이름: `AI 일기장`
   - 사용자 지원 이메일: 본인 이메일
   - 개발자 연락처 정보: 본인 이메일
   - 저장

4. **OAuth 2.0 Client ID 생성**
   - 좌측 메뉴: APIs & Services → Credentials
   - "+ CREATE CREDENTIALS" 클릭
   - "OAuth 2.0 Client IDs" 선택

5. **애플리케이션 유형 설정**
   - Application type: **Web application**
   - Name: `AI Diary Web Client`

6. **Authorized redirect URIs 추가**
   
   **개발 환경:**
   ```
   http://localhost:3000/api/auth/callback/google
   ```
   
   **프로덕션 환경 (배포 시):**
   ```
   https://your-domain.com/api/auth/callback/google
   ```
   
   ⚠️ **주의:** 정확히 `/api/auth/callback/google` 경로를 사용해야 합니다.

7. **Client ID와 Client Secret 복사**
   - 생성 후 나타나는 팝업에서 복사
   - `.env` 파일에 붙여넣기:
     ```env
     AUTH_GOOGLE_ID="123456789-abcdefg.apps.googleusercontent.com"
     AUTH_GOOGLE_SECRET="GOCSPX-abc123def456..."
     ```

---

## 🤖 3. Anthropic Claude API 설정

### API Key 발급

1. **Anthropic Console 접속**
   ```
   https://console.anthropic.com/
   ```

2. **계정 생성 또는 로그인**
   - GitHub, Google 계정으로 로그인 가능

3. **API Keys 메뉴 이동**
   - 좌측 메뉴에서 "API Keys" 클릭

4. **새 키 생성**
   - "+ Create Key" 버튼 클릭
   - Name: `AI-Diary` (원하는 이름)
   - Create

5. **키 복사**
   - 생성된 키 복사 (형식: `sk-ant-api03-...`)
   - ⚠️ **주의:** 키는 한 번만 표시되므로 즉시 복사해야 합니다
   - `.env` 파일에 붙여넣기:
     ```env
     ANTHROPIC_API_KEY="sk-ant-api03-xxxxxxxxxxxxxxxxxxxx"
     ```

6. **크레딧 확인**
   - 계정 생성 시 무료 크레딧 제공
   - Settings → Billing에서 사용량 확인 가능

---

## ✅ 설정 완료 확인

### .env 파일 예시

```env
# ============================================
# Supabase Database
# ============================================

DATABASE_URL="postgresql://postgres.vchioloidufwzahaleoi:MY_REAL_PASSWORD@aws-0-ap-northeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://postgres:MY_REAL_PASSWORD@db.vchioloidufwzahaleoi.supabase.co:5432/postgres"

# ============================================
# NextAuth
# ============================================

AUTH_SECRET="l7XYjEylWXDgxO7/z5396GRB5eTIuuW61Jc+UFwWw1U="
AUTH_GOOGLE_ID="123456789-abcdefg.apps.googleusercontent.com"
AUTH_GOOGLE_SECRET="GOCSPX-abc123def456..."

# ============================================
# Anthropic API
# ============================================

ANTHROPIC_API_KEY="sk-ant-api03-xxxxxxxxxxxxxxxxxxxx"
```

### 연결 테스트

```bash
# 1. Prisma 클라이언트 생성
npm run db:generate

# 2. Supabase 연결 테스트
npx prisma db pull

# 성공 시 메시지:
# ✔ Introspected 5 models and wrote them into prisma/schema.prisma

# 3. 개발 서버 실행
npm run dev

# 4. 브라우저에서 확인
# http://localhost:3000
```

---

## 🐛 문제 해결

### Supabase 연결 오류

```
Error: Can't reach database server at...
```

**해결 방법:**
1. DATABASE_URL과 DIRECT_URL의 비밀번호가 올바른지 확인
2. Supabase Dashboard에서 프로젝트가 활성화되어 있는지 확인
3. 방화벽 설정 확인 (포트 5432, 6543 허용)

### Google OAuth 오류

```
Error: redirect_uri_mismatch
```

**해결 방법:**
1. Google Cloud Console의 Authorized redirect URIs 확인
2. `http://localhost:3000/api/auth/callback/google` 정확히 일치하는지 확인
3. 포트 번호 확인 (개발 서버가 3000번 포트에서 실행되는지)

### Anthropic API 오류

```
Error: 401 Unauthorized
```

**해결 방법:**
1. API Key가 올바르게 복사되었는지 확인
2. 공백이나 줄바꿈이 포함되지 않았는지 확인
3. Anthropic Console에서 API Key가 활성화되어 있는지 확인

---

## 🔒 보안 주의사항

### ⚠️ 중요: .env 파일 관리

1. **절대 커밋하지 말 것**
   - `.env` 파일은 `.gitignore`에 포함되어 있습니다
   - GitHub, GitLab 등 공개 저장소에 업로드 금지

2. **비밀번호 공유 금지**
   - Slack, Discord 등에 환경 변수 공유 금지
   - 팀원과 공유 시 암호화된 채널 사용

3. **정기적인 키 갱신**
   - API Key는 주기적으로 재발급 권장
   - 유출 의심 시 즉시 재발급

4. **프로덕션 환경 분리**
   - 개발 환경과 프로덕션 환경의 키 분리 사용
   - 프로덕션 키는 환경 변수로 주입 (Vercel, Netlify 등)

---

## 📖 다음 단계

환경 변수 설정이 완료되었다면:

1. ✅ Prisma 클라이언트 생성: `npm run db:generate`
2. ✅ 개발 서버 실행: `npm run dev`
3. ✅ Google 로그인 테스트
4. ✅ 첫 일기 작성 및 AI 분석 확인

---

**설정 완료! 이제 AI 일기장을 사용할 준비가 되었습니다. 🎉**
