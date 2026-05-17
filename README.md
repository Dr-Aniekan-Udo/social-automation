# MarketBoss
**Category:** Fullstack  
**Tech Stack:** Go, Next.js, TypeScript, PostgreSQL, Redis, AI/LLM APIs  
**Status:** Active  
**Thumbnail:** assets/thumbnail.png
## Overview
MarketBoss is an AI-powered social commerce automation platform designed for African markets. This repository contains the complete product planning, architecture documentation, and AI agent skill configurations for building a SaaS platform that automates social media content creation, scheduling, analytics, and e-commerce integration across WhatsApp, Instagram, Facebook, and TikTok.
## Features
- **AI Content Generation**: LLM-powered content creation tailored for African audiences
- **Multi-Platform Publishing**: Automated scheduling and posting across major social platforms
- **Social Commerce Integration**: Connect product catalogs to social media posts
- **Analytics Dashboard**: Track engagement, conversions, and ROI across platforms
- **Audience Intelligence**: AI-driven insights on follower behavior and preferences
- **Automated Responses**: Chatbot handling of customer inquiries and orders
## Repository Structure
This is a governance-first monorepo containing product planning artifacts and development scaffolding:
marketboss/
├── docs/                          # Product documentation
│   ├── planning-artifacts/        # PRD, product brief, architecture
│   │   ├── prd/                   # Product Requirements Document
│   │   ├── product-brief/         # Executive summary and market analysis
│   │   ├── architecture/          # Core architectural decisions
│   │   ├── ux-design-specification/  # Design system and user journeys
│   │   └── epics/                 # Feature epics and user stories
│   └── implementation-artifacts/  # Sprint plans and readiness reports
├── .agent/skills/                 # AI agent development skills
│   ├── apify-*/                   # Social media data collection skills
│   ├── frontend-design/           # UI/UX design skills
│   ├── architecture-designer/     # System design skills
│   └── openai-webhooks/           # Webhook integration examples
├── .bmad/                         # BMAD agent workflow configurations
│   ├── workflows/                 # Analysis, planning, solutioning flows
│   └── agents/                    # Multi-agent team definitions
├── CONTRIBUTING.md                # Branching and commit conventions
└── README.md
## Tech Stack
| Layer | Technology |
|-------|-----------|
| **Backend** | Go 1.22+ with Clean Architecture |
| **Frontend** | Next.js 14+ with App Router |
| **Database** | PostgreSQL 16+ |
| **Cache** | Redis |
| **AI/ML** | OpenAI API, Google Gemini |
| **Social APIs** | WhatsApp Business, Instagram Graph, Facebook, TikTok |
| **Scraping** | Apify |
| **Monitoring** | Sentry |
## Development Governance
### Branching Strategy
- `main` — Production releases
- `develop` — Integration branch
- `feature/*` — New functionality
- `fix/*` — Bug fixes
- `chore/*` — Maintenance
### Commit Convention
We use Conventional Commits:
```bash
feat: add tenant onboarding endpoint
fix: handle missing tenant context
chore: update GitHub templates
See CONTRIBUTING.md (CONTRIBUTING.md) for full details.
Product Documentation
This repository serves as the single source of truth for product development:
- 
Product Brief (docs/planning-artifacts/product-brief/) — Market analysis, technical architecture, financial infrastructure
- 
PRD (docs/planning-artifacts/prd/) — Functional and non-functional requirements
- 
Architecture (docs/planning-artifacts/architecture/) — Core architectural decisions and patterns
- 
UX Design (docs/planning-artifacts/ux-design-specification/) — Design system, user journeys, visual foundation
- 
Epics & Stories (docs/planning-artifacts/epics/) — Feature breakdown and implementation roadmap
AI Agent Skills
The .agent/skills/ directory contains specialized AI skills for development:
- 
Social Media Intelligence — Audience analysis, competitor monitoring, trend detection
- 
Frontend Design — UI/UX pattern generation and design system maintenance
- 
Architecture Design — System design, database selection, API patterns
- 
Webhook Integration — Examples for OpenAI, Stripe webhooks (Express, FastAPI, Next.js)
Getting Started
⚠️ Note: This repository is currently in the product planning and documentation phase. Application code will be added as development progresses.
Prerequisites
- 
Node.js 18+
- 
Go 1.22+
- 
PostgreSQL 16+
- 
Redis
Planned Setup
# Clone the repository
git clone https://github.com/Dr-Aniekan-Udo/social-automation.git
cd social-automation
# Backend (planned)
cd backend
go mod download
# Frontend (planned)
cd frontend
npm install
# Set environment variables
cp .env.example .env
Contributing
Please read CONTRIBUTING.md (CONTRIBUTING.md) for:
- 
Branch naming conventions
- 
Commit message format
- 
Pull request lifecycle
License
Private — All rights reserved.
