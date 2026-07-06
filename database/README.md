# 데이터베이스 스키마 문서

이 디렉토리는 AI 일기장 프로젝트의 데이터베이스 스키마 관련 파일을 포함합니다.

## 파일 목록

- `schema.sql` - PostgreSQL 순수 SQL 스키마 파일
- `README.md` - 이 문서

## 사용 방법

### 방법 1: Prisma 사용 (권장)

프로젝트는 Prisma를 사용하므로, 일반적으로 다음 명령어를 사용합니다:

```bash
# Prisma 마이그레이션 생성 및 적용
npm run db:migrate

# 또는 직접 실행
npx prisma migrate dev --name init
```

### 방법 2: 순수 SQL 사용

`schema.sql` 파일을 직접 실행하려면:

```bash
# PostgreSQL에 접속
psql -U postgres

# 데이터베이스 생성
CREATE DATABASE ai_diary;
\c ai_diary;

# 스키마 파일 실행
\i database/schema.sql

# 또는 명령줄에서 직접
psql -U postgres -d ai_diary -f database/schema.sql
```

## 스키마 개요

### 테이블 구조

```
User (사용자)
 ├── Account (OAuth 계정)
 ├── Session (세션)
 └── DiaryEntry (일기) ⭐

VerificationToken (인증 토큰)
```

### 주요 테이블

#### User
- NextAuth.js 사용자 테이블
- Google OAuth 로그인 정보 저장

#### DiaryEntry (핵심)
- 사용자 일기 및 AI 분석 결과
- 필드:
  - `content`: 일기 본문
  - `sentiment`: 감정 분류 (positive/negative/neutral)
  - `sentimentScore`: -1.0 ~ 1.0 감정 점수
  - `aiResponse`: AI의 위로/응원 메시지
  - `keywords`: JSON 배열 형태의 키워드

## 인덱스 전략

성능 최적화를 위한 인덱스:

1. `User.email` - 로그인 조회 최적화
2. `DiaryEntry.userId + createdAt DESC` - 사용자별 일기 목록 최적화
3. `Account.provider + providerAccountId` - OAuth 조회 최적화
4. `Session.sessionToken` - 세션 검증 최적화

## 데이터 타입

- `id`: TEXT (cuid 형식)
- `email`: TEXT (UNIQUE)
- `content`, `aiResponse`: TEXT
- `sentimentScore`: DOUBLE PRECISION (-1.0 ~ 1.0)
- `createdAt`, `updatedAt`: TIMESTAMP(3)
- `keywords`: TEXT (JSON string)

## 제약조건

### Foreign Keys (CASCADE)
- `Account.userId` → `User.id`
- `Session.userId` → `User.id`
- `DiaryEntry.userId` → `User.id`

사용자 삭제 시 관련 데이터도 모두 삭제됩니다.

### Unique Constraints
- `User.email`
- `Session.sessionToken`
- `Account.provider + providerAccountId`
- `VerificationToken.identifier + token`

## 마이그레이션 히스토리

Prisma 마이그레이션은 `prisma/migrations/` 디렉토리에서 관리됩니다.

### 초기 마이그레이션
```bash
npx prisma migrate dev --name init
```

### 스키마 변경 시
1. `prisma/schema.prisma` 수정
2. `npx prisma migrate dev --name descriptive_name` 실행
3. Prisma Client 자동 재생성

## 유용한 쿼리

### 사용자별 일기 통계
```sql
SELECT
    u.name,
    COUNT(de.id) as total_entries,
    AVG(de."sentimentScore") as avg_sentiment
FROM "User" u
LEFT JOIN "DiaryEntry" de ON u.id = de."userId"
GROUP BY u.id, u.name;
```

### 최근 일기 조회
```sql
SELECT
    de.content,
    de.sentiment,
    de."aiResponse",
    de."createdAt"
FROM "DiaryEntry" de
JOIN "User" u ON de."userId" = u.id
WHERE u.email = 'user@example.com'
ORDER BY de."createdAt" DESC
LIMIT 10;
```

### 감정별 분포
```sql
SELECT
    sentiment,
    COUNT(*) as count,
    ROUND(AVG("sentimentScore")::numeric, 2) as avg_score
FROM "DiaryEntry"
WHERE sentiment IS NOT NULL
GROUP BY sentiment;
```

## 백업 및 복원

### 백업
```bash
pg_dump -U postgres -d ai_diary -F c -f backup_$(date +%Y%m%d).dump
```

### 복원
```bash
pg_restore -U postgres -d ai_diary -v backup_20260706.dump
```

## 프로덕션 체크리스트

- [ ] 데이터베이스 사용자 권한 최소화
- [ ] SSL/TLS 연결 설정
- [ ] 정기 백업 스케줄 설정
- [ ] 모니터링 및 알림 설정
- [ ] Connection pooling 설정 (PgBouncer 등)
- [ ] 인덱스 성능 모니터링

## 참고 자료

- [Prisma 문서](https://www.prisma.io/docs)
- [NextAuth.js 데이터베이스 어댑터](https://authjs.dev/reference/adapter/prisma)
- [PostgreSQL 문서](https://www.postgresql.org/docs/)
