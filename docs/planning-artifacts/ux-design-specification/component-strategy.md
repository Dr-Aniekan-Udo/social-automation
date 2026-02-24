# Component Strategy

### Design System Coverage

##### shadcn/ui Base Components (25 — Ready to Use)

| shadcn Component | MarketBoss Customization | Primary Journey |
| ----------------- | -------------------------- | ---------------- |
| Button | Emerald accent, 48px min touch, haptic | All |
| Card | Revenue hero, receipt, feed item shells | All |
| Input | ₦ prefix, voice-input variant | Content, Onboarding |
| Dialog | Bottom sheet (mobile-native), not centered | DM Close |
| Toast | "Published ✅" and "₦8,500 received 🎉" | Content, DM Close |
| Tabs | Bottom nav: Home / Messages / Create / Profile | All |
| Avatar | With 🔥/❓ revenue signal badges | DM Close |
| Badge | State indicators (DRAFT_READY, SENT, etc.) | All feed items |
| Tooltip | Command bar hints | Morning Triage |
| Skeleton | Draft loading shimmer | DM Close |
| Progress | Onboarding stepper progress | Onboarding |
| Switch | Settings toggles | Settings |
| Select | Platform picker (IG/WA/Both) | Content |
| Label | Form field labels | All forms |

### Custom Components

**15 custom components across 3 tiers**, mapped to user journeys:

#### Build Strategy

| Strategy | Components | Count |
| ---------- | ----------- | :-----: |
| Build Custom | FeedItem, DraftBox, PrimingCard, ChatBubble, TransactionCard, RevenueHero, StarRating, VoiceCapture, CameraCapture | 9 (60%) |
| Extend shadcn | ToneChipGroup (→ToggleGroup), StatsPanel (→Tabs+Card), CommandBar (→Command/cmdk), EmptyState (→Card) | 4 (27%) |
| 3rd Party + Customize | DraftSwiper (→Embla Carousel), SwipeableRow (→react-swipeable) | 2 (13%) |

---

#### Tier 1 — Critical Path (DM Close)

##### FeedItem

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Core feed card — primary interaction unit in the Revenue Command Feed |
| **Content** | Avatar, sender name, preview text, timestamp, type badge, action button |
| **Actions** | Tap to expand (DM), mark shipped (SALE), review (CONTENT), dismiss (FOLLOW-UP) |
| **States** | `NEW`, `DRAFT_READY`, `EDITING`, `SENDING`, `SENT` (✓ 80% opacity), `DISMISSED`, `MANUAL_REPLIED` (50% opacity), `COMPLETED`, `OFFLINE` (cached, ⚠️ banner) |
| **Variants** | `DM` (blue), `SALE` (green + ₦), `CONTENT` (yellow), `FOLLOW_UP` (purple), `MANUAL_REPLIED` (grey) |
| **Accessibility** | `role="article"`, `aria-label="[type] from [sender]"`, Enter/Escape for expand/collapse |
| **Failure Prevention** | Virtual scrolling (`@tanstack/virtual`) for 100+ items on 2GB RAM. Optimistic UI + IndexedDB for offline state persistence |

##### DraftBox

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Inline AI draft viewer within expanded FeedItem — core of 3-tap DM Close |
| **Content** | Customer message quote, AI-generated reply, SLM star rating, draft counter "Draft 1/3" |
| **Actions** | ➤ Send, ✏️ Edit, 🔄 New Draft (max 3), ✕ Dismiss |
| **States** | `VIEWING`, `EDITING` (inline text input), `REGENERATING` (shimmer), `SENDING` (spinner → ✓), `ERROR` ("AI couldn't generate draft" + [Try Again] [Compose Manually]) |
| **Accessibility** | `aria-live="polite"` for draft changes, focus trap within expanded area |
| **Failure Prevention** | Pre-measure height before expand to prevent layout shift. Skeleton until complete response — never stream partial text. Persist draft count per DM in local storage |

##### ToneChipGroup (Extend: shadcn ToggleGroup)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Tone selector for AI draft voice |
| **Content** | N configurable chips (default: Friendly / Pidgin / Formal). User can add custom tones in settings |
| **Actions** | Tap chip → regenerate draft in selected tone (counts toward 3-draft limit) |
| **States** | `ACTIVE` (filled emerald), `INACTIVE` (outlined), `DISABLED` (draft limit reached) |
| **Accessibility** | `role="radiogroup"`, each chip `role="radio"`, `aria-checked`, keyboard arrows |
| **Failure Prevention** | Horizontal scroll at <360px. Debounce 500ms on tone tap, disable during regeneration |

