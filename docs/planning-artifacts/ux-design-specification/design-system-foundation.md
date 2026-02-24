# Design System Foundation

### Design System Choice

##### Selected: shadcn/ui + Radix Primitives + Custom Design Tokens

Components are copied into the codebase (not npm dependency), giving full CSS control, tree-shaking to only what's used, and zero framework lock-in. Built on Radix accessible primitives with first-class Next.js RSC support.

### Rationale — Trade-off Matrix

| Criterion | Wt | shadcn | Chakra | MUI | Custom |
| ----------- | :--: | :------: | :------: | :---: | :------: |
| Bundle size | 3 | 5 | 3 | 2 | 5 |
| 3G performance | 3 | 5 | 3 | 2 | 5 |
| Visual uniqueness | 3 | 4 | 3 | 2 | 5 |
| Accessibility | 2 | 5 | 5 | 5 | 2 |
| Dev speed (solo) | 3 | 4 | 4 | 5 | 1 |
| Next.js compat | 2 | 5 | 3 | 3 | 5 |
| Component coverage | 2 | 4 | 5 | 5 | 2 |
| Customization depth | 3 | 5 | 3 | 3 | 5 |
| Community/docs | 1 | 4 | 4 | 5 | 1 |
| Long-term maint | 2 | 4 | 4 | 4 | 2 |
| **WEIGHTED TOTAL** | | **109** | **86** | **81** | **86** |

### Technical Validation

| Constraint | Requirement | shadcn Result | Verdict |
| ----------- | ------------ | --------------- | :-------: |
| Bundle size | ₦500KB initial payload | 12-25KB gzipped (vs MUI ~80-120KB) | ✅ |
| 3G performance | Fast on 1-3 Mbps | No runtime CSS-in-JS. CSS variables only | ✅ |
| Android 8+ / Chrome 90+ | No bleeding-edge APIs | CSS vars from Chrome 49+. Standard ARIA | ✅ |
| PWA compatibility | Offline, installable | No CDN deps. CSS works offline | ✅ |
| Next.js RSC | Server components | First-class RSC support (best among options) | ✅ |

### Component Inventory

| Category | shadcn Covers | Custom Needed | Total |
| ---------- | :------------: | :-------------: | :-----: |
| Buttons/Actions | 8 | 0 | 8 |
| Cards/Containers | 5 | 4 | 9 |
| Inputs/Forms | 6 | 2 | 8 |
| Navigation | 2 | 1 | 3 |
| Feedback/Toasts | 2 | 1 | 3 |
| Overlays/Modals | 2 | 1 | 3 |
| Custom Interactions | 0 | 6 | 6 |
| **TOTAL** | **25 (63%)** | **15 (37%)** | **40** |

##### Custom MarketBoss Components (no design system would have these)

| Component | Purpose |
| ----------- | -------- |
| PrimingCard | DM context overlay — slides from top, customer history, revenue signal |
| StarRating | "Sounds Like Me" 1-5 rating — large touch targets, animated fill |
| RevenueHero | OPay-style balance card — gradient bg, live counter animation |
| DraftSwiper | Horizontal swipe between AI drafts — card stack with gesture physics |
| VoiceInput | Tap-hold mic for product entry — WhatsApp-style recording UI |
| ChatBubble | WhatsApp-style message bubbles — with AI draft variant |
| ReceiptCard | OPay-style payment receipt — trustworthy, instant, ₦-formatted |
| SwipeableRow | DM list swipe actions — reply/archive/flag gestures |
| CameraCapture | Direct camera for product photos — no "choose source" dialog |
| VoiceRecorder | Brand Voice recording during onboarding — waveform visualization |

### Design System Implementation Approach

##### Phase 1: Design Token Foundation (Week 1)

```text
tokens/
├── colors.css      → Semantic tokens: --color-surface, --color-primary (not --green-500)
├── typography.css   → Inter font, mobile-optimized scale
├── spacing.css      → 4px minimum unit, 8px base grid
├── shadows.css      → Elevation for cards, modals, priming cards
├── animations.css   → Micro-interaction timing curves (60fps CSS transforms)
└── breakpoints.css  → min support 320px; breakpoints 480px → 768px → 1024px (mobile-first)
```

Tokens in a SEPARATE package/folder — consumable by both web and future React Native.

##### Phase 2: shadcn Core Components (Week 2)

| Component | shadcn Base | MarketBoss Customization |
| ----------- | ----------- | ------------------------- |
| Button | shadcn Button | Green accent, 48px min touch, haptic states |
| Card | shadcn Card | Revenue hero, priming, receipt variants |
| Input | shadcn Input | Voice-input variant, ₦ prefix for price |
| Dialog | shadcn Dialog | Bottom sheet (mobile-native), not centered modal |
| Toast | shadcn Toast | "Published ✅" and "₦6,500 received 🎉" variants |
| Tabs | shadcn Tabs | Bottom tab bar (Home/Messages/Create/Profile) |
| Avatar | shadcn Avatar | With 🔥/❓ revenue signal badges |

##### Phase 3: Custom MarketBoss Components (Weeks 3-4)

All custom components use the SAME design token system — `var(--radius)`, `var(--primary)`, `var(--spacing-*)` — ensuring visual consistency with shadcn components.

### Customization Strategy

##### Visual Identity

| Token | Value | Rationale |
| ------- | ------- | ---------- |
| `--color-primary` | Emerald #10B981 | Trust, money, Nigerian national color |
| `--color-accent` | Warm gold #F5A623 | Prosperity, celebration, notifications |
| `--color-surface` | Slate palette | Clean, professional system UI |
| `--color-error` | Warm red | Approachable, not alarming |
| `--font-family` | Inter | Clean, excellent mobile readability |

##### Cultural Customization

- ₦ symbol left-aligned with number (no space)
- Number format: 1,000 (comma separator)
- 12-hour AM/PM time format
- Pidgin-ready locale-aware string props
- Culture in CONTENT copy, professionalism in SYSTEM copy

##### Mobile-First Rules

- 48px minimum touch target everywhere
- Bottom sheets instead of centered modals
- Gesture-first (swipe, pull, tap-hold)
- No hover-dependent interactions
- Single-column layouts with 320px minimum support, optimized for 360px+

### Risk Mitigations

| Risk | Severity | Mitigation |
| ------ | :--------: | ------------ |
| Components look like a template | MED | Tokens-FIRST workflow. Token audit every 2 weeks |
| Custom components feel disconnected | MED | Component style guide: all use shared CSS variables |
| **Gesture janky on cheap phones** | **HIGH** | **CSS transforms + will-change. Test on ₦30K Tecno Spark at every milestone** |
| PWA install confusing | MED | Custom install prompt after first successful action |
| React Native needed later | LOW | Design tokens in separate package. NativeWind + same tokens |
| Dark mode afterthought | MED | Semantic tokens from Day 1. Dark mode = token swap |

### Future-Proofing

| Scenario | Timeline | Readiness |
| ---------- | --------- | :---------: |
| 10K users | Month 6 | ✅ Static components scale infinitely |
| 100K users | Year 2 | ✅ Components in codebase = design system IS the code |
| Hire a designer | Year 1-2 | ✅ Figma kit + CSS variables = 1:1 design-to-dev |
| React Native app | Year 2+ | ⚠️ Tokens transfer, components need NativeWind/Tamagui |
| White-labeling | Growth | ✅ Swap tokens/ folder → new brand instantly |
