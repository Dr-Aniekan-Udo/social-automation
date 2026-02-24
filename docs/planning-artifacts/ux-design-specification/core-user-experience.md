# Core User Experience

### Defining Experience

> **"See a customer message → send a perfect reply → close the sale"** — in 3 taps and under 10 seconds.

The interaction Amaka describes to friends: *"My phone buzzes, I see who's asking, the reply is already written in my voice, I tap send, and the money enters. That's it."*

The defining experience is the **DM Close** — the moment where relationship becomes revenue. Content creation is the bait. Analytics is the mirror. The DM Close is the money.

### User Mental Model

##### How sellers currently solve this

| Step | Current (6 apps, 12+ steps) | MarketBoss (1 app, 3 taps) |
| ------ | ---------------------------- | --------------------------- |
| Notice DM | Check WA + IG separately (2 min) | Smart notification with product + price |
| Identify customer | Scroll history, try to remember (1-3 min) | PrimingCard: name, history, revenue |
| Check product/price | Open Notes or recall (30s-2 min) | AI draft includes correct price from catalog |
| Type response | Hunt-and-peck, inconsistent (2-5 min) | AI draft in Brand Voice, 2-3 lines |
| Share payment | Type bank details manually (1-2 min) | One-tap 📎💳 payment link embed |
| Confirm payment | Switch to OPay/bank app (2-5 min) | In-app receipt: "₦8,500 received 🎉" |
| **TOTAL** | **8-18 min per DM** | **6-10 seconds** |

**Mental model:** Sellers think in conversations, not workflows. Their model is: "Someone asks → I answer → they pay → I deliver." MarketBoss matches this conversational model — it feels like replying to WhatsApp, but with superpowers.

### Success Criteria

| Criterion | Metric | Why It Matters |
| ---------- | -------- | --------------- |
| Speed | DM reply in <10 seconds | Faster than competitors. Customer still engaged |
| Accuracy | Correct price, right product, matching voice | No embarrassing corrections needed |
| Completeness | Reply includes payment path | Customer doesn't ask "how do I pay?" |
| Recognition | Returning customer feels remembered | Loyalty → repeat purchase |
| Confidence | Seller feels "I nailed that" | Powers repeat usage |

##### User says "this just works" when

1. They don't have to think — PrimingCard pre-answered all questions
2. The reply sounds like them — not generic, not robotic
3. Payment is 1 tap — no typing account numbers
4. They see money arrive — instant confirmation in same conversation
5. It took less time than typing "OK, the price is..."

### Novel vs. Established Patterns

| Element | Type | Teaching Strategy |
| --------- | :----: | ------------------ |
| Chat interface | Established | WhatsApp-native. Zero learning curve |
| AI-drafted replies | **Novel** | "Like auto-correct — it's already there, you just adjust." First time: side-by-side (AI draft vs blank) |
| PrimingCard (context overlay) | **Novel** | "Like caller ID — see who's calling before you answer." Animate slide-down with label |
| "Sounds Like Me" rating | **Novel** | "Like Spotify learning your taste." After 10 ratings, show improvement chart |
| Payment link embed | Established | WhatsApp Business + Paystack patterns |
| Receipt confirmation | Established | OPay pattern. Instantly familiar |

**Innovation strategy:** Combine familiar patterns (chat + payment) in innovative ways (AI + context cards), using established metaphors (caller ID, auto-correct, music taste) to teach novel concepts.

### Experience Mechanics

#### Phase 1: Smart Notification (0-2s)

```text
┌──────────────────────────┐
│ 🔥 MarketBoss            │
│ Chioma asked about       │
│ ankara dress (₦8,500)    │
│ [Reply Now]              │
└──────────────────────────┘
```

Not "new message" but "Chioma asked about ankara (₦8,500)." Revenue potential on lock screen. Single tap → DM thread with priming.

#### Phase 2: PrimingCard (2-4s)

```text
┌──────────────────────────┐
│ 🔥 HOT LEAD              │
│ ┌──────────────────────┐ │
│ │ Chioma Obi            │ │
│ │ 🛒 ankara dress       │ │
│ │ 💰 ₦8,500 (in stock)  │ │
│ │ 📊 2 prev orders      │ │
│ │ ⏱️ Usually buys fast   │ │
│ │          [✕ dismiss]  │ │
│ └──────────────────────┘ │
└──────────────────────────┘
```

Slides down (300ms ease-out). Shows name, product, price, stock, history, behavioral hint. Auto-fades 3s or tap ✕. **Zero cognitive load** — information only, no decisions.

#### Phase 3: AI Draft Review (4-8s)

