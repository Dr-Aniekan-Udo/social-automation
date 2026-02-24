# Executive Summary

### Project Vision

MarketBoss is an AI-powered social commerce platform purpose-built for Nigerian micro-SMB sellers (₦100K–350K/month revenue, 200–5,000 followers). It solves the "conversation-to-cash" loop — the exhausting daily grind of creating content, answering DMs, tracking payments, and growing an audience across Instagram and WhatsApp.

The product is not a scheduling tool, analytics dashboard, or template gallery. It is the first platform to integrate AI Brand Voice content generation + payment links + cross-platform attribution + negotiation handoff into a single workflow — designed from first principles for the Nigerian market context.

**Core UX Vision:** A task-first, mobile-native experience that feels like a superpower layer on top of the social platforms sellers already use — not a replacement for them.

### Target Users

#### Amaka — Fashion Designer (IG-First Archetype)

- **Context:** 3,200 IG followers, ₦200–350K/month, 2+ hrs/day writing captions
- **Primary Pain:** 23 unanswered DMs losing ₦40K+ weekly; content creation takes longer than selling
- **UX Need:** Revenue as the hero metric ("Show me the money, not the likes"). If the AI can't sound like her after 3 regeneration tries, she'll leave
- **Key Insight:** The "Regenerate" flow is make-or-break for Brand Voice trust

#### Chinedu — Phone Accessories (WhatsApp-First Archetype)

- **Context:** 89 WhatsApp contacts, Computer Village market, thinks in product-and-price
- **Primary Pain:** Bulk broadcasting chaos, pricing conflicts across contacts, no tracking
- **UX Need:** Speed over beauty. A big "SEND PRICE LIST" button, not an AI caption generator
- **Key Insight:** He doesn't write captions — he writes "iPhone 15 case ₦4,500." The "paste 5 captions" onboarding is a barrier; he needs "paste 5 product listings" or voice-record his selling style

#### Tunde — Artist/Painter (Low-Frequency Archetype)

- **Context:** 890 followers, feast-or-famine income, 2–3 week commission cycles
- **Primary Pain:** Skeptical of AI for creative work; long sales cycles don't fit "post daily" advice
- **UX Need:** Commission pipeline stages (deposit → progress → final), not just inquiry → sale. Growth Assist must understand that art accounts work differently than retail — no daily nudges
- **Key Insight:** One-size-fits-all engagement prompts feel patronizing to low-frequency posters

#### Blessing — Food Vendor (Trust-Broken Archetype)

- **Context:** TikTok + IG, Pidgin-speaking, previously had AI "spoil" her voice/engagement
- **Primary Pain:** Burned by AI before — any UX friction triggers "this is happening again" panic
- **UX Need:** Voice-first UX is critical (voice note input, audio preview of captions). "Sounds Like Me" score must be persistent and prominent — not hidden in settings
- **Key Insight:** She wants to HEAR the caption read aloud before posting. Audio preview is an accessibility need, not a feature

#### Emeka — Team Member (Delegated Access Archetype)

- **Context:** 19-year-old "sales boy" managing boss's account with limited permissions
- **Primary Pain:** Confused by features he can't use; wants recognition for work done
- **UX Need:** A completely separate, purpose-built team UI — not a reduced version of the full app. Two tabs: Inquiries + Drafts. Performance recognition: "You handled 11 inquiries today!"
- **Key Insight:** Showing buttons that can't be clicked erodes trust and creates confusion

### Core Design Principles

Derived from first principles analysis — stripping away every assumption about "how social commerce tools should look."

| # | Principle | Rule |
| --- | ----------- | ------ |
| **P1** | 🎯 One Thing at a Time | Every screen has ONE primary action. No cognitive overload or split attention |
| **P2** | ⚡ Text Before Image | Content loads progressively. Text renders first, images lazy-load. Optimized for 3G |
| **P3** | 💰 Show Me the Money | Revenue is the hero metric everywhere. Engagement is secondary context |
| **P4** | 🤝 Feel Familiar | Borrow WhatsApp and Instagram interaction patterns aggressively |
| **P5** | 🧑‍🤝‍🧑 Human + AI, Never AI Alone | Every AI output has a visible, intentional human approval step |
| **P6** | 3️⃣ 3-Tap Maximum | Any critical action reachable in ≤ 3 taps from any screen |
| **P7** | 📡 Offline-Tolerant | Queue actions, sync when connected, never lose work. Always show sync status |

### Key Design Challenges

#### 1. The Trust Tightrope

