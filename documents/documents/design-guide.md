# AI 일기장 디자인 가이드

**버전**: 1.0  
**최종 수정**: 2026-07-06  

---

## 📐 디자인 철학

### 핵심 가치
- **감성적**: 따뜻하고 친밀한 느낌
- **부드러운**: 편안한 애니메이션과 곡선
- **개인적**: 사용자만의 안전한 공간
- **공감적**: AI의 따뜻한 응답을 시각적으로 표현

### 디자인 원칙
1. **Emotional First**: 감정을 최우선으로 전달
2. **Subtle Motion**: 과하지 않은 우아한 움직임
3. **Typography Hierarchy**: 명확한 타이포그래피 계층
4. **Responsive**: 모든 기기에서 아름다운 경험

---

## 🎨 컬러 시스템

### 메인 컬러 팔레트

#### Primary - Warm Orange
따뜻함과 에너지를 전달하는 오렌지 계열
```css
--primary-50: #FFF7ED   /* 배경용 */
--primary-100: #FFEDD5  /* 호버 배경 */
--primary-500: #F97316  /* 메인 CTA */
--primary-600: #EA580C  /* 호버 상태 */
--primary-700: #C2410C  /* Active 상태 */
```

**사용 예시:**
- 주요 버튼
- 링크
- 강조 요소
- 로딩 인디케이터

#### Secondary - Deep Purple
깊이와 신비로움을 전달하는 보라 계열
```css
--secondary-50: #FAF5FF
--secondary-500: #A855F7
--secondary-600: #9333EA
```

**사용 예시:**
- AI 응답 강조
- 키워드 태그
- 그라디언트 조합

#### Sentiment Colors

**Positive (긍정)**
```css
--sentiment-positive: #34D399      /* Emerald */
--sentiment-positive-light: #D1FAE5
```
- 부드러운 녹색
- 희망과 성장을 상징
- 아이콘, 배경에 사용

**Negative (부정)**
```css
--sentiment-negative: #FB7185      /* Rose */
--sentiment-negative-light: #FFE4E6
```
- 부드러운 핑크-레드
- 공격적이지 않은 색상
- 위로와 공감을 표현

**Neutral (중립)**
```css
--sentiment-neutral: #94A3B8       /* Slate */
--sentiment-neutral-light: #F1F5F9
```
- 중립적인 회색
- 평온함을 전달

### 그라디언트

#### Warm Gradient (따뜻한)
```css
background: linear-gradient(135deg, #FFF7ED 0%, #FED7AA 100%);
```
**용도**: 배경, 카드 호버

#### Cool Gradient (시원한)
```css
background: linear-gradient(135deg, #F3E8FF 0%, #E9D5FF 100%);
```
**용도**: AI 응답 배경

#### Sunset Gradient (석양)
```css
background: linear-gradient(135deg, #FDBA74 0%, #E9D5FF 50%, #A5F3FC 100%);
```
**용도**: 히어로 섹션, 로딩 화면

#### Aurora Gradient (오로라)
```css
background: linear-gradient(135deg, 
  #FCA5A5 0%, 
  #FBBF24 25%, 
  #34D399 50%, 
  #60A5FA 75%, 
  #A78BFA 100%
);
```
**용도**: 특별한 강조, 성공 애니메이션

### Glass Morphism

```css
.glass {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
}
```

**용도**:
- 모달
- 드롭다운
- 오버레이 카드

---

## ✍️ 타이포그래피

### 폰트 패밀리

#### 1. Pretendard Variable (Display)
**역할**: 제목, 강조 텍스트
**특징**: 
- 한국어 최적화
- 가변 폰트 (100-900)
- 현대적이고 깔끔
- 다양한 굵기 표현

**CDN 로드**:
```html
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css" rel="stylesheet">
```

**사용 예시**:
```css
.hero-title {
  font-family: 'Pretendard Variable';
  font-weight: 800;
  font-size: clamp(2rem, 5vw, 3.5rem);
}
```

#### 2. Noto Sans KR (Body)
**역할**: 본문, 일반 텍스트
**특징**:
- 우수한 가독성
- Google Fonts
- 균형잡힌 디자인

