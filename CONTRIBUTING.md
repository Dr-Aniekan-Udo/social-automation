# Contributing to MarketBoss

## Branching Model

- Base branches: `main` (production), `develop` (integration)
- All feature work branches from `develop`
- Hotfixes branch from `main` and are back-merged to `develop`

## Branch Naming Convention

- `feature/*` for new functionality
- `fix/*` for bug fixes
- `chore/*` for maintenance or non-feature work
- `release/*` for release preparation branches
- `hotfix/*` for urgent production fixes (from `main`, then back-merge to `develop`)

Examples:
- `feature/auth-onboarding`
- `fix/session-timeout`
- `chore/dependency-bump`
- `release/v1.2.0`
- `hotfix/NA-200-payment-webhook-crash`

## Commit Message Convention

Use Conventional Commits:
- `feat: add tenant onboarding endpoint`
- `fix: handle missing tenant context`
- `chore: update github templates`

Minimum prefixes required in this repo:
- `feat:`
- `fix:`
- `chore:`

## Pull Request Lifecycle

Typical flow:
1. Create a branch from `develop` using `feature/*`, `fix/*`, or `chore/*`.
2. Open PR into `develop` for regular work.
3. For releases/hotfixes, follow the project release strategy from product brief.
4. Ensure required checks pass and required approvals are completed before merge.
