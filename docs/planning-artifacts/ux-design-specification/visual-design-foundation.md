# Visual Design Foundation

### Brand Positioning

> **"Green & Gold — Colors of Nigerian Prosperity"**
>
> Money Green (₦ notes) + Chieftaincy Gold (traditional prestige). Unique in the Nigerian fintech/commerce landscape — no competitor uses this combination.

### Color System

#### Core Palette

| Token | Value | Usage | Emotional Connection |
| ------- | ------- | ------- | --------------------- |
| `--color-primary-700` | `#047857` | High-contrast / sunlight variant | Deep confidence |
| `--color-primary-600` | `#059669` | Hover states, emphasis | Stronger confidence |
| `--color-primary-500` | `#10B981` (Emerald) | CTAs, navigation, active states | "I feel powerful" — money green |
| `--color-primary-400` | `#34D399` | Success indicators, dark mode primary | Positive feedback |
| `--color-accent-600` | `#D97706` | Hover on accent, support PrimingCard | Earned achievement |
| `--color-accent-500` | `#F59E0B` (Amber/Gold) | Revenue numbers, achievements, badges | "I feel respected" — premium |
| `--color-accent-400` | `#FBBF24` | Dark mode accent variant | Warm reward |
| `--color-neutral-900` | `#0F172A` (Slate) | Primary text, revenue hero bg | Professional authority |
| `--color-neutral-800` | `#1E293B` | Dark mode card backgrounds | Deep surface |
| `--color-neutral-700` | `#334155` | Secondary text | Readable, calm |
| `--color-neutral-400` | `#94A3B8` | Placeholder text, disabled | Subtle |
| `--color-neutral-300` | `#CBD5E1` | Borders (720p minimum visibility) | Structure |
| `--color-neutral-100` | `#F1F5F9` | Card backgrounds, sections | Clean |
| `--color-neutral-50` | `#F8FAFC` | Page background | Airy, premium |

#### Semantic Colors

| Token | Value | Usage |
| ------- | ------- | ------- |
| `--color-success` | `#10B981` (= primary) | Payment received, order confirmed |
| `--color-warning` | `#F59E0B` (= accent) | Low stock, expiring offers |
| `--color-error` | `#EF4444` | Payment failed, validation errors |
| `--color-info` | `#3B82F6` | Tips, onboarding hints |
| `--color-support` | `#D97706` (Amber) | Support PrimingCard, complaint DMs (amber, not orange — avoids PDP political association) |

#### Revenue-Specific Colors

| Context | Color | Rule |
| --------- | ------- | ------ |
| Revenue hero card | Gold on `--neutral-900` | **Always dark bg**, even in light mode (gold readability) |
| ₦ amounts (positive) | `--primary-500` | Green = money |
| ₦ amounts (pending) | `--accent-500` | Gold = in-progress |
| Payment received banner | `--primary-400` + ✅ | Celebratory |
| "Sounds Like Me" stars | `--accent-500` | Gold stars |

#### Dark Mode Strategy

| Element | Light | Dark |
| --------- | ------- | ------ |
| Page background | `--neutral-50` | `--neutral-900` |
| Card background | `white` | `--neutral-800` |
| Primary text | `--neutral-900` | `--neutral-100` |
| Primary color | `--primary-500` | `--primary-400` (lighter for contrast) |
| Accent color | `--accent-500` | `--accent-400` (lighter) |

> Launch with light mode only (MVP). Dark tokens pre-defined for Phase 2. Nigerian users primarily use phones outdoors — light mode with high contrast is priority.

#### Accessibility Compliance

| Pair | Contrast Ratio | WCAG |
| ------ | :-: | ------ |
| Primary on white | 4.6:1 | ✅ AA |
| Primary on neutral-900 | 8.2:1 | ✅ AAA |
| Neutral-900 on neutral-50 | 16.5:1 | ✅ AAA |
| Accent on white | 3.2:1 | ⚠️ AA Large only |
| Accent on neutral-900 | 6.8:1 | ✅ AA |

> Gold accent: never as text on white. Always on dark backgrounds or as background with dark text.

#### Competitor Color Landscape