**Next.js 설정**:
```typescript
import { Noto_Sans_KR } from 'next/font/google';

const notoSansKr = Noto_Sans_KR({
  subsets: ['latin'],
  weight: ['300', '400', '500', '700'],
  variable: '--font-noto-sans',
  display: 'swap',
});
```

**사용 예시**:
```css
.diary-content {
  font-family: var(--font-noto-sans);
  font-size: 1rem;
  line-height: 1.8;
}
```

#### 3. Gowun Batang (Accent)
**역할**: AI 응답, 감성적 문구
**특징**:
- 손글씨 느낌의 세리프
- 따뜻하고 인간적
- 감정 전달에 효과적

**사용 예시**:
```css
.ai-message {
  font-family: var(--font-gowun);
  font-size: 1.125rem;
  line-height: 1.9;
  color: #6B46C1;
}
```

#### 4. JetBrains Mono (Monospace)
**역할**: 날짜, 숫자
**특징**:
- 명확한 가독성
- 균일한 너비
- 현대적

**사용 예시**:
```css
.timestamp {
  font-family: var(--font-mono);
  font-size: 0.875rem;
  letter-spacing: -0.02em;
}
```

### 타이포그래피 스케일

#### 제목 (Headings)
```css
/* H1 - 페이지 제목 */
.heading-1 {
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 800;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

/* H2 - 섹션 제목 */
.heading-2 {
  font-size: clamp(1.5rem, 4vw, 2.5rem);
  font-weight: 700;
  line-height: 1.3;
  letter-spacing: -0.01em;
}

/* H3 - 서브 제목 */
.heading-3 {
  font-size: clamp(1.25rem, 3vw, 1.875rem);
  font-weight: 600;
  line-height: 1.4;
}
```

#### 본문 (Body)
```css
/* Large Body */
.body-large {
  font-size: 1.125rem;
  font-weight: 400;
  line-height: 1.8;
  letter-spacing: -0.01em;
}

/* Regular Body */
.body {
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.7;
}

/* Small Body */
.body-small {
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1.6;
}
```

### 타이포그래피 적용 가이드

| 요소 | 폰트 | 크기 | 굵기 |
|-----|-----|------|-----|
| 페이지 제목 | Pretendard | 3.5rem | 800 |
| 섹션 제목 | Pretendard | 2.5rem | 700 |
| 카드 제목 | Pretendard | 1.25rem | 600 |
| 일기 본문 | Noto Sans KR | 1rem | 400 |
| AI 응답 | Gowun Batang | 1.125rem | 400 |
| 버튼 텍스트 | Pretendard | 1rem | 500 |
| 날짜/시간 | JetBrains Mono | 0.875rem | 500 |
| 키워드 태그 | Noto Sans KR | 0.875rem | 500 |

---

## 🎬 애니메이션 시스템

### Staggered Animations

#### 페이지 진입
```typescript
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
```

**사용 예시**:
```tsx
<motion.div
  variants={containerVariants}
  initial="hidden"
  animate="visible"
>
  <motion.h1 variants={itemVariants}>제목</motion.h1>
  <motion.p variants={itemVariants}>설명</motion.p>
  <motion.button variants={itemVariants}>버튼</motion.button>
</motion.div>
```

#### 일기 목록 Cascade
```typescript
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
  }
};
```

### 마이크로인터랙션

#### 1. Button Interactions

**Magnetic Effect (자석 효과)**
```tsx
const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });

<motion.button
  whileHover={{ scale: 1.05 }}
  whileTap={{ scale: 0.95 }}
  animate={{
    x: mousePosition.x * 0.1,
    y: mousePosition.y * 0.1,
  }}
  transition={{
    type: 'spring',
    stiffness: 150,
    damping: 15
  }}
>
  클릭
</motion.button>
```

**Ripple Effect**
```css
@keyframes ripple {
  0% {
    transform: scale(0);
    opacity: 1;
  }
  100% {
    transform: scale(4);
    opacity: 0;
  }
}

.ripple {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  animation: ripple 0.6s ease-out;
}
```

#### 2. Input Focus Animation