Users are terrified of AI "spoiling their business." Every design decision must answer: "Do I feel in control?" The AI must never feel like it's running away from the seller.

**Pre-mortem validated risk — "Brand Voice Betrayal":** Users who approve AI posts too quickly (because the approval flow is too frictionless) end up posting content that doesn't match their voice. Followers notice, engagement drops, users blame MarketBoss.

**Prevention:** A "This sounds like me" rating step (not a checkbox) before every post. If seller rates < 3/5, prompt to regenerate or edit instead of allowing publish.

#### 2. Divergent Pipeline Experiences

Instagram sellers (visual, content-focused) and WhatsApp sellers (text-heavy, transactional) need fundamentally different UX priorities within the same app. Chinedu's broadcast-and-negotiate world is nothing like Amaka's post-and-attract world.

**Prevention:** Divergent home screens and onboarding flows based on primary pipeline choice at signup.

#### 3. Onboarding Completion vs. Speed

Brand Voice needs 5+ captions, social account connection, KYC — but SMB tool onboarding completion is typically 30–50%. Every extra step is a dropout risk.

**Pre-mortem validated risk — "Onboarding Graveyard":** 65% of signups never complete onboarding when it feels like applying for a bank loan.

**Prevention:** 3 visible steps maximum. Step 1: Connect IG/WhatsApp. Step 2: Paste captions/listings or voice-record. Step 3: Generate first post. KYC deferred until first sales cap. Progressive disclosure for everything else.

#### 4. Dashboard Engagement Trap

Users who set AI to handle everything stop engaging with their community, and their reach tanks. But also: users open the app to post and close it, ignoring analytics and growth tools.

**Pre-mortem validated risk — "The Dashboard Nobody Uses":** Charts and graphs lose to a task-first "What needs your attention?" paradigm.

**Prevention:** Task-first home screen showing unresponded DMs, drafts awaiting approval, payments received — not charts. Growth Assist nudges must be context-aware by account type.

#### 5. Payment Link Cultural Distrust

Nigerian buyers trust account-number transfers. Random payment links feel scammy.

**Pre-mortem validated risk — "Payment Link Distrust":** Customers say "Send me your account number" instead of clicking the link.

**Prevention:** Payment receipt page shows seller's face, business name, product photo, and verification badge prominently. Culturally calibrate trust signals.

#### 6. Notification Fatigue

Growth Assist nudges + billing reminders + DM alerts all blurring together causes users to mute all notifications.

**Prevention:** 3-tier notification hierarchy — 🔴 Urgent (new DM, payment received), 🟡 Informational (engagement prompt), ⚪ Optional (tips, feature announcements). Each tier independently controllable. Additionally, consider a **Morning Briefing** pull model: one daily summary ("3 new DMs, ₦12,000 received overnight, 1 post ready for approval") replaces scattered push notifications.

### Design Opportunities

#### 1. Result-First Onboarding ("First Post in 10 Minutes")

**SCAMPER-enhanced (Reverse):** Flip the onboarding — show the result BEFORE the setup. Step 1: "What do you sell?" → AI generates a sample post *immediately* (generic voice). Step 2: "Does this look like something you'd post?" → start tuning voice. Step 3: "Want to actually post this? Connect your Instagram." Sellers see the value before they pay the effort cost. Divergent paths: IG-first sellers see a post; WhatsApp-first sellers see a price broadcast.

#### 2. The "Sounds Like Me" Regeneration Loop

Making AI content editing feel like a conversation ("Too formal." → regenerated → "More emoji." → regenerated → "Perfect!") builds trust through a delightful micro-interaction. Audio preview option lets sellers HEAR their content before posting. **SCAMPER-enhanced (Modify):** Upgrade the binary approve/reject to a 1–5 slider. At 4–5, publish is enabled. At 1–3, AI auto-regenerates with adjustments. At 2 or below, it suggests the seller write their own with real-time AI assist — turning a checkpoint into a teaching moment for the AI.

#### 3. WhatsApp Superpower Layer

Instead of cloning WhatsApp's inbox, add visible value ON TOP: customer summary cards, price tier badges, purchase history ("this customer bought 3x before"), and negotiation context. Make sellers feel like they have x-ray vision.

#### 4. Revenue-First Confidence Dashboard

Instead of chart-heavy analytics, a narrative "Your business is doing better since MarketBoss" — pre vs. post baseline comparison, styled like a report card. Emotional ROI, not just numbers.

#### 5. Conversation Priming Cards

