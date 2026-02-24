# UX Consistency Patterns

Established through 7 pattern categories, refined via 18 improvements from Advanced Elicitation (Customer Support Theater, Failure Mode Analysis, Self-Consistency Validation, Comparative Analysis Matrix, First Principles Analysis).

### Button Hierarchy

**3-Level System** — never more than 2 visible simultaneously:

| Level | Style | Use Case | Example |
| --- | --- | --- | --- |
| **Primary** | Filled emerald, 48px height, white text, shadow | One per screen — the action that drives revenue | ➤ Send Draft, 📦 Ship, 💳 Send Payment Link |
| **Secondary** | Outlined emerald, 48px height, emerald text | Supporting action alongside primary | ✏️ Edit, 🔄 New Draft, View Details |
| **Tertiary** | Text-only, no border, emerald text, 44px touch | Low-priority or destructive when paired | ✕ Dismiss, Skip, Cancel |

##### Button Rules

- Never stack 2 primaries — forces choice paralysis
- Destructive actions (delete, dismiss permanently) use red tertiary, never primary
- Icons left, text right — icon alone only if universally understood (✕, ←)
- **Loading state:** Primary shrinks to circle + spinner, text fades. `pointer-events: none` at frame 0 (instant disable, visual follows) — prevents double-tap
- **Disabled:** 40% opacity, `aria-disabled="true"`, no pointer events
- **Haptic:** Light tap on primary press, medium on destructive confirm (optional — feature detection required)

##### DM Close Button States

| State | Primary | Secondary | Tertiary |
| --- | --- | --- | --- |
| Draft Ready | ➤ Send | ✏️ Edit | ✕ Dismiss |
| Editing | ➤ Send | 🔄 Regenerate | ✕ Cancel |
| Payment | 💳 Send Link | ✏️ Edit Amount | — |

### Feedback Patterns

**6-Tier System** — expanded from 4 with delivery confirmation and offline send:

| Type | Color | Icon | Position | Duration | Haptic |
| --- | --- | --- | --- | --- | --- |
| **Success** | Emerald | ✅ | Top toast + inline feed item ✓ | 3s auto-dismiss | Double-tap (optional) |
| **Delivery Confirmed** | Emerald | ✅✅ | Inline feed item only | Persistent ✓✓ | None |
| **Sending** | Grey | ⏳ | Inline feed item spinner | Until confirmed or failed | None |
| **Error** | Red | ⚠️ | Inline (below field) or top toast | Persist until resolved | Error buzz (optional) |
| **Warning** | Amber | ⚡ | Inline badge or toast | 5s or until action | Light tap (optional) |
| **Info** | Slate/blue | ℹ️ | Inline or tooltip | Until dismissed | None |

##### Feedback Rules

- **Toast:** Top-positioned, never bottom (nav bar conflict). Max 1 toast visible
- **Inline errors** always preferred over toasts for form validation
- **Scroll-to-error:** When inline error appears, `scrollIntoView({ behavior: 'smooth', block: 'center' })`. If still hidden by keyboard, show as toast fallback
- **Celebrations** (revenue received): Full-width emerald banner + confetti (CSS-only, `prefers-reduced-motion` respects). Shows ₦ amount prominently
- **Revenue toasts persist 5s** (not 3s) + leave emerald dot on RevenueHero — sellers in busy markets may glance between customers
- **Undo window:** 5-second toast with [Undo] for destructive actions (dismiss, archive). Action executes only after window expires
- **Offline:** Persistent amber banner at top: "📡 Offline — changes will sync when connected". Never auto-dismiss

**Stacking Rule:** PrimingCard always wins top position. Toasts queue until priming card dismisses. "New items ↑" pill is a floating action (separate z-layer), coexists with both.

**Delivery Confirmation Flow** (replaces blind optimistic UI):

| Stage | Visual | Timing |
| --- | --- | --- |
| User taps Send | "Sending..." spinner on feed item | Immediate |
| Platform confirms delivery | ✅ "Delivered" on feed item + ✅ toast | Within 10s |
| Delivery fails | ⚠️ "Couldn't deliver — [Resend] [Copy Link]" | Within 10s |

##### Offline Send Behavior

- Online send: ✅ green checkmark
- Offline send: 🕐 grey clock icon + "Will send when connected" — NOT a green checkmark
- Synced: 🕐 → ✅ transition when back online

##### Revenue-Specific Feedback

