# Design Direction Decision

### Design Directions Explored

6 base design direction mockups were generated and evaluated (see `ux-design-directions.html`). The implementation target is a synthesized **Direction 7** ("Revenue Command Feed"), created by combining selected traits from 3 and 6:

| # | Direction | Approach | Evaluated Fit |
| --- | ----------- | ---------- | :-: |
| ① | Clean Dashboard | Revenue card + DM list, traditional | ⚠️ Too structured |
| ② | Conversation-First | DM Close flow as home, PrimingCard prominent | ✅ Strong but narrow |
| ③ | **Revenue-Focused** | Hero ₦, stats, money-first | ✅ **Selected** |
| ④ | WhatsApp-Native | Clone WA UI, AI as overlay | ⚠️ Clone risk |
| ⑤ | Card-Based Actions | Swipeable horizontal cards | ⚠️ Too busy |
| ⑥ | **Minimalist Command** | Feed + command bar, chronological | ✅ **Selected** |

### Chosen Direction

> **"Direction 7: Revenue Command Feed"** - canonical synthesized direction (Hybrid of 3 Revenue-Focused + 6 Minimalist Command)

##### Core traits

- Feed-based, chronological — everything is an event in one stream
- Money-first — hero revenue number always visible
- Command bar — Spotlight-style search + commands for power actions
- Minimal — no clutter, no dashboards, no tabs within tabs
- Action-oriented — every feed item has exactly one primary action
- Stats on-demand — expandable, not permanent

### Design Rationale

| Criteria | Why This Direction Wins |
| --------- | ------------------------ |
| Core experience | Feed items expand inline to full DM Close flow — no navigation |
| Emotional goal | Hero ₦ number answers "How much today?" instantly = "I feel powerful" |
| Speed | One-action-per-card + command bar = fastest possible interactions |
| Adoption | Feed is universally understood (WhatsApp status, IG feed, TikTok scroll) |
| Scalability | New event types (SALE, CONTENT, FOLLOW-UP) just add to the stream |
| Minimalism | No dashboard creep. Stats expand on demand, not permanently |

### Implementation Approach

#### Feed Architecture

```text
┌────────────────────────────────────┐
│ ₦85,000           ↑ 23%       │  ← Revenue Hero (always, 80px)
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ 🔍 Type a command or search...  │  ← Command Bar
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ DM          3m ago              │
│ Chioma Obi asked about ankara   │  ← Feed Item (DM)
│ [✨ Reply with AI draft →]      │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ SALE        15m ago             │
│ Blessing Eze paid ₦12,000       │  ← Feed Item (SALE)
│ [📦 Mark shipped]               │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ CONTENT     1h ago              │
│ AI drafted 3 new product posts  │  ← Feed Item (CONTENT)
│ [📝 Review drafts →]             │
└────────────────────────────────────┘
```

#### Manual Reply Detection

| Platform | Detection Method | Latency |
| ---------- | ----------------- | :-------: |
| Instagram | Graph API polling | 30-60s |
| WhatsApp | Business API webhooks | 1-3s |

When manual reply detected:

1. AI draft action button → **removed** (not grayed)
2. ✓ "Replied" badge appears
3. Item fades to 60% opacity, slides down in feed
4. Auto-collapses into "Completed" group after 30 minutes

Edge case: Seller starts typing in MarketBoss but sends from Instagram directly → "You already replied from Instagram. Discard draft?" dialog with [Discard] [Keep editing] options.

#### Feed Item State Machine

##### DM Feed Item States (9 states)

| State | Visual | Opacity | Actions |
| ------- | -------- | :-------: | -------- |
| NEW_MESSAGE | Blue "DM" badge | 100% | None (AI generating) |
| DRAFT_READY | ✨ sparkle indicator | 100% | [✨ Reply with AI draft →] |
| EDITING | Expanded inline editor | 100% | [Cancel] [Send ➤] |
| REGEN_REQ | Shimmer loader | 100% | [Cancel] |
| SENDING | Spinner | 100% | None |
| SENT | Green ✓ "Sent" | 80% | [Undo 3s] |
| MANUAL_REPLIED | Gray ✓ "Replied" | 60% | None |
| DISMISSED | Slide-out animation | 0% | None (instant removal) |
| COMPLETED | Collapsed group | 50% | [Expand] |