```text
┌──────────────────────────┐
│ ┌──────────────────────┐ │
│ │ Hi Chioma! The blue  │ │
│ │ ankara na ₦8,500 😊  │ │
│ │ E dey available.     │ │
│ │                      │ │
│ │ ⭐⭐⭐⭐⭐ Sounds Like Me │ │
│ │ [✏️ Edit] [➤ Send]   │ │
│ └──────────────────────┘ │
│ [+ emoji/product/photo]  │
└──────────────────────────┘
```

AI draft **pre-generated when DM arrived** (not when user opens — saves 1-3s). Brand Voice, correct price, 2-3 lines max. Rating optional and collapsible after trust builds.

#### Phase 4: Payment Attachment (conditional, +3s)

Only when AI detects buying intent ("I want to buy" / "Send account"):

```text
┌──────────────────────────┐
│ AI: Great choice Chioma! │
│ ┌──────────────────────┐ │
│ │ 💳 PAY ₦8,500        │ │
│ │ Ankara Dress (Blue)  │ │
│ │ [Pay with Paystack]  │ │
│ └──────────────────────┘ │
│ [✏️ Edit] [📎💳] [➤ Send]│
└──────────────────────────┘
```

Payment embedded IN the message. No "let me send my account number."

#### Phase 5: Completion (instant)

```text
┌──────────────────────────┐
│ ✅ PAYMENT RECEIVED       │
│ ₦8,500 from Chioma Obi  │
│ Ankara Dress (Blue)      │
│ 12:34 PM • Feb 19, 2026  │
│ [📦 Mark Delivered]      │
│ [💬 Thank Customer]      │
└──────────────────────────┘
```

OPay-style receipt. "Thank Customer" → AI-drafted gratitude in Brand Voice.

### Flow Branches

| Branch | % of DMs | Time | Key Mechanic |
| -------- | :--------: | :----: | ------------- |
| **Happy path** (ask → reply → buy) | 60% | 6-10s | Standard flow ✅ |
| **Edit path** (draft needs tweaking) | 20% | 15-30s | Inline edit, cursor at end, keyboard auto-opens |
| **Multi-message** (conversation) | 10% | 2-10 min | Conversation stage: 💬 → 🤔 → 💳 → 🎉 |
| **Objection** ("too expensive") | 5% | 30-60s | Discount policy engine: AI negotiates within seller's rules |
| **Abandon** (customer ghosts) | 5% | 24h+ | Follow-up reminder with AI draft after 24h |
| **Support** (complaint/refund) | Rare | varies | Orange PrimingCard, empathetic tone, no payment prompts |
| **Catalog browse** ("What do you have?") | Rare | varies | One-tap catalog share: [📋 Send Catalog] |

### Edge Case Handling

| Edge Case | MarketBoss Response |
| ----------- | -------------------- |
| Out of stock | AI suggests alternatives + restock ETA |
| AI draft wrong tone | Edit → after 3 low ratings, trigger "Quick tune: rate 3 captions" |
| Payment fails | Specific error: "Ask Chioma to try again" (not generic) |
| Ambiguous product | "Which bag?" — catalog quick-picker disambiguation |
| Customer voice note | "🎤 Voice message. Tap to listen." Manual compose (MVP) |
| Multiple products asked | AI bundles: "Bag ₦12K, shoes ₦8K. Together ₦18K 😊" |
| Follow-up DM | PrimingCard shows order status. AI updates customer |
| No catalog products | Guard: "Add first product to unlock AI replies! [📸 Add]" |
| Team high-value DM | "Send to Boss" approval button + oversight dashboard |

### Upsell & Cross-sell Intelligence

AI detects opportunities from catalog + customer history:

- Customer bought ankara → AI suggests matching lace
- Customer browses 3 products → AI offers bundle price
- Returning customer → AI references past purchase: "You loved the blue — this red one just arrived!"

### Performance Optimization

| Optimization | Impact |
| ------------- | -------- |
| Pre-generate drafts on DM arrival | -1-3s (draft ready before user opens) |
| Pre-fetch customer data with notification | -200-500ms (PrimingCard instant) |
| Deep link from notification to DM | -500ms (skip home screen) |
| Cap drafts at 2-3 lines | -1-2s reading time |
| Optimistic send | -100ms (show ✓ immediately) |
| Service worker cache DM shell | -200ms (instant app open) |

### Progressive Cognitive Reduction

| Stage | User Experience | Decisions |
| ------- | ---------------- | :---------: |
| Week 1 (new) | All decisions visible. Rating prominent. Edit accessible | 6 |
| Month 1 (learning) | Rating collapses (AI trusted). Drafts auto-fill better | 4 |
| Month 3 (expert) | One-tap send from notification. Priming not needed | 2 |
| Month 6 (power) | "Auto-reply for orders under ₦5,000" toggle | 1 |