| Event | Feedback |
| --- | --- |
| ₦ received | 🎉 Confetti + "₦8,500 received from Chioma!" toast (gold accent, 5s) + emerald dot on RevenueHero |
| Draft sent | "Sending..." → ✅ "Delivered" (confirmed) + feed item fades to 80% opacity |
| Payment link sent | "Sending link..." → 💳 "Payment link delivered" (confirmed) |
| AI draft failed | ⚠️ Inline: "Couldn't generate draft" + [Try Again] [Compose Manually] |
| 3/3 drafts used | ⚡ Amber badge: "Draft limit reached" — tone chips disabled |

### Form Patterns

##### Input Hierarchy

| Input Type | Style | Validation | Example |
| --- | --- | --- | --- |
| **Text** | Bottom-bordered (not boxed), 48px height, 16px text (no zoom on iOS) | Debounce 300ms, inline error below | Product name, message edit |
| **Currency (₦)** | ₦ prefix (non-editable), right-aligned number, numpad keyboard | Real-time formatting as user types, `maximumFractionDigits: 0` | ₦8,500 (never ₦8,500.00) |
| **Voice** | Mic button + "Hold to speak" label, waveform during recording | Show raw transcript first → parsed editable fields ("Name: [***] Price: [₦***]") | "Ankara dress, 8500 naira" |
| **Camera** | Direct viewfinder (no source picker), shutter + recent strip | Auto-resize 1080px, 80% JPEG | Product photo |
| **Selection** | Chip group (not dropdown — faster on mobile) | Default pre-selected, single-select | Tone: Friendly / Pidgin / Formal |

##### Form Rules

- No multi-step forms in the feed context. If >3 fields needed, use bottom sheet
- **Default-then-override:** Always pre-fill with intelligent defaults. User edits only if needed
- **Validation timing:** `onBlur` for text, `onChange` for selects/chips, never `onKeyUp`. Exception: DraftBox inline edit validates on [Send] tap only (no blur event)
- **Currency formatting:** Real-time as user types (adopted from OPay): "₦8,5" → "₦8,50" → "₦8,500"
- **Labels:** Above input (not placeholder-as-label — disappears, frustrates). Always visible
- **Error state:** Red bottom border + red text below. Never shake/animate the input
- **Success state:** Emerald checkmark appears right of input on valid entry
- **Keyboard:** `inputmode="numeric"` for currency, `inputmode="text"` for names, `enterkeyhint="send"` for messages
- **Tone switching:** AbortController for tone changes. New tone tap → abort previous request → start new. Brief "Switching to [Tone]..." indicator

##### Onboarding Forms (3-step flow)

| Step | Input Method | Default | Validation |
| --- | --- | --- | --- |
| 1. Add product | Voice → NLP parse → confirm card with editable fields | Pre-parsed name + price | "Did you mean?" confirmation |
| 2. Brand voice | 30s voice recording | Skip available | Minimum 5s recording |
| 3. Connect platform | OAuth button (IG/WA) | Both pre-checked | At least 1 platform required |

### Navigation Patterns

##### Bottom Tab Bar (4 tabs)

| Tab | Icon | Label | Badge |
| --- | --- | --- | --- |
| Home | 🏠 | Feed | Red dot (unread actions) |
| Messages | 💬 | DMs | Count badge (unread DMs) |
| Create | ✨ | Create | — |
| Profile | 👤 | Me | — |

##### Navigation Rules

