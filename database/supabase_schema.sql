-- ============================================
-- AI 일기장 - Supabase 스키마
-- ============================================
-- Supabase SQL Editor에서 실행하세요
-- 또는 psql로 직접 연결

-- ============================================
-- 1. 테이블 생성
-- ============================================

-- User 테이블
CREATE TABLE IF NOT EXISTS "User" (
    id TEXT PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    "emailVerified" TIMESTAMP WITH TIME ZONE,
    image TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Account 테이블 (OAuth)
CREATE TABLE IF NOT EXISTS "Account" (
    id TEXT PRIMARY KEY,
    "userId" TEXT NOT NULL,
    type TEXT NOT NULL,
    provider TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    refresh_token TEXT,
    access_token TEXT,
    expires_at INTEGER,
    token_type TEXT,
    scope TEXT,
    id_token TEXT,
    session_state TEXT,
    CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId")
        REFERENCES "User"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Session 테이블
CREATE TABLE IF NOT EXISTS "Session" (
    id TEXT PRIMARY KEY,
    "sessionToken" TEXT NOT NULL UNIQUE,
    "userId" TEXT NOT NULL,
    expires TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId")
        REFERENCES "User"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- VerificationToken 테이블
CREATE TABLE IF NOT EXISTS "VerificationToken" (
    identifier TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    expires TIMESTAMP WITH TIME ZONE NOT NULL
);

-- DiaryEntry 테이블 (핵심)
CREATE TABLE IF NOT EXISTS "DiaryEntry" (
    id TEXT PRIMARY KEY,
    "userId" TEXT NOT NULL,
    content TEXT NOT NULL,
    sentiment TEXT,
    "sentimentScore" DOUBLE PRECISION,
    "aiResponse" TEXT,
    keywords TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT "DiaryEntry_userId_fkey" FOREIGN KEY ("userId")
        REFERENCES "User"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================
-- 2. 인덱스 생성
-- ============================================

-- User 인덱스
CREATE INDEX IF NOT EXISTS "User_email_idx" ON "User"(email);

-- Account 인덱스
CREATE UNIQUE INDEX IF NOT EXISTS "Account_provider_providerAccountId_key"
    ON "Account"(provider, "providerAccountId");
CREATE INDEX IF NOT EXISTS "Account_userId_idx" ON "Account"("userId");

-- Session 인덱스
CREATE INDEX IF NOT EXISTS "Session_userId_idx" ON "Session"("userId");

-- VerificationToken 인덱스
CREATE UNIQUE INDEX IF NOT EXISTS "VerificationToken_identifier_token_key"
    ON "VerificationToken"(identifier, token);

-- DiaryEntry 인덱스 (중요!)
CREATE INDEX IF NOT EXISTS "DiaryEntry_userId_createdAt_idx"
    ON "DiaryEntry"("userId", "createdAt" DESC);

-- ============================================
-- 3. 트리거 (자동 updatedAt)
-- ============================================

-- updatedAt 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DiaryEntry 트리거
DROP TRIGGER IF EXISTS update_diaryentry_updated_at ON "DiaryEntry";
CREATE TRIGGER update_diaryentry_updated_at
    BEFORE UPDATE ON "DiaryEntry"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 4. Row Level Security (RLS) 설정
-- ============================================

-- RLS 활성화
ALTER TABLE "User" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Account" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Session" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "VerificationToken" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "DiaryEntry" ENABLE ROW LEVEL SECURITY;

-- User 정책
CREATE POLICY "Users can view own data"
    ON "User" FOR SELECT
    USING (auth.uid()::text = id);

CREATE POLICY "Users can update own data"
    ON "User" FOR UPDATE
    USING (auth.uid()::text = id);

-- Account 정책
CREATE POLICY "Users can view own accounts"
    ON "Account" FOR SELECT
    USING (auth.uid()::text = "userId");

-- Session 정책
CREATE POLICY "Users can view own sessions"
    ON "Session" FOR SELECT
    USING (auth.uid()::text = "userId");

-- DiaryEntry 정책 (핵심)
CREATE POLICY "Users can view own diary entries"
    ON "DiaryEntry" FOR SELECT
    USING (auth.uid()::text = "userId");

CREATE POLICY "Users can insert own diary entries"
    ON "DiaryEntry" FOR INSERT
    WITH CHECK (auth.uid()::text = "userId");

CREATE POLICY "Users can update own diary entries"
    ON "DiaryEntry" FOR UPDATE
    USING (auth.uid()::text = "userId");

CREATE POLICY "Users can delete own diary entries"
    ON "DiaryEntry" FOR DELETE
    USING (auth.uid()::text = "userId");

-- ============================================
-- 5. 서비스 역할 정책 (NextAuth용)
-- ============================================

-- NextAuth가 서비스 키로 모든 작업 가능하도록 설정
CREATE POLICY "Service role can manage all users"
    ON "User" FOR ALL
    USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all accounts"
    ON "Account" FOR ALL
    USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all sessions"
    ON "Session" FOR ALL
    USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all verification tokens"
    ON "VerificationToken" FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================
-- 6. 테이블 주석
-- ============================================

COMMENT ON TABLE "User" IS 'NextAuth 사용자 테이블';
COMMENT ON TABLE "Account" IS 'NextAuth OAuth 계정 연동';
COMMENT ON TABLE "Session" IS 'NextAuth 세션 관리';
COMMENT ON TABLE "VerificationToken" IS 'NextAuth 이메일 인증 토큰';
COMMENT ON TABLE "DiaryEntry" IS '사용자 일기 및 AI 분석 결과';

COMMENT ON COLUMN "DiaryEntry".sentiment IS '감정: positive | negative | neutral';
COMMENT ON COLUMN "DiaryEntry"."sentimentScore" IS '감정 점수: -1.0 ~ 1.0';
COMMENT ON COLUMN "DiaryEntry"."aiResponse" IS 'AI 위로/응원 메시지';
COMMENT ON COLUMN "DiaryEntry".keywords IS 'JSON 배열 문자열';

-- ============================================
-- 완료!
-- ============================================

-- 테이블 생성 확인
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