```tsx
<motion.textarea
  whileFocus={{
    scale: 1.02,
    boxShadow: '0 0 0 3px rgba(249, 115, 22, 0.1)',
  }}
  transition={{
    type: 'spring',
    stiffness: 300,
    damping: 20
  }}
/>
```

#### 3. Typewriter Effect (AI 응답)

```tsx
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
    <p className="accent-text">
      {displayText}
      <motion.span
        animate={{ opacity: [1, 0] }}
        transition={{ repeat: Infinity, duration: 0.8 }}
      >
        |
      </motion.span>
    </p>
  );
}
```

#### 4. Sentiment Icon Animation

```tsx
const iconVariants = {
  positive: {
    rotate: [0, -10, 10, -10, 0],
    scale: [1, 1.2, 1],
    transition: { duration: 0.6 }
  },
  negative: {
    y: [0, -5, 0],
    transition: { duration: 0.5 }
  },
  neutral: {
    rotate: [0, 5, -5, 0],
    transition: { duration: 0.4 }
  }
};

<motion.div
  variants={iconVariants}
  animate={sentiment}
>
  {icon}
</motion.div>
```

#### 5. Keyword Tags Pop

```tsx
{keywords.map((keyword, i) => (
  <motion.span
    key={keyword}
    initial={{ scale: 0, opacity: 0 }}
    animate={{ 
      scale: 1, 
      opacity: 1,
      transition: {
        delay: i * 0.1,
        type: 'spring',
        stiffness: 260,
        damping: 20
      }
    }}
    whileHover={{
      scale: 1.1,
      transition: {
        type: 'spring',
        stiffness: 400,
        damping: 10
      }
    }}
    className="keyword-tag"
  >
    #{keyword}
  </motion.span>
))}
```

#### 6. Loading States

**Spinner**
```tsx
<motion.div
  animate={{ rotate: 360 }}
  transition={{
    repeat: Infinity,
    duration: 1,
    ease: 'linear'
  }}
  className="spinner"
/>
```

**Pulse**
```tsx
<motion.div
  animate={{
    scale: [1, 1.05, 1],
    opacity: [0.5, 1, 0.5],
  }}
  transition={{
    repeat: Infinity,
    duration: 2,
    ease: 'easeInOut'
  }}
/>
```

**Skeleton**
```tsx
<motion.div
  animate={{
    backgroundPosition: ['200% 0', '-200% 0'],
  }}
  transition={{
    repeat: Infinity,
    duration: 1.5,
    ease: 'linear'
  }}
  style={{
    background: 'linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%)',
    backgroundSize: '200% 100%',
  }}
/>
```

### 애니메이션 타이밍

| 상황 | 지속시간 | Easing |
|-----|---------|--------|
| 페이지 전환 | 300-500ms | ease-in-out |
| 호버 효과 | 200-300ms | ease-out |
| 클릭 피드백 | 100-150ms | ease-in |
| 로딩 | 1000-2000ms | linear |
| Stagger 간격 | 80-100ms | - |

---

## 📱 반응형 디자인

### 브레이크포인트

```css
/* Mobile First */
--breakpoint-sm: 640px;   /* Small tablet */
--breakpoint-md: 768px;   /* Tablet */
--breakpoint-lg: 1024px;  /* Desktop */
--breakpoint-xl: 1280px;  /* Large desktop */
--breakpoint-2xl: 1536px; /* Extra large */
```

### 레이아웃 전략

#### Mobile (< 640px)
- 1열 레이아웃
- 에디터 → AI 응답 → 히스토리 순서
- 패딩: 16px
- 폰트 크기: 기본

#### Tablet (640px - 1024px)
- 1열 레이아웃 (여백 증가)
- 패딩: 24px
- 최대 너비: 768px (중앙 정렬)

#### Desktop (≥ 1024px)
- 2열 레이아웃 (60:40 비율)
- 에디터 + AI 응답 (좌) | 히스토리 (우)
- 패딩: 32px
- 최대 너비: 1280px

### 반응형 타이포그래피

```css
/* clamp 사용 */
font-size: clamp(최소값, 선호값, 최대값);

/* 예시 */
h1 { font-size: clamp(2rem, 5vw, 3.5rem); }
h2 { font-size: clamp(1.5rem, 4vw, 2.5rem); }
body { font-size: clamp(0.875rem, 2vw, 1rem); }
```