- No hamburger menus — all primary navigation via bottom tabs
- **Back behavior:** Android hardware back = collapse expanded item → previous tab → exit. Never trap user
- **Tab state persistence:** Each tab remembers scroll position when switching. Feed resumes exactly where left
- **Feed scroll:** Pull-down to refresh (with haptic + RevenueHero "counting up" animation). Infinite scroll with virtual rendering
- **New items indicator:** If <5 new items, prepend silently. If ≥5, show "5 new items ↑" floating pill (tap to scroll up)
- **Inline expansion:** Feed items expand in-place (push down, don't navigate away). **Threshold:** If expansion adds >300px height, navigate to dedicated screen instead (prevents virtualization struggle on 2GB RAM)
- **Deep linking:** Every feed item has a shareable URL. Opening deep link = navigate to tab → scroll to item → auto-expand. If item is handled/dismissed, show "This item has been handled" card + [Back to Feed]

##### Transition Animations

All transitions must pass the **Tecno test** — `transform` and `opacity` only (GPU-composited), CSS transitions not JS, max 2 concurrent animations on screen.

| Transition | Animation | Duration |
| --- | --- | --- |
| Tab switch | Cross-fade | 150ms |
| Feed item expand | Height animate + push | 250ms ease-out |
| Feed item collapse | Height animate + pull | 200ms ease-in |
| Bottom sheet open | Slide up + backdrop fade | 300ms spring |
| Bottom sheet close | Slide down + backdrop fade | 250ms ease-in |
| Page navigate | Slide left/right | 300ms ease-out |

**Timing hierarchy:** Specific override > category default > 300ms global default.

##### Gesture Map

| Gesture | Context | Action |
| --- | --- | --- |
| Tap | Feed item | Expand inline |
| Tap | Expanded item button | Execute action |
| Pull down | Feed (top) | Refresh + RevenueHero update |
| Scroll | Feed | Navigate items |
| Long-press | Feed item (MVP) | Context menu (Archive / Flag / Reply) |
| Swipe left | Feed item (Phase 3) | Archive / Flag |
| Swipe right | Feed item (Phase 3) | Quick Reply |
| Swipe down | Bottom sheet | Dismiss |
| Edge swipe | Anywhere | OS back (excluded from app gestures) |

### Modal and Overlay Patterns

**3-Type System** — no centered modals on mobile:

| Type | Behavior | Use Case | Dismiss |
| --- | --- | --- | --- |
| **Bottom Sheet** | Slide up from bottom, backdrop dims | Payment details, edit forms, settings | Swipe down or tap backdrop |
| **Priming Card** | Slide down from top, no backdrop | Customer context ("caller ID") | Auto-fade 3–5s or tap ✕ |
| **Confirmation Guard** | Bottom sheet + 2-button | Destructive actions (dismiss lead, delete product) | Explicit button only |

##### Modal Rules

- Never use centered modals on mobile — they feel desktop-ported and block thumb reach
- **Bottom sheets:** Max 60% screen height. If content exceeds, make scrollable within sheet. Respect `visualViewport.height` (not `window.innerHeight`) — shrink content area when keyboard appears
- **Backdrop:** 50% black opacity. Tap-to-dismiss on backdrop for non-destructive sheets
- **Confirmation guard pattern:**
  - Title: "Dismiss this lead?" (question, not statement)
  - Body: Consequence text: "Chioma's message will move to archive"
  - Buttons: [Cancel] (secondary left) [Dismiss] (destructive right)
  - No "Are you sure?" patterns — state the consequence directly
- **Stacking:** Maximum 1 overlay at a time. If second needed, replace first (don't stack)
- **Overlay sequencing:** PrimingCard auto-dismisses (200ms) BEFORE confirmation guard slides up (300ms). Never simultaneous
- **Accessibility:** Focus trap within overlay. Escape key dismisses. `aria-modal="true"`, `role="dialog"`

##### Priming Card Behavior

| Scenario | Behavior |
| --- | --- |
| Normal view | Slide down, auto-fade 3s |
| User touches card | Pause timer, extend to 5s after release |
| Screen reader active | No auto-dismiss, persist until explicit ✕ |
| Multiple cards queued | Show one at a time, 1s gap between |

### Loading and Empty States

##### Loading Pattern Hierarchy

| Type | Visual | When | Context |
| --- | --- | --- | --- |
| **Skeleton** | Shimmer rectangles matching content shape (tied to component CSS custom properties) | Initial feed load, draft generation | CONTENT loading |
| **Spinner** | Small circular, emerald (replaces button text, button shrinks to circle) | Inline action (send, regenerate) | ACTION execution |
| **Progress bar** | Linear, emerald fill | Multi-step (onboarding, upload) | Known duration |
| **Optimistic UI** | Immediate visual change, revert on failure | Mark shipped, toggle setting | Instant feedback |

##### Loading Rules

- **Skeleton over spinner** for content — skeletons reduce perceived wait time by 30%
- **Never blank screen.** Transition: previous content → skeleton → new content
- **Skeleton dimensions** tied to component CSS custom properties (`min-height`). Same dimensions as rendered content to prevent jarring "pop"
- **Spinner placement:** Inline (replace the button text, not beside it). Button shrinks to circle
- **Timeout:** If load >5s, show "Taking longer than usual..." message. At 15s, show retry option
- **Optimistic UI** applies to user actions (instant feedback). Empty state delay (500ms) applies to initial loads. Different contexts, both valid
- **Pull-to-refresh:** RevenueHero amount updates with "counting up" animation (adopted from OPay)

##### Empty State Variants

| Variant | Visual | Message | CTA |
| --- | --- | --- | --- |
| **All caught up** 🎉 | Celebration illustration | "You've handled everything! 💪" | Latest stats summary |
| **No items (first time)** | Welcome illustration | "Your Revenue Command Feed is ready" | "Connect Instagram" / "Add your first product" |
| **Filtered empty** | Search illustration | "No [type] items right now" | "Clear filter" button |
| **Offline empty** | Cloud-offline icon | "You're offline — cached items shown" | "Retry when connected" |
| **Post-onboarding** | Progress celebration | "Great start! Waiting for first customer message" | "Share your profile link" |
| **Deep link expired** | Handled illustration | "This item has been handled" | [Back to Feed] |

##### Empty State Rules

- Show only after 500ms + API confirms empty (prevent flash of empty → content)
- Always provide a CTA — never dead-end the user
- Illustration style: Line-art, emerald accent, same as brand. Not generic stock illustrations
- Tone: Encouraging, never negative. "You've handled everything!" not "Nothing here"

### Search and Filtering

##### CommandBar Search

| Feature | Behavior |
| --- | --- |
| **Placement** | Fixed below RevenueHero, above feed (`position: sticky`) |
| **Adaptive display** | Icon-only ("🔍") on feeds with <30 items. Full search bar at 30+ items (saves 48px) |
| **Focus** | Expands to full width, keyboard rises, backdrop. Scroll position locked before keyboard opens |
| **Results** | Filter feed in-place (not separate results page) |
| **Debounce** | 150ms — fast enough to feel instant, slow enough to prevent API spam |
| **No results** | EmptyState variant: "No items match '[query]'" + [Clear] |
| **Keyboard shortcut** | `/` focuses CommandBar (desktop) |

##### Feed Type Filters

| Filter | Badge | Behavior |
| --- | --- | --- |
| All | — | Default, shows everything |
| 💬 DMs | Blue | Only DM-type feed items |
| 💰 Sales | Green | Only sale/payment items |
| 📝 Content | Yellow | Only content review items |
| 🔔 Follow-ups | Purple | Only follow-up items |

##### Filter Rules

- **Chip bar** below CommandBar, horizontal scroll if overflow
- **Chip sizing:** 36px height, 48px touch target (padding extends hit area beyond visual chip)
- **Single-select** + "All" default. Tap active filter to deselect (return to All)
- **Count badges** on each filter: "💬 DMs (3)" — shows unactioned count
- **Filter + Search combine:** Selecting "DMs" then searching only searches within DMs
- **Persist filter** across tab switches within session. Reset on app restart
- **Animate transition:** Feed items fade/scale to filtered set (200ms, `opacity` + `transform` only)

##### Time Range Toggles (StatsPanel)

| Toggle | Data | Cache |
| --- | --- | --- |
| Today | Last 24h | Refresh every 5min |
| Week | Last 7 days | Refresh every 30min |
| Month | Last 30 days | Refresh every 1h |

##### Time Toggle Rules

- Single API call returns all 3 ranges (cached client-side)
- Debounce 300ms + AbortController for rapid toggles
- Active toggle: Filled emerald chip. Inactive: outlined
- Skeleton cards during toggle if data not cached

### Cross-Cutting Pattern Rules

##### Consistency Guarantees

| Rule | Description |
| --- | --- |
| **48px minimum touch** | Every interactive element: buttons, chips, stars, toggles |
| **16px minimum input text** | Prevents iOS zoom-on-focus. Body text minimum: 14px (see Typography Rules) |
| **8px spacing grid** | All margins, padding, gaps are multiples of 8 |
| **Emerald = action** | Emerald always means "this is interactive" |
| **Gold = money** | Gold always means "revenue, earnings, celebration" |
| **Red = error/danger** | Red only for errors and destructive confirmations |
| **300ms standard transition** | Default for all non-micro transitions (specific overrides take precedence) |
| **150ms micro transition** | Hover effects, active states, opacity changes |
| **Haptic language** | Light tap = action, double tap = success, buzz = error. ALL haptic is optional (feature detection). Every haptic has visual + audio equivalent |
| **No tooltips on mobile** | Tooltips are desktop-only. Mobile uses inline hints |
| **Right-hand thumb zone** | Primary actions in bottom-right quadrant of screen |

##### Animation Performance Rules (Tecno Test)

| Rule | Requirement |
| --- | --- |
| GPU compositing only | Use `transform` and `opacity` only — no `width`, `height`, `top`, `left` |
| CSS, not JS | CSS transitions/animations only — no JS-driven animation loops |
| Max concurrent | Maximum 2 simultaneous animations on screen |
| Reduced motion | `prefers-reduced-motion: reduce` disables ALL decorative animation. Functional animations (expand/collapse) remain |
| Decorative gating | Confetti, counting animations only on devices with >4GB RAM (detected via `navigator.deviceMemory`) |