##### PrimingCard

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Context overlay — "caller ID for DMs" showing customer info before reply |
| **Content** | Customer name, product, price, stock, purchase history, behavioral hint |
| **Actions** | ✕ Dismiss (tap or auto-fade) |
| **States** | `VISIBLE` (slide-down), `FADING` (auto-dismiss), `DISMISSED` |
| **Variants** | 🔥 HOT LEAD (gold), ❓ NEW CUSTOMER (neutral), 🔄 RETURNING (emerald) |
| **Accessibility** | `role="complementary"`, `aria-live="assertive"`. No auto-dismiss when screen reader active |
| **Failure Prevention** | `transform: translateY` only for animation. Pause timer on touch/focus, extend to 5s |

##### ChatBubble

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | WhatsApp-style message bubbles for DM conversations |
| **Content** | Message text, timestamp, read receipts (✓✓), sender avatar |
| **Actions** | Tap-hold for context menu (copy, quote, flag) |
| **States** | `SENT` (✓), `DELIVERED` (✓✓), `READ` (blue ✓✓), `FAILED` (red !) |
| **Variants** | `INCOMING` (left, light bg), `OUTGOING` (right, emerald bg), `AI_DRAFT` (dashed border, sparkle) |
| **Accessibility** | `role="listitem"` within `role="list"` |
| **Design Rule** | AI draft indicator visible ONLY to seller. Zero AI attribution visible to customer |
| **Failure Prevention** | Virtualized list — load last 20, lazy-load on scroll up. Solid border fallback on <2x DPI |

##### TransactionCard (Merged: PaymentLinkCard + ReceiptCard)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Unified payment lifecycle — request through confirmation |
| **Content** | 💳/✅ icon, amount (₦-formatted via `Intl.NumberFormat('en-NG')`), product, customer, status |
| **Actions** | Payment: edit amount, send link. Receipt: [📦 Ship] [💬 Thank Customer] |
| **States** | `DRAFT` (editable), `SENT` (tracking), `PAID` (✅ + 🎉 confetti), `FAILED` (⚠️), `EXPIRED` (grey, 24h), `LATE_PAID` (paid after expiry, with note) |
| **Variants** | `payment-request` (inline chat embed), `receipt` (feed confirmation card) |
| **Accessibility** | `role="region"`, `aria-label="Payment [status] ₦[amount]"` |
| **Failure Prevention** | Open Paystack in system browser (not in-app WebView). Webhook push for status (not polling). CSS-only confetti, 20 particles max, `prefers-reduced-motion` off. Backend accepts late payments after UI expiry |

---

#### Tier 2 — Important (Content + Morning Triage)

##### RevenueHero

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | OPay-style revenue balance card — emotional anchor at top of feed |
| **Content** | Today's revenue (₦), change indicator (↑ ₦ / %), comparison subtitle |
| **Actions** | Tap to expand StatsPanel |
| **States** | `COLLAPSED`, `EXPANDED`, `LOADING` (skeleton) |
| **Accessibility** | `role="banner"`, `aria-label="Today's revenue ₦[amount]"`, `aria-expanded` |
| **Design** | JetBrains Mono, gold on dark bg. Currency via `currency` prop (₦ default, not hardcoded) |
| **Failure Prevention** | `font-display: swap` + preload mono subset. Animate on first view only, static thereafter |

##### StatsPanel (Extend: shadcn Tabs + Card)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Expandable 3-stat grid beneath RevenueHero |
| **Content** | Sales count, Hot Leads, Close Rate %. Time toggle: Today/Week/Month |
| **Actions** | Tap time filters, tap stat for drill-down |
| **States** | `HIDDEN`, `EXPANDED`, `LOADING` (skeleton cards) |
| **Accessibility** | `role="region"`, time toggles as `role="tablist"` |
| **Failure Prevention** | 2-column at <360px, stack at <320px. Single API call returns all 3 time ranges (cached). Debounce 300ms + AbortController on rapid toggles |

##### CommandBar (Extend: shadcn Command / cmdk)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Unified search + slash command input — "universal escape hatch" |
| **Content** | Search icon, text input, `/` command badge |
| **Actions** | Type to search (filter feed). MVP: search-only. Phase 2: slash commands (/stats, /post, /help) |
| **States** | `IDLE`, `FOCUSED` (expanded), `COMMAND_MODE` (slash detected), `SEARCHING` (filtering) |
| **Accessibility** | `role="search"`, `aria-expanded` for suggestions, `/` to focus, Escape to clear |
| **Failure Prevention** | Overlay + backdrop for autocomplete (max 5 items). 150ms debounce, skeleton on keystroke. First-time tooltip: "Try `/stats` or `/post`" |

