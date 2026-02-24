# Core User Experience Discovery Notes

### Defining Experience (Discovery)

**Core Loop:** Content Creation → Lead Capture → Conversational Selling → Payment

The atomic interaction that defines MarketBoss is the full arc from content to cash — every post is a lead-generation device, every DM is a selling conversation, and the AI's job is to make the human seller *faster*, not *absent*.

**The Critical Interaction:** A DM arrives → the seller sees a context card (customer name, comment/DM history, purchase history through our platform) → drafts a warm, personalized reply in their Brand Voice → closes the sale. This is the "x-ray vision" moment. If this feels magical, everything else earns forgiveness.

**The 30-Second Action:** Quick-approve and publish an AI-generated post. Open app → see draft awaiting approval → listen to audio preview or read → rate "Sounds Like Me" (4/5) → tap publish. Under 30 seconds, one-handed, on a bus.

**The Non-Obvious Insight:** The first reply to a customer is NEVER a payment link. It's conversational — "Fine babe! That bag na ₦6,500 😊" — because Nigerian commerce is relationship-first. The payment link comes AFTER rapport.

#### Conversation Stage Model

AI must track where each customer conversation is and only surface payment links at the Commitment stage:

| Stage | Customer Signal | AI Behavior |
| ------- | ---------------- | ------------ |
| **Inquiry** | "How much?" / "Is this available?" | Draft reply with price + product info |
| **Interest** | "Do you have size L?" / "What colors?" | Draft reply with availability/options |
| **Negotiation** | "Can you do ₦7,000?" | Flag for seller judgment — no AI draft |
| **Commitment** | "I want it" / "Send your details" | NOW surface the payment link in the draft |
| **Payment** | Link clicked / transfer made | Auto-generate receipt + delivery flow |

#### Smart Notifications — The #1 UX Priority

Discovery through Reverse Engineering: **the notification IS the experience.** If the notification says *"New message from chioma_styles"* (generic), the seller opens Instagram, not MarketBoss. The notification must say:

> *"Chioma asked about your ankara dress (₦8,500) — reply ready 💬"*

This requires:

- Comment/DM webhook → product catalog matcher (NLP: "how much" + post context → product ID)
- Revenue-prioritized notification sorting (₦8,500 inquiry surfaces above "nice 😍" comments)
- Smart notification copy that includes product name + price
- Deep-link directly to the DM thread with AI draft pre-loaded

### Platform Strategy

**Primary Platform:** Mobile-first PWA (Progressive Web App)

- 320px minimum supported viewport (optimized for 360px+), ₦500KB initial payload budget
- Touch-first interaction design
- Android 8+ / Chrome 90+ (dominant in target market)
- No native app for MVP — PWA with home-screen install prompt (avoids App Store review delays + 30% revenue share)

##### Divergent Experience Architecture

Divergence = **emphasis, not exclusion.** IG-first sellers see WhatsApp tools in secondary position (not hidden); WhatsApp-first sellers see content tools as secondary. Full feature set always accessible — like YouTube's "Shorts" vs "Videos" tabs.

| Aspect | IG-First Surface | WhatsApp-First Surface |
| -------- | ----------------- | ---------------------- |
| **Onboarding** | Caption pasting, visual content creation | Product listings, broadcast groups, pricing |
| **Home screen** | Content feed + Revenue card | Messages + Revenue card |
| **Primary action** | "Create Post" prominent | "Send Broadcast" prominent |
| **Dual-channel users** | Unified feed with channel badges (📸/💬), "Post where?" toggle |

Detected at signup ("What's your primary selling channel?") with "Both" option. First-time experience guided through ONE channel to reduce cognitive load.

##### Offline Tolerance

- Post scheduling, draft editing, catalog management work offline
- Publish queued locally → instant "Scheduled ✅" → API call on reconnect → retry with error + manual button. NEVER a spinner that might time out
- DM responses require connectivity but show cached conversation history

##### Management Screens (not Dashboard)

We eliminated the analytics dashboard — NOT management. These utilitarian screens live in the Profile/Settings tab (not a hamburger menu), not the home screen:

- Product Catalog (list / add / edit / camera-snap)
- Scheduled Posts (list / edit / cancel)
- Team Members (invite / permissions)

### Effortless Interactions

##### Zero-Thought Actions