##### Key transitions

- DRAFT_READY → EDITING: user taps inline edit
- DRAFT_READY → DISMISSED: user swipes left or taps ✕
- DRAFT_READY → MANUAL_REPLIED: API detects manual reply
- DRAFT_READY → REGEN_REQ: user taps 🔄 or switches tone chip
- SENT → COMPLETED: 30 minutes elapse
- DISMISSED → removed: immediate, no undo
- SENT → undo: 3-second window only

##### Non-DM Feed Types

| Type | Badge Color | Primary Action |
| ------ | :-----------: | --------------- |
| SALE | Green | [📦 Mark shipped] |
| CONTENT | Gold | [Post Now →] [Edit] [Dismiss] |
| FOLLOW-UP | Purple | [Send reminder →] [Skip] |
| PAYMENT | Green | [Confirm] |

#### Command Bar

**"Spotlight for your business"** — dual-mode interface:

| Mode | Trigger | Examples |
| ------ | --------- | ---------- |
| Search | Raw text | `chioma` → filter feed to her items |
| Command | `/` prefix | `/reply chioma` → jump to DM compose |
| Command | `/` prefix | `/stats` → expand revenue panel |
| Command | `/` prefix | `/post` → content creation |
| Command | `/` prefix | `/earnings week` → weekly revenue |

**Smart autocomplete:** Fuzzy matching ("chi" → "Chioma Obi (1 pending DM)"). Top 3 contextual suggestions.

**Quick action chips** (shown when bar is focused): `[👤 Customers]` `[📦 Products]` `[📊 Stats]`

#### Revenue Stats — 3-Tier System

| Tier | Visibility | Content | Max Height |
| :----: | ----------- | --------- | :----------: |
| 1 | Always | Hero ₦ amount + change indicator | 80px |
| 2 | Tap to expand | 3-stat row (Sales, Leads, Close Rate) + time toggle | 140px |
| 3 | Analytics page | Full charts, exports, period comparisons | Full page |

> Rule: Never more than 18% of viewport for stats. Feed content always dominates.

#### Draft Management UX

**Inline expansion** (tap action → card expands in-feed, no navigation):

```text
┌─────────────────────────────────────┐
│ DM  ← Chioma Obi                   │
│                                     │
│ Customer:                           │
│ "How much for the blue ankara? 💙"  │
│                                     │
│ ┌ AI Draft ────────────────────┐  │
│ │ Hi Chioma! The blue ankara     │  │
│ │ na ₦8,500 😊 E dey available.  │  │
│ └──────────────────────────────┘  │
│                                     │
│ ⭐⭐⭐⭐⭐ Sounds Like Me              │
│ [Friendly] [Pidgin] [Formal]        │
│                                     │
│ [🔄 New Draft] [✏️ Edit] [➤ Send]   │
│ [✕ Dismiss]                         │
└─────────────────────────────────────┘
```

##### Tone chips

| Chip | Effect | Example |
| ------ | -------- | -------- |
| Friendly | Casual, emoji-rich | "Hi Chioma! 😊 The ankara na ₦8,500" |
| Pidgin | Nigerian Pidgin | "How far Chioma! Dat ankara na ₦8,500 o!" |
| Formal | Professional | "Hello Chioma, thank you for your inquiry. The dress is ₦8,500." |

- Default tone: learned from seller's past message style (AI training)
- Switching tone chip triggers regeneration (counts toward limit)

**Regeneration limit:** 3 drafts per DM (counter visible: "Draft 2/3"). After 3 → manual compose only.

**Dismiss flow:** Confirmation dialog ("Dismiss this AI reply?"), no undo. Future messages from same customer get fresh drafts.

##### Animation durations

| Action | Animation | Duration |
| -------- | ----------- | :--------: |
| Expand to draft | Height grows, content fades in | 250ms |
| Collapse (cancel) | Shrinks, fades out | 200ms |
| Send | Spinner → ✓, slides down | 300ms + 200ms |
| Dismiss | Slides left, opacity → 0 | 250ms |
| Regenerate | Fade → shimmer → new text | 200ms + spinner + 200ms |
| Tone change | Crossfade to new draft | 300ms |