When a DM arrives, show a quick context card: "This customer commented PRICE on your ankara post, follows 3 of your competitors, last purchased 2 weeks ago." Humans + AI become individually more powerful.

#### 6. Voice-First Content Creation

**SCAMPER-derived (Substitute):** Replace the text editor as primary input with voice. Sellers speak: "Write a caption for my new ankara collection, make it playful, mention ₦8,500" → AI generates from speech → seller listens to audio preview → taps approve. Critical for Blessing (Pidgin-speaking, trust-broken) and Chinedu (speed-first). Voice input is an accessibility breakthrough, not a feature.

#### 7. Brand Voice for DM Replies

**SCAMPER-derived (Put to Other Uses):** Extend Brand Voice from content creation into DM responses. Customer asks "How much for the bag?" → AI drafts in seller's voice: "Fine babe! That bag na ₦6,500. I fit arrange delivery for you today o 😊" → seller taps send or edits. The voice engine becomes a sales assistant, not just a content tool.

#### 8. No Dashboard MVP (Contextual Metrics)

**SCAMPER-derived (Eliminate):** Kill the analytics dashboard for MVP. Weave metrics into context: post performance appears ON the post in the content feed, revenue on the home screen hero card, pipeline stats in the inbox header. If sellers never click "Analytics" (pre-mortem validated), don't build it.

#### 9. Post Creation = Pipeline Setup

**SCAMPER-derived (Combine):** Creating a post automatically creates a lead capture funnel. Post ankara dress → AI generates caption with payment link → customer DMs "PRICE" → lead card auto-created with post context attached. Sellers never leave content creation to set up sales tracking — posting IS pipeline setup.

### UX Friction Scenarios (Customer Support Theater)

Critical friction points identified through support scenario roleplay:

| Scenario | Root Cause | UX Fix |
| ---------- | ----------- | -------- |
| **Wrong price on scheduled post** | Price pulled at schedule-time, not publish-time; catalog updated after scheduling | Flag ALL scheduled posts when a product price changes. One-tap update flow |
| **"Can't connect Instagram"** | User has Personal account, doesn't know Business is required | Detect account type BEFORE OAuth; redirect to 60-second video tutorial if personal |
| **Team member deletes posts accidentally** | "Pause" and "Delete" buttons adjacent in team UI | Destructive actions require confirmation; visually separate from safe actions; 24-hour undo bin |
| **Reach drops unnoticed** | Protection alert only fires in-app at Day 14 | Multi-channel alerts (WhatsApp + SMS) at Day 7; non-dismissable until acknowledged |

### SCAMPER Innovation Catalog

Complete creative analysis — 14 insights across 7 lenses, prioritized by implementation phase:

#### 🔴 MVP Priority (High Impact)

| Lens | Insight | Rationale |
| ------ | --------- | ---------- |
| **Substitute** | Voice-first content creation | Accessibility + trust breakthrough for non-typists and Pidgin speakers |
| **Combine** | Post creation = automatic pipeline setup | Eliminates workflow friction between content and sales |
| **Modify** | Approval slider (1–5) instead of binary approve/reject | Trains AI through feedback AND builds seller trust |
| **Put to Use** | Brand Voice for DM replies | Core value expansion — voice engine as sales assistant |
| **Eliminate** | Kill analytics dashboard, use contextual metrics | Focus + dev cost reduction; validated by pre-mortem |
| **Reverse** | Result-first onboarding (show AI post BEFORE setup) | Conversion breakthrough — value before effort |

#### 🟡 Growth Phase (Medium Impact)

| Lens | Insight | Rationale |
| ------ | --------- | ---------- |
| **Substitute** | Camera-snap product inventory | Onboarding speed — photo + voice price vs. form-filling |
| **Combine** | Growth Assist merged into conversation context | Actionable advice in DM sidebar, not abstract tips |
| **Adapt** | Posting streaks (Duolingo mechanic) | Retention gamification — consistency drives reach |
| **Adapt** | Real-time follower activity signals (Uber surge) | Posting optimization — urgency-driven engagement |
| **Eliminate** | Replace calendar with future post feed | Familiarity — sellers understand feeds, not calendars |
| **Reverse** | Morning Briefing (pull) instead of push notifications | Notification fatigue fix — one daily ritual |

#### 🟢 Scale Phase (Deepening)

| Lens | Insight | Rationale |
| ------ | --------- | ---------- |
| **Magnify** | Brand Voice Health Dashboard (identity mirror) | Trust deepening — sellers see and tune their voice |
| **Put to Use** | Analytics as voice-note coaching | Engagement — turn data into weekly spoken advice |