##### DraftSwiper (Extend: shadcn Carousel / Embla)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Horizontal swipe for reviewing multiple AI content drafts |
| **Content** | Draft card: photo preview, caption, SLM rating, "1 of 3" counter |
| **Actions** | Swipe between drafts, double-tap to approve, tap ✏️ to edit |
| **States** | `DEFAULT`, `SWIPING`, `APPROVING` (pulse animation) |
| **Accessibility** | `role="listbox"`, each card `role="option"`, keyboard arrow support |
| **Failure Prevention** | CSS `scroll-snap` via Embla (not custom spring physics — 80% less effort). 20px edge exclusion zone for Android back gesture |

##### StarRating

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | "Sounds Like Me" 1-5 star rating for AI draft quality feedback |
| **Content** | 5 stars, optional label, average rating display when collapsed |
| **Actions** | Tap to rate. After 10+ ratings: auto-collapses to "⭐ 4.2 avg" (tap to expand and re-rate) |
| **States** | `UNRATED`, `RATED` (fill animation), `COLLAPSED` (shows average, always re-ratable) |
| **Accessibility** | `role="slider"`, `aria-valuemin/max/now` |
| **Failure Prevention** | 40px stars + 8px gap = 232px (fits 320px). Center-point detection for fat-finger prevention |

---

#### Tier 3 — Onboarding & Enhancement

##### VoiceCapture (Merged: VoiceInput + VoiceRecorder)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Unified audio capture — product entry and brand voice recording |
| **Modes** | `product-entry` (tap-hold, NLP parses name + price), `brand-voice` (timed recording for AI training) |
| **States** | `IDLE`, `RECORDING` (red pulse + waveform), `PROCESSING`, `PARSED`/`CONFIRMED` |
| **Accessibility** | `aria-label="Hold to record voice"`, `aria-live="polite"` for results |
| **Failure Prevention** | Feature detection for MediaRecorder (fallback: text input). Compress to Opus/WebM, max 30s, ~50KB. Auto-save chunks to IndexedDB on background. Confidence indicator: low confidence → "Did you mean?" confirmation |

##### CameraCapture

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Direct camera for product photos — no "choose source" dialog |
| **Content** | Camera viewfinder, shutter button, recent captures strip |
| **States** | `VIEWFINDER`, `CAPTURED` (preview + confirm/retake), `PROCESSING` |
| **Accessibility** | `aria-label="Take product photo"`, haptic on capture |
| **Failure Prevention** | Graceful fallback to file picker on permission denied. Auto-resize to 1080px max, compress to 80% JPEG |

##### SwipeableRow (3rd Party: react-swipeable) — Phase 3

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Swipe gestures on feed items for quick actions |
| **MVP Alternative** | Long-press context menu (zero gesture conflicts) |
| **Phase 3 Design** | Swipe left: 🗂️ Archive / 🚩 Flag. Swipe right: ↩️ Quick Reply |
| **Failure Prevention** | 40% width threshold + haptic at threshold. Actions also available via long-press for non-gesture users |

##### EmptyState (Extend: shadcn Card)

| Attribute | Detail |
| ----------- | -------- |
| **Purpose** | Contextual zero-state messaging — never show a blank screen |
| **Variants** | `ALL_CAUGHT_UP` (🎉), `NO_ITEMS` (first-time), `FILTERED_EMPTY` (no results), `POST_ONBOARDING` |
| **Accessibility** | `role="status"`, `aria-label="[context message]"` |
| **Failure Prevention** | Show only after 500ms timeout + API confirms empty (prevent flash). Feature-flag CTAs for unreleased features |

---

### Component Implementation Strategy

#### Dependency Tree

```text
RevenueHero → StatsPanel (child expands within)
FeedItem → DraftBox (inline expansion)
FeedItem → ToneChipGroup (within DraftBox)
FeedItem → StarRating (within DraftBox)
FeedItem → TransactionCard (within chat thread)
FeedItem → SwipeableRow (gesture layer wrapping FeedItem)
CommandBar → EmptyState (filtered empty results)
ChatBubble → TransactionCard (embedded within)
```

#### Shared Design Token Usage

All 15 custom components consume the same tokens as shadcn base:

| Token | Value | Purpose |
| ------- | ------- | --------- |
| `--color-primary` | Emerald | Primary actions, active states |
| `--color-accent` | Gold | Revenue, celebrations, highlights |
| `--radius` | Design system default | Consistent border radius |
| `--spacing-*` | 8px grid | Layout consistency |
| `--font-family` | Inter | Body text |
| `--font-mono` | JetBrains Mono | Revenue amounts, stats |

