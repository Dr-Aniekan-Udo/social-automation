# Functional Requirements

*Enhanced via Advanced Elicitation: User Persona Focus Group, Failure Mode Analysis, SCAMPER, Self-Consistency Validation*

> **Capability Contract:** This FR list is binding for all downstream work. UX designers will ONLY design what's listed here. Architects will ONLY support what's listed here. Epic breakdown will ONLY implement what's listed here. If a capability is missing from this section, it will NOT exist in the final product.

### Seller Onboarding & Identity

- FR1: Seller can sign up using email and phone with OTP verification
- FR2: Seller can choose a primary social platform (Instagram or WhatsApp) during onboarding
- FR3: Seller can complete Brand Voice Onboarding by submitting minimum 5 brand-voice training inputs (captions, product listings, or voice samples); seller is never dropped from onboarding, but AI post generation is blocked until the minimum input threshold is met
- FR4: System captures the seller's pre-MarketBoss baseline metrics (reach, engagement, follower count) at signup
- FR5: Seller can complete low-friction onboarding verification at signup; enhanced KYC is deferred and required for payment features and higher transaction limits
- FR6: Seller can select their product category during onboarding, with prohibited categories blocked
- FR7: Sellers in regulated categories (food, cosmetics) can upload required certifications for verification before first sale
- FR8: System detects incomplete onboarding (insufficient brand-voice training input or incomplete Business Profile) and shows a persistent prompt to complete it; post generation remains blocked until requirements are met
- FR9: Seller can connect their Instagram Business account to the platform
- FR10: Seller can connect their WhatsApp Business account to the platform
- FR11: System guides new sellers through first post creation step-by-step
- FR12: Seller completes a Business Profile Form during onboarding capturing: business name, description, product categories, pricing ranges, shipping policy (delivery areas, costs, timelines), return/refund policy, accepted payment methods, operating hours, physical location (if applicable), contact channels, and common FAQs
- FR13: System ingests product information from connected social platforms (Instagram product tags, WhatsApp catalog) and pre-fills Business Profile fields where possible
- FR14: Seller fills a minimal per-product quick form when creating a post (product name, price, key features, availability) to give AI sufficient context for generating responses to buyer inquiries
- FR15: AI analyzes the combined Business Profile + product data against a library of common buyer questions and displays an advisory gap indicator (e.g., "Your profile answers 12/18 common buyer questions — add shipping info to improve AI responses")
- FR16: Business Profile and per-product data feed into the RAG pipeline, enabling AI to answer buyer DMs and generate content with accurate, seller-specific information

### AI Content Creation

- FR17: Seller can generate AI-powered captions calibrated to their Brand Voice profile
- FR18: Seller can regenerate AI content with feedback to improve results
- FR19: Seller can edit AI-generated content before publishing
- FR20: System generates captions with embedded payment link calls-to-action
- FR21: System performs cross-tenant uniqueness checking to prevent niche collision between sellers in the same category
- FR22: System varies AI content patterns to resist AI detection by followers
- FR23: Seller can generate content in batch for multiple products
- FR24: System scores Brand Voice fidelity and warns when calibration data is insufficient
- FR25: Seller can recalibrate their Brand Voice profile with additional captions
- FR26: System generates contextually appropriate content for Nigerian market (including Pidgin English, local slang, cultural references)
- FR27: System learns from seller content corrections to improve future AI output
- FR28: System provides fallback content options (cached templates, manual mode) when AI is unavailable

### Social Channel Management

- FR29: Seller can publish single-image and carousel posts to Instagram
- FR30: Seller can schedule posts for AI-recommended optimal times
- FR31: Seller can view, reschedule, and cancel scheduled posts through a feed-native scheduled queue (MVP contextual surface), with full calendar views deferred to post-MVP/Growth
- FR32: Seller can view and respond to WhatsApp messages through a unified inbox
- FR33: Seller can send payment links via WhatsApp messages
- FR34: System detects rate limits and gracefully degrades (prioritizing live DMs over queued messages)
- FR35: Seller can configure business hours, with automated after-hours responses for incoming messages
- FR36: System prioritizes message delivery: live DMs > scheduled messages > bulk communications
- FR37: Seller can sync product catalog to WhatsApp Business
- FR38: Seller can preview and confirm messages before sending to segmented lists
- FR39: System detects social platform disconnection and guides seller through reconnection

### Sales & Payment Processing

- FR40: Seller can manage product catalog (add, edit, remove products with pricing and stock levels)
- FR41: Seller can upload and manage product media (photos/videos)
- FR42: Seller can generate payment links tied to specific customer inquiries
- FR43: Buyer receives a digital receipt with seller identity, product details, amount, and support contact after payment
- FR44: Verified sellers display a Verification Badge on receipts and payment links
- FR45: System generates and logs MarketBoss tracking URLs for seller bios and payment links
- FR46: Seller can track customer inquiries as lead cards with status progression
- FR47: Seller can manage multi-stage deals (e.g., deposit → work-in-progress → final payment)
- FR48: System tracks cross-platform customer journeys (e.g., IG post → WhatsApp DM → payment → delivery)
- FR49: System provides a fallback payment method (bank transfer details) when the primary payment provider is unavailable
- FR50: Seller can view a Content Performance Score showing engagement metrics per post
- FR51: Seller can view and manage active/expired payment links
- FR52: Seller can generate shareable product links for any channel
- FR53: Seller can share progress updates with customers during multi-stage deals
- FR54: Seller can view payout history and settlement reports