---

## 🎯 컴포넌트 스타일 가이드

### Button

```tsx
// Primary Button
<button className="
  px-6 py-3
  bg-primary-500 hover:bg-primary-600
  text-white font-medium
  rounded-xl
  transition-all duration-200
  hover:shadow-lg hover:-translate-y-1
  active:translate-y-0
">
  버튼 텍스트
</button>

// Secondary Button
<button className="
  px-6 py-3
  bg-white border-2 border-primary-500
  text-primary-600 font-medium
  rounded-xl
  transition-all duration-200
  hover:bg-primary-50
">
  버튼 텍스트
</button>
```

### Card

```tsx
<div className="
  bg-white
  rounded-2xl
  shadow-lg
  p-6
  border border-gray-100
  transition-all duration-300
  hover:shadow-xl hover:-translate-y-1
">
  카드 내용
</div>
```

### Input / Textarea

```tsx
<textarea className="
  w-full
  p-4
  border-2 border-gray-200
  rounded-xl
  focus:border-primary-500 focus:ring-4 focus:ring-primary-100
  transition-all duration-200
  resize-none
  font-noto-sans
  text-base leading-relaxed
"/>
```

### Tag

```tsx
<span className="
  px-3 py-1
  bg-purple-100 text-purple-700
  rounded-full
  text-sm font-medium
  transition-transform duration-200
  hover:scale-110
">
  #키워드
</span>
```

---

## 📐 간격 시스템

```css
--spacing-xs: 0.25rem;  /* 4px */
--spacing-sm: 0.5rem;   /* 8px */
--spacing-md: 1rem;     /* 16px */
--spacing-lg: 1.5rem;   /* 24px */
--spacing-xl: 2rem;     /* 32px */
--spacing-2xl: 3rem;    /* 48px */
--spacing-3xl: 4rem;    /* 64px */
```

### 적용 가이드

| 요소 | 간격 |
|-----|------|
| 버튼 패딩 | lg (24px) |
| 카드 패딩 | xl (32px) |
| 섹션 간격 | 2xl (48px) |
| 요소 간 간격 | md (16px) |
| 라벨-입력 간격 | sm (8px) |

---

## 🎨 다크 모드 (선택 사항)

```css
/* Light Mode (기본) */
:root {
  --bg-primary: #FFFFFF;
  --bg-secondary: #F9FAFB;
  --text-primary: #111827;
  --text-secondary: #6B7280;
}

/* Dark Mode */
@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #111827;
    --bg-secondary: #1F2937;
    --text-primary: #F9FAFB;
    --text-secondary: #9CA3AF;
  }
}
```

---

## ✅ 디자인 체크리스트

### 타이포그래피
- [ ] 모든 제목에 Pretendard Variable 적용
- [ ] 본문에 Noto Sans KR 적용
- [ ] AI 응답에 Gowun Batang 적용
- [ ] 날짜/숫자에 JetBrains Mono 적용
- [ ] 반응형 폰트 크기 설정 (clamp 사용)

### 애니메이션
- [ ] 페이지 진입 시 Stagger 효과
- [ ] 버튼 Hover/Press 인터랙션
- [ ] AI 응답 타이핑 효과
- [ ] 키워드 태그 순차 등장
- [ ] 일기 카드 Hover 효과

### 색상
- [ ] Primary/Secondary 색상 일관성
- [ ] 감정별 색상 적용 (긍정/부정/중립)
- [ ] 그라디언트 적절히 사용
- [ ] 충분한 대비율 (WCAG AA 기준)

### 반응형
- [ ] Mobile 레이아웃 확인
- [ ] Tablet 레이아웃 확인
- [ ] Desktop 레이아웃 확인
- [ ] 터치 타겟 최소 44x44px

### 접근성
- [ ] 키보드 네비게이션 가능
- [ ] Focus 상태 명확히 표시
- [ ] Alt 텍스트 제공
- [ ] ARIA 레이블 적용

---

**마지막 업데이트**: 2026-07-06  
**담당자**: Design Team