---

### Architecture Decision Records

| ADR | Decision | Rationale |
| :---: | ---------- | ----------- |
| 1 | Build FeedItem custom (not shadcn Card) | 9 states, 5 variants, inline expansion, auto-collapse — no existing component handles this state machine |
| 2 | Extend shadcn Command for CommandBar | cmdk is battle-tested, accessible, keyboard-friendly. We add mobile search bar + slash registry. 70% done by library |
| 3 | Merge PaymentLinkCard + ReceiptCard → TransactionCard | Same data model. Payment → Receipt is state transition, not component switch. Less bundle, simpler mental model |
| 4 | CSS scroll-snap for DraftSwiper (not custom physics) | Custom spring physics = 2+ weeks tuning. CSS scroll-snap is GPU-accelerated, Embla adds card-snap. 80% less effort, indistinguishable UX |
| 5 | Defer SwipeableRow to Phase 3 (long-press for MVP) | Swipe conflicts with OS gestures, requires extensive device testing. Long-press achieves same actions with zero conflicts |

### Failure Mode Prevention Summary

| Component | Failure | Fix |
| ----------- | --------- | ----- |
| FeedItem | 100+ items jank on 2GB RAM | Virtual scrolling (`@tanstack/virtual`), render visible + 3 buffer |
| FeedItem | State lost on network drop | Optimistic UI + IndexedDB persistence. OFFLINE state added |
| DraftBox | Layout shift on expansion | Pre-measure height, animate from 0 |
| DraftBox | Partial/gibberish AI draft | ERROR state + [Try Again] [Compose Manually]. Never show partial |
| ToneChipGroup | Overflow on 360px, rapid taps | Horizontal scroll + 500ms debounce |
| PrimingCard | Screen reader can't read in 3s | No auto-dismiss when assistive tech active |
| ChatBubble | 200+ messages scroll jank | Virtualized list, load last 20 |
| TransactionCard | In-app browser payment fail | Open in system browser, webhook status |
| TransactionCard | Confetti frame drops | CSS-only, 20 particles, prefers-reduced-motion |
| RevenueHero | Counter animation drains battery | Animate on first view only |
| StatsPanel | Grid overflow on 320px | 2-column at <360px, stack at <320px |
| CommandBar | Autocomplete covers feed | Overlay + backdrop, max 5 items |
| DraftSwiper | Conflicts with Android back | 20px edge exclusion zone |
| StarRating | Fat finger on small screens | 40px stars, center-point detection |
| VoiceCapture | MediaRecorder unsupported | Feature detection, text input fallback |
| CameraCapture | Permission denied | Graceful fallback to file picker |

### Implementation Roadmap

#### Phase 1 — Core Feed (Weeks 1-2)

Enables: Morning Triage + Feed foundation

| Component | Priority | Strategy |
| ----------- | :--------: | ---------- |
| FeedItem (5 variants) | 🔴 P0 | Build custom |
| RevenueHero | 🔴 P0 | Build custom |
| CommandBar (search only) | 🔴 P0 | Extend shadcn Command |
| EmptyState | 🔴 P0 | Extend shadcn Card |
| StatsPanel | 🟡 P1 | Extend shadcn Tabs + Card |

#### Phase 2 — DM Close Flow (Weeks 3-4)

Enables: Defining Experience (3-tap close)

| Component | Priority | Strategy |
| ----------- | :--------: | ---------- |
| DraftBox | 🔴 P0 | Build custom |
| ToneChipGroup | 🔴 P0 | Extend shadcn ToggleGroup |
| ChatBubble | 🔴 P0 | Build custom |
| PrimingCard | 🟡 P1 | Build custom |
| StarRating | 🟡 P1 | Build custom |
| TransactionCard | 🟡 P1 | Build custom |

#### Phase 3 — Content + Onboarding (Weeks 5-6)

Enables: Content creation, onboarding, polish

| Component | Priority | Strategy |
| ----------- | :--------: | ---------- |
| DraftSwiper | 🟡 P1 | Extend shadcn Carousel (Embla) |
| SwipeableRow | 🟢 P2 | 3rd party (react-swipeable) |
| VoiceCapture | 🟢 P2 | Build custom |
| CameraCapture | 🟢 P2 | Build custom |

#### Phase 2 Additions — CommandBar Slash Commands

| Feature | Description |
| --------- | ------------- |
| `/stats` | Open full stats panel |
| `/post` | Quick content creation |
| `/help` | In-app help overlay |
| Custom commands | User-defined shortcuts (future) |
