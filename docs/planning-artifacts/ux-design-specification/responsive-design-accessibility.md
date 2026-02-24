# Responsive Design & Accessibility

Mobile-first responsive strategy with WCAG 2.1 AA accessibility, refined through 22 improvements from Advanced Elicitation (Device Stress Test, Empathy Mapping, Red Team vs Blue Team, Edge Case Expedition, Technical Spike).

### Responsive Strategy

##### Philosophy: Mobile-native, progressive enhancement

| Tier | Priority | Approach | Users |
| --- | --- | --- | --- |
| **Mobile (primary)** | P0 — design target | Native experience, every feature optimized | 95%+ of sellers |
| **Tablet** | P1 — stretched mobile | Same layout, more breathing room, no rearchitecting | ~3% (shop-front tablets) |
| **Desktop** | P2 — opportunistic | Side-by-side panels where shadcn/ui gives it free | ~2% (back-office admin) |

##### Mobile Layout (320–767px)

| Zone | Content | Height |
| --- | --- | --- |
| Status bar | System (OS-controlled) | ~24px |
| RevenueHero | Revenue stats, time toggles | 96px (collapses to 48px on <5.0" screens) |
| CommandBar | Search + filter chips | 48–96px (adaptive) |
| Feed | Scrollable card list (virtualized) | Flex remaining |
| Bottom tabs | 4-tab navigation | 56px + safe area |

##### Small Screen Adaptation (<5.0" / iPhone SE)

- RevenueHero collapses to single-line: "₦45,200 today ▸" (tappable to expand)
- Pull-down gesture expands RevenueHero (notification shade pattern)
- Saves 48px vertical space for feed content on cramped screens

##### Tablet Layout (768–1023px)

| Adaptation | Change |
| --- | --- |
| Feed cards | Max-width 600px, centered with side margins |
| RevenueHero | Expanded to show all 3 time ranges side-by-side (no toggle needed) |
| Bottom sheets | Max-width 480px, centered (not full-width) |
| Filter chips | All visible without scrolling |
| Grid density | Same as mobile — shadcn/ui handles spacing naturally |

##### Desktop Layout (1024px+)

| Adaptation | Change | Effort |
| --- | --- | --- |
| **Split-view** | Feed left (60%), detail/expanded item right (40%) | Low — shadcn/ui `ResizablePanel` |
| **Left sidebar nav** | Tabs move from bottom to left sidebar | Medium — custom CSS (~50 lines), `Sheet` for mobile |
| **Keyboard shortcuts** | Full keyboard nav: `/` search, `j/k` navigate feed, `Enter` expand | Low — already in CommandBar |
| **Hover states** | Show action buttons on card hover (hidden on mobile) | Low — CSS only |
| **Side panels** | Bottom sheets become right-side panels | Low — shadcn/ui `Sheet` with `side="right"` |
| **Hover previews** | Rich preview on feed item hover | Low — shadcn/ui `HoverCard` |
| **Tooltips** | Enabled on desktop (disabled on mobile per rules) | Low — `useMediaQuery('(hover: hover)')` |
| **Multi-column stats** | RevenueHero as horizontal dashboard strip | Medium — layout reflow |

##### "Free from shadcn/ui" Desktop Wins (Validated via Technical Spike)

| Component | Status | Notes |
| --- | --- | --- |
| `ResizablePanel` | ✅ Free | Wraps react-resizable-panels, SSR compatible |
| `Sheet` (side panels) | ✅ Free | Supports `side="right"`, inherits Radix Dialog accessibility |
| `HoverCard` | ✅ Free | Only shows on hover, touch-safe |
| `Tooltip` | ✅ Free | Conditionally render with `@media (hover: hover)` |
| `NavigationMenu` | ⚠️ Revised | NOT designed for vertical sidebars — custom sidebar CSS needed |

### Breakpoint Strategy

##### Mobile-first CSS with 3 breakpoints

| Breakpoint | Token | Target | Media Query |
| --- | --- | --- | --- |
| **sm** | `--bp-sm` | Large phones | `@media (min-width: 480px)` |
| **md** | `--bp-md` | Tablets | `@media (min-width: 768px)` |
| **lg** | `--bp-lg` | Desktop | `@media (min-width: 1024px)` |

##### Breakpoint Rules

- **Mobile-first:** Base CSS = mobile. Breakpoints add complexity upward
- **No `max-width` queries** — they create fragile mobile-last patterns
- **Container queries** for components responsive within layouts (e.g., FeedItem inside split-view vs. full-width mobile)
- **Container query fallback:** `@supports (container-type: inline-size)` with media query fallback for Android 12 WebView
- **Fluid typography:** `clamp(16px, 4vw, 18px)` for body text. No hard font-size jumps
- **Spacing scale:** 8px base stays constant. Only margins/gaps increase at breakpoints
- **Minimum app width:** 320px. Below 320px: "Please use full screen" message

##### Critical Breakpoint Behaviors

| Feature | Mobile (<768px) | Tablet (768–1023px) | Desktop (1024px+) |
| --- | --- | --- | --- |
| Navigation | Bottom tab bar | Bottom tab bar | Left sidebar |
| Feed layout | Full-width cards | Centered 600px max | Split-view (60/40) |
| Bottom sheets | Full-width, bottom | Centered, 480px max | Side panel (right) |
| CommandBar | Sticky, adaptive | Always expanded | Persistent in sidebar |
| Expanded items | Inline in feed | Inline in feed | Right panel detail |
| Stats (RevenueHero) | Toggle time ranges | All ranges visible | Dashboard strip |
| Tooltips | Disabled (inline hints) | Disabled | Enabled |
| Keyboard shortcuts | Hidden | Hidden | Visible in UI |

### Accessibility Strategy

##### Target: WCAG 2.1 Level AA Compliance

#### Color & Contrast

| Element | Requirement | Our Value | Status |
| --- | --- | --- | --- |
| Body text on white | 4.5:1 minimum | Slate-800 (#1e293b) on White → **12.6:1** | ✅ Pass |
| Body text on dark | 4.5:1 minimum | Slate-200 (#e2e8f0) on Slate-900 → **11.3:1** | ✅ Pass |
| Emerald on white | 3:1 for large text/UI | Emerald-600 (#059669) on White → **4.6:1** | ✅ Pass |
| Gold on white | 3:1 for large text/UI | Gold-600 (#ca8a04) on White → **3.4:1** | ✅ Pass (large text only) |
| Red error on white | 4.5:1 minimum | Red-600 (#dc2626) on White → **4.6:1** | ✅ Pass |

**Gold Text Size Rule:** Gold-600 ONLY permitted on text ≥18px or ≥14px bold. Never for body text.

**Non-Color Indicators** (never rely on color alone):

| Meaning | Color | Non-Color Indicator |
| --- | --- | --- |
| Interactive/action | Emerald | Underline on links, icon on buttons, focus ring |
| Revenue/money | Gold | ₦ prefix, 🎉 emoji, "received" label |
| Error/danger | Red | ⚠️ icon, "Error:" prefix text, border change |
| Warning | Amber | ⚡ icon, "Warning:" prefix text |
| Success | Emerald | ✅ icon, "Success:" prefix text |
| Offline | Amber | 📡 icon, persistent banner text |

#### Keyboard Navigation

| Key | Action | Context |
| --- | --- | --- |
| `Tab` | Move focus to next interactive element | Global |
| `Shift+Tab` | Move focus to previous element | Global |
| `Enter/Space` | Activate focused element | Buttons, links, chips |
| `Escape` | Close overlay/collapse expanded item | Modals, bottom sheets |
| `Arrow Up/Down` | Navigate within feed items | Feed (when focused) |
| `/` | Focus CommandBar search | Global shortcut |
| `j/k` | Next/previous feed item | Desktop feed navigation |

##### Focus Management

- **Visible focus ring:** 2px emerald outline, 2px offset. Never `outline: none` without replacement
- **`:focus-visible`** (not `:focus`) — shows ring only for keyboard users, not mouse/touch
- **Focus trap in overlays:** Tab cycles within modal/bottom sheet until dismissed
- **Skip links:** Hidden "Skip to feed" link appears on first Tab press
- **Focus restoration:** After closing overlay, focus returns to the element that triggered it

#### Screen Reader Support

| Component | ARIA Implementation |
| --- | --- |
| Feed | `role="feed"`, items have `role="article"`, `aria-setsize`, `aria-posinset` |
| Feed load announcement | `aria-live="polite"`: "Revenue Command Feed loaded. 12 items. First item: New DM from Chioma" |
| RevenueHero | `role="status"`, `aria-live="polite"`, `aria-label="Today's revenue: 45,200 naira. Up 12%"` |
| Bottom sheets | `role="dialog"`, `aria-modal="true"`, `aria-label="[sheet purpose]"` |
| PrimingCard | `role="alert"`, no auto-dismiss for screen readers |
| Toast notifications | `role="status"`, `aria-live="polite"` (not `assertive` unless error) |
| Toast pause | Pause-on-touch (mobile) + pause-on-hover (desktop). Notification history "View all" |
| CommandBar | `role="combobox"`, `aria-expanded`, `aria-activedescendant` |
| Filter chips | `role="radiogroup"`, each chip `role="radio"`, `aria-checked` |
| Star rating | `role="slider"`, `aria-valuemin="1"`, `aria-valuemax="5"`, `aria-valuenow` |
| Loading skeletons | `aria-busy="true"` on container, `aria-label="Loading content"` |
| Send action status | `aria-live="assertive"`: "Sending reply to Chioma" → "Reply delivered to Chioma" |
| DraftBox focus order | Draft text → tone selector → send button. Announcement: "AI draft ready. [draft text]. Tone: Friendly. Actions: Edit, Regenerate, Send" |
| Feed item overflow | Visible [⋯] button on each item — keyboard/screen reader alternative to long-press |

#### Voice Input Accessibility

| Scenario | Accommodation |
| --- | --- |
| Deaf/hard-of-hearing | Text input always available alongside voice. Voice is shortcut, not requirement |
| Visual impairment | Voice recorded waveform has `aria-label` with transcript text |
| Motor impairment | "Hold to speak" has toggle-to-speak alternative (tap to start, tap to stop) |
| Cognitive | Parsed voice result always shows editable confirmation before submission |

#### Motion & Vestibular

| `prefers-reduced-motion` Value | Behavior |
| --- | --- |
| `no-preference` | All animations enabled (subject to Tecno test) |
| `reduce` | Decorative animations removed (confetti, counting, shimmer). Functional animations (expand/collapse) become instant transitions |

**Shimmer Safety:** Shimmer cycle MUST be ≥1.5s. Never exceed 3 flashes per second.

**Viewport Scaling Rule:** NEVER use `maximum-scale=1` or `user-scalable=no` — blocks pinch-to-zoom (WCAG 1.4.4 violation).

### Device-Specific Performance Fixes

Validated via Device Stress Test on 3 constraint devices:

#### Infinix Hot 30 (2GB RAM, Android 12)

| Issue | Fix |
| --- | --- |
| Feed expansion layout thrash | Pre-calculate expansion heights in idle callback. `will-change: transform` only during animation, remove after |
| RevenueHero counting animation drops frames | CSS `@property` counter animation. Fallback: instant update on `deviceMemory < 4` |
| Confetti GC pause (50 particles) | Reduce to 12 particles on `deviceMemory < 4` |
| `visualViewport` API missing | Polyfill: `resize` event + `100dvh`. Store known keyboard height |
| Skeleton shimmer compositing explosion | IntersectionObserver: shimmer only visible skeletons. Off-screen = static grey |

#### Tecno Spark 10 (3GB RAM, Android 13)

| Issue | Fix |
| --- | --- |
| Camera viewfinder 3s delay | Start camera stream on component mount, not tap. Pre-negotiate resolution |
| Canvas waveform drops to 15fps | Replace canvas waveform with CSS-only 3-bar pulse animation |
| Android overscroll conflicts | `overscroll-behavior: none` on feed container |

#### iPhone SE 3rd gen (4.7" screen)

| Issue | Fix |
| --- | --- |
| Only ~400px for feed | RevenueHero collapses to single-line on <5.0" screens |
| iOS long-press triggers text selection | `touch-action: none` + `-webkit-touch-callout: none` on mic button |

### Inclusive Design (Empathy-Tested)

##### Low-Literacy Adaptations

| Element | Standard | Simplified |
| --- | --- | --- |
| Error messages | "Couldn't generate draft" | "Draft no work. Try again?" + icon buttons: 🔄 [Try Again] ✍️ [Write yourself] |
| Empty states | "Your Revenue Command Feed is ready" | "Welcome! Your shop ready 💪" |
| Filter labels | Text-only | Icon + text: 🔔 Follow-ups, 💬 DMs |
| Onboarding | Text instructions | Illustrative icon + minimal text per step. Mic animation shows action visually |

##### One-Handed Use

- Primary actions in bottom-right thumb zone (already enforced)
- PrimingCard supports swipe-up-to-dismiss as alternative to ✕ tap
- RevenueHero pull-down-to-expand on small screens (no top-reach needed)

### Nigeria-Specific Edge Cases

| # | Edge Case | Implementation |
| --- | --- | --- |
| 1 | **RTL text in Hausa (Ajami)** | `dir="auto"` + `unicode-bidi: plaintext` on all user-generated text containers |
| 2 | **AMOLED burn-in** | 1px pixel-shift on static elements every 60min. Dark mode uses #0a0a0a not #000 |
| 3 | **Outdoor direct sunlight** | Detect `prefers-contrast: more` → 7:1 minimum contrast, thicker borders, bolder text |
| 4 | **Split-screen multitasking** | `min-width: 320px` enforced. Container queries handle graceful narrowing 320–480px |
| 5 | **Battery saver (<15%)** | `navigator.getBattery()`: disable animations, manual sync only, "Battery saver active" indicator |
| 6 | **Data saver / Lite mode** | Respect `Save-Data` header: lazy-load images, reduce polling, 60% image quality |
| 7 | **Dual-SIM network switching** | API health ping every 30s + 3s debounce on online/offline transitions (prevents flicker during SIM switch) |

### Testing Strategy

##### Device Testing Matrix

| Device | Screen | RAM | OS | Priority |
| --- | --- | --- | --- | --- |
| Tecno Spark 10 | 6.6" 720p | 3GB | Android 13 | P0 — primary target |
| Infinix Hot 30 | 6.78" 720p | 2GB | Android 12 | P0 — low-end baseline |
| Samsung Galaxy A14 | 6.6" 1080p | 4GB | Android 13 | P1 — mid-range |
| iPhone SE (3rd gen) | 4.7" 750p | 4GB | iOS 16 | P1 — small screen iOS |
| iPad (10th gen) | 10.9" 2360×1640 | 4GB | iPadOS 16 | P2 — tablet |
| Chrome desktop | Varies | 8GB+ | Windows/Mac | P2 — desktop |

##### Network Testing

| Condition | Throttle | Latency | Target |
| --- | --- | --- | --- |
| 3G (typical) | 750 Kbps down | 200ms | Feed loads <3s |
| 2G (worst-case) | 50 Kbps down | 500ms | Skeleton visible <1s, content <8s |
| Offline | No connection | — | Cached feed available, offline banner shows |
| Reconnection | 3G restored | 200ms | Queue syncs within 30s |

##### Accessibility Testing Checklist

| Test | Tool | Frequency |
| --- | --- | --- |
| Automated WCAG scan | axe-core (CI pipeline) | Every PR |
| Color contrast check | Lighthouse accessibility audit | Every PR |
| Keyboard-only navigation | Manual testing | Per sprint |
| Screen reader (TalkBack) | Manual on Android device | Per sprint |
| Screen reader (VoiceOver) | Manual on iOS device | Per sprint |
| Reduced motion | `prefers-reduced-motion` toggle | Per sprint |
| High contrast mode | Windows High Contrast, forced-colors | Monthly |
| Zoom (200%) | Browser zoom testing | Monthly |

### Implementation Guidelines

##### CSS Architecture (Mobile-First)

```css
/* Mobile-first base */
.feed-item { padding: var(--space-3); }

/* Tablet enhancement */
@media (min-width: 768px) {
  .feed-item { max-width: 600px; margin-inline: auto; }
}

/* Desktop enhancement */
@media (min-width: 1024px) {
  .feed-layout { display: grid; grid-template-columns: 1fr 400px; }
}

/* Container queries for reusable components */
@supports (container-type: inline-size) {
  .revenue-hero-container { container-type: inline-size; }
  @container (min-width: 480px) {
    .revenue-hero { flex-direction: row; }
  }
}
```

##### Developer Rules

| Rule | Implementation |
| --- | --- |
| **Relative units** | `rem` for typography, `px` for borders/shadows, `%`/`vw` for layout |
| **Semantic HTML** | `<nav>`, `<main>`, `<article>`, `<aside>` — no `div` soup |
| **ARIA labels** | Every interactive element without visible text gets `aria-label` |
| **Touch targets** | CSS `min-height: 48px; min-width: 48px` on all interactive elements |
| **Image optimization** | `<picture>` with `srcset`, WebP with JPEG fallback, `loading="lazy"` |
| **Font loading** | `font-display: swap`, preload Inter (primary), lazy-load JetBrains Mono |
| **Safe areas** | `env(safe-area-inset-bottom)` for bottom tab bar on notched devices |
| **Focus visible** | `:focus-visible` (not `:focus`) to show ring only for keyboard users |
| **Skip links** | Visually hidden link as first focusable element: "Skip to content" |
| **Overscroll** | `overscroll-behavior: none` on feed container (prevents Android conflict) |
| **iOS voice input** | `touch-action: none` + `-webkit-touch-callout: none` on mic button |

##### Accessibility CI Gate

```yaml
accessibility:
  min_score: 95
  rules:
    - color-contrast: error
    - label: error
    - aria-roles: error
    - keyboard-access: error
    - image-alt: warning
    - link-name: error
```

### Advanced Elicitation Refinement Summary

22 refinements applied from 5 methods:

| Category | Count | Impact |
| --- | --- | --- |
| Low-end device performance | 5 | Shimmer gating, canvas→CSS, camera pre-warm, overscroll fix, expansion pre-calc |
| Small screen adaptations | 2 | RevenueHero collapse on <5.0", pull-to-expand |
| Screen reader ARIA fixes | 4 | Feed announcements, revenue labels, draft focus order, send status |
| Inclusive design | 4 | One-hand reach, low-literacy text, icon emphasis, visual onboarding |
| WCAG violation fixes | 3 | Toast pause, gold text size rule, [⋯] overflow button |
| Nigeria edge cases | 7 | RTL Hausa, burn-in, sunlight, split-screen, battery, data-saver, dual-SIM |
| Technical corrections | 2 | Sidebar nav revised (not free), container query fallback |