| Action | Target Effort | How |
| -------- | -------------- | ----- |
| Publishing a post | 2 taps (rate + publish) | AI draft already waiting; no navigation needed |
| Replying to a DM | 1 tap (send) or edit + send | Brand Voice draft pre-loaded with context card |
| Adding a product | Camera snap + voice price | Photo + "ankara dress, ₦8,500" → done |
| Checking revenue | 0 taps (visible on home screen) | Hero card auto-updates: "₦47,500 this week" |
| Understanding a customer | 0 taps (priming card on DM open) | Context card auto-surfaces from cached data |
| Mass-triaging broadcast replies | Sort + template | Sort by product/price tier/urgency; quick-reply templates for common questions |

##### Competitor Friction We Eliminate

- **Buffer/Hootsuite:** Require desktop scheduling → we allow one-hand mobile publish
- **Manual DMs:** Seller has no customer context → we surface relationship history
- **WhatsApp Business:** No AI voice, no cross-platform attribution → we add Brand Voice + unified pipeline
- **ChatGPT + Paystack:** No integration between them → we connect content → leads → conversation → payment into one flow

#### Priming Card Specification

Scoped to reliable, technically feasible data only:

| Data Point | Source | Load Strategy |
| ----------- | -------- | --------------- |
| Customer name | Comment/DM metadata | Cached (instant) |
| Last action | "Commented 'PRICE' on ankara post" | Cached (instant) |
| DM/comment history | MarketBoss conversation log | Cached (instant) |
| Purchase history | MarketBoss payment records | Lazy-loaded |
| Data confidence | Source count | "Based on 3 past orders" |

Cards are dismissable and configurable (show/hide per seller preference). "Flag as wrong" action available for data correction.

**NOT included in MVP:** Competitor follower analysis (infeasible with Meta API restrictions).

### Critical Success Moments

##### 🟢 Make-or-Break Moments (priority order)

1. **"That's EXACTLY how I'd say this!"** — First AI-generated content that matches seller's voice. Brand Voice engine must hit 4/5 average within the first week or the UX promise collapses. If average drops below 3/5, trigger "Let's retrain your voice" flow.

2. **"I closed a sale in 30 seconds."** — First DM with priming card where seller has x-ray vision. They feel powerful, not overwhelmed. MarketBoss stops being a tool and becomes an unfair advantage.

3. **"I made money while I slept."** — First "₦6,500 received" notification from AI-scheduled content + payment links. Passive income from the core loop.

4. **"My boy Emeka handled 11 DMs without me."** — First confident delegation day. Relief, not anxiety.

5. **"My followers went UP."** — First weekly report showing reach increased. The anti-Blessing moment.

##### 🔴 Failure Moments (must NEVER happen)

- "That doesn't sound like me" → Posted anyway → Followers notice → CHURN
- "I can't find my revenue" → Dashboard-first UI → Analytics ignored → CHURN
- "It posted without asking me" → Auto-post without approval → Loss of control → CHURN
- "My customer didn't trust the link" → Generic receipt page → "Send account number" → LOST SALE

### Experience Principles

Building on P1–P7 from discovery, these interaction design principles guide all UX decisions:

| # | Principle | Application |
| --- | ----------- | ------------ |
| **E1** | 🎣 Content is Bait, Conversation is the Catch | Every post optimized to generate DMs. UX prioritizes DM response flow over post vanity metrics |
| **E2** | 🗣️ Relationship Before Transaction | First reply is ALWAYS conversational. Payment link only at Commitment stage. AI respects cultural cadence |
| **E3** | 👁️ X-Ray Vision, Not Automation | AI gives sellers CONTEXT (priming cards), not auto-replies. Humans + AI > AI alone |
| **E4** | ⚡ Instant Gratification, Deferred Complexity | Show value immediately (result-first onboarding, revenue hero card). Defer KYC, analytics, advanced features |
| **E5** | 🔀 One Product, Two Surfaces | IG-first and WhatsApp-first experiences are equally polished. Divergence in emphasis, not exclusion |
| **E6** | 📲 The Notification IS the Experience | Smart notifications pull sellers into MarketBoss, not native apps. Product-aware, revenue-prioritized |
| **E7** | 🤯 "This is What ChatGPT Can't Do" | The integration (voice + content + leads + conversation + payment) must be immediately obvious in the UX |