### Customer Engagement & Conversations

- FR55: Seller receives a customer summary card (conversation priming) when a new inquiry arrives
- FR56: Seller can take over automated conversations with a one-tap human handoff
- FR57: Seller can set up response templates for common inquiries
- FR58: Team members can use response templates set up by the account owner
- FR59: Seller can tag contacts with relationship types (e.g., regular, new, wholesale) and assign price tiers
- FR60: Seller can segment customer lists for targeted communications
- FR61: Buyer-initiated messages are never blocked, regardless of the seller's messaging limit
- FR62: System logs system-generated vs human-generated responses for clear attribution
- FR63: Buyer can initiate a dispute during escrow period

### Growth Insights & Analytics

- FR64: Seller can view contextual MVP analytics (post performance, engagement rate, follower growth) within feed/inbox/home surfaces; dedicated analytics dashboard is post-MVP/Growth
- FR65: System provides engagement prompts suggesting actions to increase reach
- FR66: System alerts the seller when their reach drops below their pre-MarketBoss baseline
- FR67: System shows sellers their progress compared to their pre-MarketBoss baseline
- FR68: System provides content strategy suggestions tailored to the seller's account type and niche
- FR69: Seller receives a warning when approaching their tier usage limits (at 80% threshold)
- FR70: Seller can view pending-task summaries (unresponded inquiries, scheduled posts, draft approvals) directly in home/feed/inbox contextual surfaces without requiring a dedicated MVP analytics dashboard

### Team Collaboration

- FR71: Seller (account owner) can invite team members via phone or email
- FR72: Seller can assign granular permissions to team members (view inquiries, respond, create drafts, publish, view analytics, change settings)
- FR73: Team members see a simplified role-based UI matching their permissions
- FR74: Team members can create draft posts that require owner approval before publishing
- FR75: Team members can schedule drafts pending owner approval
- FR76: Account owner can review and approve/reject draft posts remotely
- FR77: System logs all team member activity with clear system vs human attribution
- FR78: Team members can view their performance metrics without seeing revenue figures
- FR79: Team members can activate an emergency "Pause Auto-Replies" function
- FR80: System warns when product catalog has not been updated for 6+ hours
- FR81: Seller can revoke team member access
- FR82: Team member can upgrade to an independent MarketBoss account
- FR83: Seller can customize after-hours auto-response messages

### Platform Administration & Compliance

- FR84: Super Admin can create and remove marketplace admin accounts
- FR85: Marketplace Admin can review and approve seller onboarding applications
- FR86: Admin roles are separated: onboarding admin cannot perform dispute resolution, and vice versa
- FR87: Admin can view platform health metrics (uptime, AI usage, active users, signups)
- FR88: Admin can manage support tickets with urgency-based prioritization
- FR89: Admin can access user-level analytics and content history for troubleshooting
- FR90: Admin can initiate Brand Voice recalibration for a seller's account
- FR91: Admin can mediate and resolve buyer-seller disputes
- FR92: System maintains immutable consent records for data protection compliance (timestamped, purpose-specific)
- FR93: System processes data deletion requests within the required compliance timeframe
- FR94: Admin can moderate content (review flagged posts, process takedown requests)
- FR95: System screens content pre-publication for prohibited categories and restricted content
- FR96: System enforces multi-tenant data isolation (zero cross-tenant data leakage)
- FR97: Sellers can export their customer data (with PII anonymized per policy)
- FR98: System supports voice note submissions for support requests with transcription
- FR99: Admin can configure tenant-level limits (post limits, message limits, products, storage)
- FR100: Admin can configure platform-wide settings (commission rates, grace periods, feature gate defaults)
- FR101: Admin can manage seller billing (view payment status, retry failed payments, manual adjustments)
- FR102: Seller can appeal content moderation decisions
- FR103: System tracks trust journey progression as an internal admin metric

### Notifications & Security

- FR104: Seller can configure notification preferences (channel: push, WhatsApp, SMS, email)
- FR105: Seller receives notifications about billing lifecycle events (grace period, downgrade, suspension)
- FR106: Seller can view and terminate their active sessions
- FR107: System alerts users about suspicious account activity (new device, new IP, bulk data access)
- FR108: Users can withdraw specific consent types (NDPA requirement)

### Subscription & Billing

- FR109: Seller can view their current subscription plan and usage
- FR110: Seller can upgrade or downgrade their subscription tier
- FR111: System enforces tier-based limits server-side (daily posts, messages, products, connected accounts)
- FR112: System generates invoices/receipts with seller's business branding
