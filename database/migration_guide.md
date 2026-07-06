# 데이터베이스 마이그레이션 가이드

## 빠른 시작

### 1. 로컬 개발 환경 설정

```bash
# PostgreSQL 설치 확인
psql --version

# PostgreSQL 서비스 시작 (macOS)
brew services start postgresql@14

# 또는 (Linux)
sudo systemctl start postgresql
```

### 2. 데이터베이스 생성

```bash
# PostgreSQL 접속
psql -U postgres

# 데이터베이스 생성
CREATE DATABASE ai_diary;

# 사용자 생성 (옵션)
CREATE USER ai_diary_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE ai_diary TO ai_diary_user;

# 종료
\q
```

### 3. 환경 변수 설정

`.env` 파일에 연결 문자열 추가:

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/ai_diary?schema=public"

# 또는 커스텀 사용자 사용 시
DATABASE_URL="postgresql://ai_diary_user:your_password@localhost:5432/ai_diary?schema=public"
```

### 4. Prisma 마이그레이션 실행

```bash
# 방법 1: npm 스크립트 사용 (권장)
npm run db:migrate

# 방법 2: Prisma CLI 직접 사용
npx prisma migrate dev --name init

# 방법 3: 프로덕션 환경
npx prisma migrate deploy
```

## Prisma vs 순수 SQL

### Prisma 사용 (권장) ✅

**장점:**
- 타입 안전성
- 자동 마이그레이션 히스토리
- ORM 기능
- 롤백 지원

**사용 시기:**
- 일반적인 개발
- 로컬 환경
- 프로덕션 배포

### 순수 SQL 사용

**장점:**
- 완전한 제어
- 데이터베이스 독립적 백업
- 수동 튜닝 가능

**사용 시기:**
- 데이터베이스 초기 설정
- 수동 마이그레이션 필요 시
- Prisma 없이 스키마만 필요할 때

```bash
psql -U postgres -d ai_diary -f database/schema.sql
```

## 마이그레이션 워크플로우

### 개발 중 스키마 변경

1. **Prisma 스키마 수정**
   ```prisma
   // prisma/schema.prisma
   model DiaryEntry {
     // ... 기존 필드
     newField String? // 새 필드 추가
   }
   ```

2. **마이그레이션 생성**
   ```bash
   npx prisma migrate dev --name add_new_field
   ```

3. **변경사항 확인**
   ```bash
   # 생성된 마이그레이션 파일 확인
   cat prisma/migrations/20260706_add_new_field/migration.sql
   ```

4. **테스트**
   ```bash
   npm run dev
   # 기능 테스트
   ```

### 프로덕션 배포

1. **마이그레이션 검증**
   ```bash
   # 로컬에서 프로덕션 모드로 테스트
   npx prisma migrate deploy --preview
   ```

2. **백업 생성**
   ```bash
   pg_dump -U postgres -d ai_diary -F c -f backup_before_migration.dump
   ```

3. **배포**
   ```bash
   # 프로덕션 환경에서
   npx prisma migrate deploy
   ```

4. **롤백 (필요시)**
   ```bash
   # 백업에서 복원
   pg_restore -U postgres -d ai_diary -c backup_before_migration.dump
   ```

## 일반적인 마이그레이션 시나리오

### 새 컬럼 추가

```bash
# 1. schema.prisma 수정
# 2. 마이그레이션 생성
npx prisma migrate dev --name add_column_name

# 생성된 SQL 예시:
# ALTER TABLE "DiaryEntry" ADD COLUMN "newColumn" TEXT;
```

### 컬럼 삭제

```bash
# ⚠️ 주의: 데이터 손실 가능
npx prisma migrate dev --name remove_column_name

# 생성된 SQL 예시:
# ALTER TABLE "DiaryEntry" DROP COLUMN "oldColumn";
```

### 인덱스 추가

```bash
npx prisma migrate dev --name add_index_on_field

# schema.prisma:
# @@index([fieldName])
```

### 관계 변경

```bash
npx prisma migrate dev --name update_relation

# 외래 키 제약조건 변경 등
```

## 데이터 마이그레이션

### 데이터 변환이 필요한 경우

1. **마이그레이션 생성**
   ```bash
   npx prisma migrate dev --name data_transformation --create-only
   ```

2. **생성된 SQL 파일 수정**
   ```sql
   -- prisma/migrations/.../migration.sql
   
   -- 스키마 변경
   ALTER TABLE "DiaryEntry" ADD COLUMN "processedKeywords" TEXT;
   
   -- 데이터 변환
   UPDATE "DiaryEntry"
   SET "processedKeywords" = LOWER(keywords)
   WHERE keywords IS NOT NULL;
   ```

3. **적용**
   ```bash
   npx prisma migrate dev
   ```

## 문제 해결

### 마이그레이션 충돌

```bash
# 마이그레이션 상태 확인
npx prisma migrate status

# 마이그레이션 초기화 (⚠️ 개발 환경만)
npx prisma migrate reset

# 특정 마이그레이션으로 롤백 (수동)
# 1. 백업 복원
# 2. 원하는 시점의 마이그레이션까지 재적용
```

### Prisma Client 동기화 문제

```bash
# Prisma Client 재생성
npx prisma generate

# 또는
npm run db:generate
```

### 데이터베이스 연결 실패

```bash
# 연결 테스트
npx prisma db pull

# DATABASE_URL 확인
echo $DATABASE_URL

# PostgreSQL 서비스 확인
pg_isready
```

## 프로덕션 베스트 프랙티스

### 1. 항상 백업 먼저

```bash
# 자동 백업 스크립트
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -U postgres -d ai_diary -F c -f "backup_${DATE}.dump"
echo "Backup created: backup_${DATE}.dump"
```

### 2. 마이그레이션 테스트

```bash
# 스테이징 환경에서 먼저 테스트
DATABASE_URL="postgresql://..." npx prisma migrate deploy
```

### 3. 다운타임 최소화

```bash
# 1. 읽기 전용 모드 활성화 (애플리케이션 레벨)
# 2. 마이그레이션 실행
# 3. 검증
# 4. 일반 모드 복구
```

### 4. 롤백 계획

```sql
-- 각 마이그레이션마다 롤백 SQL 준비
-- migration_up.sql
ALTER TABLE "DiaryEntry" ADD COLUMN "newField" TEXT;

-- migration_down.sql (롤백용)
ALTER TABLE "DiaryEntry" DROP COLUMN "newField";
```

## 모니터링

### 마이그레이션 히스토리 확인

```sql
SELECT * FROM "_prisma_migrations"
ORDER BY started_at DESC;
```

### 테이블 크기 확인

```sql
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### 인덱스 사용 통계

```sql
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

## 참고 명령어

```bash
# Prisma Studio (DB GUI)
npm run db:studio

# 스키마 포맷팅
npx prisma format

# 스키마 검증
npx prisma validate

# 데이터베이스 스키마 가져오기
npx prisma db pull

# 데이터베이스에 스키마 강제 푸시 (⚠️ 개발 환경만)
npx prisma db push
```

## 추가 리소스

- [Prisma Migrate 문서](https://www.prisma.io/docs/concepts/components/prisma-migrate)
- [PostgreSQL 마이그레이션 가이드](https://www.postgresql.org/docs/current/ddl-alter.html)
- [데이터베이스 백업 전략](https://www.postgresql.org/docs/current/backup.html)
