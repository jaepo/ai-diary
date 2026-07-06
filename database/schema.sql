-- AI 일기장 데이터베이스 스키마
-- PostgreSQL 14+
-- Generated from plan.md database design

-- ============================================
-- 1. 데이터베이스 생성 (옵션)
-- ============================================

-- 새 데이터베이스 생성 (필요시)
-- CREATE DATABASE ai_diary;
-- \c ai_diary;

-- ============================================
-- 2. Extension 설치
-- ============================================

-- UUID 생성을 위한 확장 (cuid 대신 사용 가능)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 3. 테이블 생성
-- ============================================

-- 3.1 User 테이블
CREATE TABLE "User" (
    id TEXT PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    "emailVerified" TIMESTAMP(3),
    image TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE "User" IS 'NextAuth 사용자 테이블';
COMMENT ON COLUMN "User".id IS 'cuid 형식의 고유 ID';
COMMENT ON COLUMN "User".email IS '사용자 이메일 (로그인용)';
COMMENT ON COLUMN "User"."emailVerified" IS '이메일 인증 완료 시각';

-- 3.2 Account 테이블 (OAuth 계정 정보)
CREATE TABLE "Account" (
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

COMMENT ON TABLE "Account" IS 'NextAuth OAuth 계정 연동 정보';
COMMENT ON COLUMN "Account".provider IS 'OAuth 제공자 (google 등)';
COMMENT ON COLUMN "Account"."providerAccountId" IS '제공자의 사용자 ID';

-- 3.3 Session 테이블
CREATE TABLE "Session" (
    id TEXT PRIMARY KEY,
    "sessionToken" TEXT NOT NULL UNIQUE,
    "userId" TEXT NOT NULL,
    expires TIMESTAMP(3) NOT NULL,
    CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId")
        REFERENCES "User"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE "Session" IS 'NextAuth 세션 관리';
COMMENT ON COLUMN "Session"."sessionToken" IS '세션 토큰 (쿠키에 저장)';

-- 3.4 VerificationToken 테이블
CREATE TABLE "VerificationToken" (
    identifier TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    expires TIMESTAMP(3) NOT NULL
);

COMMENT ON TABLE "VerificationToken" IS 'NextAuth 이메일 인증 토큰';

-- 3.5 DiaryEntry 테이블 (핵심 애플리케이션 테이블)
CREATE TABLE "DiaryEntry" (
    id TEXT PRIMARY KEY,
    "userId" TEXT NOT NULL,
    content TEXT NOT NULL,
    sentiment TEXT,
    "sentimentScore" DOUBLE PRECISION,
    "aiResponse" TEXT,
    keywords TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "DiaryEntry_userId_fkey" FOREIGN KEY ("userId")
        REFERENCES "User"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE "DiaryEntry" IS '사용자 일기 및 AI 분석 결과';
COMMENT ON COLUMN "DiaryEntry".content IS '일기 본문';
COMMENT ON COLUMN "DiaryEntry".sentiment IS '감정 분류: positive | negative | neutral';
COMMENT ON COLUMN "DiaryEntry"."sentimentScore" IS '감정 점수: -1.0 (부정) ~ 1.0 (긍정)';
COMMENT ON COLUMN "DiaryEntry"."aiResponse" IS 'AI의 위로/응원 메시지';
COMMENT ON COLUMN "DiaryEntry".keywords IS 'JSON 배열 문자열 형태의 키워드 목록';

-- ============================================
-- 4. 인덱스 생성
-- ============================================

-- 4.1 User 인덱스
CREATE INDEX "User_email_idx" ON "User"(email);

-- 4.2 Account 인덱스
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key"
    ON "Account"(provider, "providerAccountId");
CREATE INDEX "Account_userId_idx" ON "Account"("userId");

-- 4.3 Session 인덱스
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- 4.4 VerificationToken 인덱스
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key"
    ON "VerificationToken"(identifier, token);

-- 4.5 DiaryEntry 인덱스 (성능 최적화)
CREATE INDEX "DiaryEntry_userId_createdAt_idx"
    ON "DiaryEntry"("userId", "createdAt" DESC);

COMMENT ON INDEX "DiaryEntry_userId_createdAt_idx" IS '사용자별 일기 목록 조회 최적화 (최신순)';

-- ============================================
-- 5. 트리거 (자동 updatedAt 갱신)
-- ============================================

-- DiaryEntry updatedAt 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DiaryEntry 트리거 생성
CREATE TRIGGER update_diaryentry_updated_at
    BEFORE UPDATE ON "DiaryEntry"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 6. 샘플 데이터 (선택 사항)
-- ============================================

-- 테스트용 사용자 (실제로는 NextAuth가 생성)
/*
INSERT INTO "User" (id, name, email, "createdAt")
VALUES
    ('cm0test001', '테스트 사용자', 'test@example.com', CURRENT_TIMESTAMP);

-- 샘플 일기
INSERT INTO "DiaryEntry" (
    id, "userId", content, sentiment, "sentimentScore",
    "aiResponse", keywords, "createdAt", "updatedAt"
)
VALUES
    (
        'cm0entry001',
        'cm0test001',
        '오늘은 정말 행복한 하루였다. 친구들과 오랜만에 만나서 즐거운 시간을 보냈다.',
        'positive',
        0.85,
        '친구들과 함께한 시간이 정말 행복하셨군요! 소중한 인연과 함께하는 순간들이 당신의 하루를 더욱 빛나게 만들어주었네요.',
        '["행복", "친구", "만남", "즐거움", "추억"]',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    );
*/

-- ============================================
-- 7. 권한 설정 (프로덕션 환경)
-- ============================================

-- 애플리케이션 전용 사용자 생성 (권장)
/*
CREATE USER ai_diary_app WITH PASSWORD 'your_secure_password';
GRANT CONNECT ON DATABASE ai_diary TO ai_diary_app;
GRANT USAGE ON SCHEMA public TO ai_diary_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ai_diary_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ai_diary_app;
*/

-- ============================================
-- 8. 유용한 쿼리
-- ============================================

-- 사용자별 일기 수 조회
/*
SELECT
    u.id,
    u.name,
    u.email,
    COUNT(de.id) as diary_count,
    MAX(de."createdAt") as last_diary_date
FROM "User" u
LEFT JOIN "DiaryEntry" de ON u.id = de."userId"
GROUP BY u.id, u.name, u.email
ORDER BY diary_count DESC;
*/

-- 감정별 일기 통계
/*
SELECT
    sentiment,
    COUNT(*) as count,
    AVG("sentimentScore") as avg_score,
    MIN("sentimentScore") as min_score,
    MAX("sentimentScore") as max_score
FROM "DiaryEntry"
WHERE sentiment IS NOT NULL
GROUP BY sentiment;
*/

-- 최근 7일간 일기 작성 추이
/*
SELECT
    DATE("createdAt") as date,
    COUNT(*) as entry_count,
    AVG("sentimentScore") as avg_sentiment
FROM "DiaryEntry"
WHERE "createdAt" >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE("createdAt")
ORDER BY date DESC;
*/

-- ============================================
-- 9. 데이터베이스 백업 명령어 (참고)
-- ============================================

-- 백업
-- pg_dump -U postgres -d ai_diary -F c -b -v -f ai_diary_backup_$(date +%Y%m%d).dump

-- 복원
-- pg_restore -U postgres -d ai_diary -v ai_diary_backup_20260706.dump