| Color | Nigerian Apps | MarketBoss Overlap |
| :-----: | :------------- | :------------------: |
| Blue | OPay, Paystack, Moniepoint, Piggyvest, Bumpa, Kuda | None |
| Orange | Flutterwave, Jumia | None |
| Purple | Kuda, PalmPay | None |
| Green | WhatsApp (#25D366 warm lime) | Distinct (#10B981 cool emerald) |
| Gold | PalmPay (purple primary) | Unique pairing with green |

### Typography System

#### Font Selection

| Role | Font | Weights | Why |
| ------ | ------ | :-------: | ----- |
| **Primary** (UI) | **Inter** (variable) | 400, 500, 600, 700 | Screen-optimized, excellent at small sizes, variable font = tiny bundle |
| **Mono** (₦ amounts) | **JetBrains Mono** | 500 | Tabular figures for currency alignment. Fallback: `'Roboto Mono', monospace` |

#### Type Scale (Mobile-First)

| Level | Size | Weight | Line Height | Usage |
| ------- | :----: | :------: | :-----------: | ------- |
| `--text-hero` | 32px | 700 | 1.2 | Revenue hero: "₦85,000" |
| `--text-h1` | 24px | 700 | 1.3 | Page titles |
| `--text-h2` | 20px | 600 | 1.35 | Section headers |
| `--text-h3` | 16px | 600 | 1.4 | Card titles, PrimingCard name |
| `--text-body` | 14px | 400 | 1.5 | DMs, descriptions |
| `--text-body-large` | 16px | 400 | 1.5 | Accessibility toggle (Large Text mode) |
| `--text-small` | 12px | 400 | 1.4 | Timestamps, metadata |
| `--text-tiny` | 10px | 500 | 1.3 | Badges, labels |

#### Typography Rules

1. **₦ currency always in JetBrains Mono** — tabular figures, aligned decimals
2. **Max 2 font weights per screen** — avoid visual noise
3. **Body text never below 14px** — budget phones with lower-density screens (264 PPI)
4. **Emoji banned in monospace contexts** — causes line-height jumps in currency rendering
5. **Left-aligned always** — never center body text on mobile
6. **"Large Text" toggle** — body 14→16px, small 12→14px for accessibility

#### PrimingCard Scan Hierarchy

| Priority | Element | Size | Must-Scan? |
| :--------: | --------- | :----: | :----------: |
| 1 | Customer name | 16px / 600 | ✅ YES |
| 2 | Price | 16px / 500 mono gold | ✅ YES |
| 3 | Product | 14px / 400 | Peripheral |
| 4 | History | 12px / 400 | Peripheral |
| 5 | Behavior hint | 12px / 400 | Peripheral |

> Target: 1.5-second scan. Name + Price are the only "must-read" items.

### Spacing & Layout Foundation

#### Spacing Scale (8px base)

| Token | Value | Usage |
| ------- | :-----: | ------- |
| `--space-1` | 4px | Icon-to-label gaps |
| `--space-2` | 8px | Internal padding (badges, chips) |
| `--space-3` | 12px | Between related elements |
| `--space-4` | 16px | Card internal padding |
| `--space-5` | 20px | Between cards/sections |
| `--space-6` | 24px | Page horizontal padding |
| `--space-8` | 32px | Section separators |
| `--space-10` | 40px | Major section breaks |
| `--space-12` | 48px | Navigation height, header height |

#### Layout Principles

| Principle | Application |
| ---------- | ------------ |
| Mobile-first single column | No horizontal scrolling. Content stacks vertically |
| Bottom-anchored navigation | 4-tab bar (Home, Messages, Create, Profile) |
| Cards as primary container | `border-radius: 12px`, `shadow: 0 2px 8px rgba(0,0,0,0.08)`, `padding: --space-4` |
| 48px primary CTA height | Generous hit area for cracked screens. Emerald bg + white text |
| 48px secondary touch targets | All interactive elements minimum |
| Safe area awareness | `env(safe-area-inset-*)` for notch + gesture bar |

#### Device-Optimized Rendering

| Issue | Solution |
| ------- | ---------- |
| 720p IPS (85% of users) | Borders: `--neutral-300` minimum. Shadows: `0 2px 8px rgba(0,0,0,0.08)` |
| Sunlight (400 nit max) | Emerald as BACKGROUND + white text. Never emerald text on light bg |
| Low brightness (20%) | Gold on dark bg only. Revenue card always `--neutral-900` bg |
| Cracked screens (~40%) | Primary CTAs: 56px, centered horizontally. Never edge-aligned |
| High-contrast mode | `prefers-contrast: high` → use `--primary-700` for stronger emerald |

#### Adaptive Components

| Component | Standard (≥700px) | Compact (<700px viewport) |
| ----------- | ------------------- | --------------------------- |
| PrimingCard | 5 rows, ~152px | 3 rows, product + price same line, ~96px |
| AI Draft card | Full-width, rating visible | Full-width, rating collapsed |
| Edit/Send buttons | 56px height, 112px gap | 56px height, flexible gap |

#### Component Spacing Diagram

```text
Page: padding 0 24px (--space-6)
  Card: padding 16px (--space-4), radius 12px, margin-bottom 20px (--space-5)
    Content row: gap 12px (--space-3), padding 8px vertical (--space-2)
  Bottom Nav: height 48px (--space-12) + safe-area-inset-bottom
```

### Cultural Color Validation

| Color | Igbo | Yoruba | Hausa | Verdict |
| :-----: | :----: | :------: | :-----: | :-------: |
| Emerald | Prosperity (new yam) | Work/industry (Ogun) | Islam (positive) | ✅ Zero negatives |
| Gold | Wealth, status | Aso-oke prestige | Royalty (Emirs) | ✅ Premium all groups |
| Red (error) | Sacrifice/danger | Power (Shango) | — | ✅ Standard error |
| Amber (support) | Neutral | Neutral | Neutral | ✅ No political associations |
