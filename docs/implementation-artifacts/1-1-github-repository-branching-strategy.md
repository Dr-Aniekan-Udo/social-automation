# Story 1.1: GitHub Repository & Branching Strategy

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer or AI agent,  
I want a properly configured GitHub repository with branch protection, naming conventions, and issue templates,  
so that all contributors follow consistent workflows and code quality is enforced from day one.

## Acceptance Criteria

1. Given the repository does not yet exist, when the repository is created on GitHub, then it has a `main` branch and a `develop` branch.
2. `main` has branch protection requiring PR review, passing CI checks, and no direct pushes.
3. `develop` has branch protection requiring passing CI checks and no direct pushes.
4. Branch naming convention is documented: `feature/*`, `fix/*`, `chore/*`.
5. Repository labels exist for: `epic:1` through `epic:13`, `bug`, `feature`, `chore`, `priority:p0`, `priority:p1`, `priority:p2`.
6. Issue templates exist for: bug report, feature request, story implementation.
7. A PR template exists with checklist items for tests passing, lint clean, coverage maintained, and story linked.
8. Conventional Commits format (`feat:`, `fix:`, `chore:` minimum set) is documented in `CONTRIBUTING.md`.
9. Repository description and `README.md` include project name (`MarketBoss`) and a brief overview.
10. Initial project setup explicitly aligns with the approved baseline: custom Go Clean Architecture backend layout plus `create-next-app` frontend scaffold.

## Tasks / Subtasks

- [x] Create or verify GitHub repository metadata (AC: 1, 9)
- [x] Ensure `main` and `develop` branches exist and are visible on remote
- [x] Set repository description to include MarketBoss one-line summary
- [x] Add or update root `README.md` with project overview and architecture baseline note

- [x] Configure branch protection or equivalent rulesets for `main` and `develop` (AC: 2, 3)
- [x] Enforce PR-only updates to `main` and `develop` (no direct pushes)
- [x] Configure required status checks for protected branches
- [x] Require pull request approval on `main`
- [x] Enable conversation resolution before merge
- [x] Confirm administrators are not silently bypassing protection unless explicitly intended

- [x] Document branch and commit conventions in `CONTRIBUTING.md` (AC: 4, 8)
- [x] Document branch naming: `feature/*`, `fix/*`, `chore/*`
- [x] Document Conventional Commits structure and examples
- [x] Include short PR lifecycle note (`feature/*` -> `develop`; release/hotfix strategy reference)

- [x] Define repository labels (AC: 5)
- [x] Create labels `epic:1` ... `epic:13`
- [x] Ensure labels `bug`, `feature`, `chore`, `priority:p0`, `priority:p1`, `priority:p2` are present

- [x] Add issue and PR templates (AC: 6, 7)
- [x] Create `.github/ISSUE_TEMPLATE/bug-report.yml`
- [x] Create `.github/ISSUE_TEMPLATE/feature-request.yml`
- [x] Create `.github/ISSUE_TEMPLATE/story-implementation.yml`
- [x] Create `.github/ISSUE_TEMPLATE/config.yml` (template chooser behavior)
- [x] Create `.github/pull_request_template.md` with required checklist

- [x] Add verification notes for reproducible repo governance setup (AC: 1-10)
- [x] Capture commands/screenshots used to verify branch protections, labels, and templates
- [x] Add concise "how to apply to new repos" note for future onboarding reuse

## Dev Notes

### Story Foundation

- Epic context: Track P1 (Prerequisite Enabler) is foundational and intentionally blocks downstream implementation quality risks.
- Story 1.1 is the governance guardrail story for all subsequent work.
- This story has no functional FR mapping; it is traced to NFR-S9, NFR-I1 and enabler ENB-E1.

### Developer Context Section

This story is repository-governance only. It should not introduce backend/frontend feature code. Keep scope narrow: GitHub repository setup, policy enforcement, and contributor workflow templates.

#### Technical Requirements

- Protect both `main` and `develop`.
- `main` must require pull request review and passing checks.
- `develop` must require passing checks and no direct pushes.
- All required status checks referenced in branch rules must correspond to unique workflow job names to avoid ambiguous check resolution.
- Commit standard in `CONTRIBUTING.md` must include Conventional Commits format and examples.
- Template files must be committed on the repository default branch to be active.

#### Architecture Compliance

- Follow canonical precedence: architecture > ux spec > prd > ux html > product brief.
- Enforce CI gate mindset from day one; this story defines the pipeline contract that later stories depend on.
- Preserve Main + Develop workflow from project context and product brief.
- Do not add new tooling beyond approved stack or scanner profile.

#### Library & Framework Requirements

- No runtime library requirements for this story.
Platform constraints:
- GitHub branch protection rules and/or rulesets.
- GitHub issue forms/templates and PR templates.
- Conventional Commits v1.0.0 specification for commit message format.

#### File Structure Requirements

- `README.md` (root): include project summary and baseline setup statement.
- `CONTRIBUTING.md` (root): branch naming, commit format, PR expectations.
- `.github/ISSUE_TEMPLATE/bug-report.yml`
- `.github/ISSUE_TEMPLATE/feature-request.yml`
- `.github/ISSUE_TEMPLATE/story-implementation.yml`
- `.github/ISSUE_TEMPLATE/config.yml`
- `.github/pull_request_template.md`

#### Testing Requirements

Repository governance verification checklist:
- Branches: `main` and `develop` exist on remote.
- Protected branch behavior: direct push rejected for protected branches.
- Required checks: PR merge blocked until required checks pass.
- Review requirement: `main` merge blocked without approval.
- Labels: all required labels present and reusable on issues/PRs.
- Issue templates: chooser displays bug/feature/story templates.
- PR template: checklist auto-populates on new PR.
- Documentation: README + CONTRIBUTING present and accurate.

Suggested verification commands (if `gh` CLI is available):

- `gh repo view --json name,description,defaultBranchRef`
- `gh label list --limit 200`
- `gh api repos/{owner}/{repo}/branches/main/protection`
- `gh api repos/{owner}/{repo}/branches/develop/protection`

#### Latest Technical Information

- GitHub supports both branch protection rules and rulesets; rulesets can layer and aggregate with existing branch protections.
- Branch protection caveat: when requiring status checks, workflow job names must be unique across workflows.
- Issue templates must live under `.github/ISSUE_TEMPLATE` on the default branch; issue forms use `.yml`.
- PR templates can live in root, `docs`, or `.github`, and must be on the default branch to apply automatically.
- New repositories are created with a single default branch; ensure `develop` is created explicitly as part of story completion.

#### Project Context Reference

- Main + Develop branching flow is mandatory in this project context.
- Conventional Commits are required for commit history hygiene.
- CI gates and security scanners are mandatory repository controls and should be represented in PR checklist language.
- No-bloat tooling rule applies: do not introduce alternative scanners/tools in this story.

### Project Structure Notes

- This story creates repository-level governance files before backend/frontend scaffolding stories.
- It must not conflict with Story 1.2 monorepo skeleton ownership of broader directory setup.

### References

- [Source: docs/planning-artifacts/epics/stories.md#story-11-github-repository--branching-strategy]
- [Source: docs/planning-artifacts/epics/epic-list.md#track-p1-prerequisite-enabler-formerly-epic-1-devops-foundation--infrastructure]
- [Source: docs/planning-artifacts/architecture/core-architectural-decisions.md#api--communication-patterns]
- [Source: docs/planning-artifacts/architecture/implementation-patterns-consistency-rules.md#process-patterns]
- [Source: docs/planning-artifacts/product-brief/13-scrum-workflow-git-branching-strategy.md#131-branching-model]
- [Source: docs/project-context.md#development-workflow-rules]
- [Source: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches]
- [Source: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets]
- [Source: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates]
- [Source: https://www.conventionalcommits.org/en/v1.0.0/]

### Story Completion Status

- Status set to `review`.
- Completion note: AC1-AC10 are implemented and verified. Branch protection for `main` and `develop` is active after repo visibility change to public.

## Dev Agent Record

### Agent Model Used

GPT-5 Codex

### Debug Log References

- `gh repo view Dr-Aniekan-Udo/social-automation --json name,isPrivate,description,defaultBranchRef,url`
- `git ls-remote --heads origin`
- `gh label list --repo Dr-Aniekan-Udo/social-automation --limit 200`
- `gh api repos/Dr-Aniekan-Udo/social-automation/branches/main/protection`
- `gh api repos/Dr-Aniekan-Udo/social-automation/branches/develop/protection`

### Completion Notes List

- Created private GitHub repository `Dr-Aniekan-Udo/social-automation` and pushed both `main` and `develop`.
- Changed repository visibility to public to allow branch protection on current plan.
- Updated repository description and root `README.md` with MarketBoss overview and approved baseline note.
- Added `CONTRIBUTING.md` with branch naming and Conventional Commits guidance.
- Added required issue templates and PR template under `.github/`.
- Created required labels (`epic:1..13`, `bug`, `feature`, `chore`, `priority:p0..p2`).
- Captured reproducible verification steps in `docs/implementation-artifacts/1-1-verification-notes.md`.
- Confirmed active branch protection on `main` and `develop` via GitHub API with required checks, PR review on `main`, conversation resolution, and enforced admins.

### File List

- docs/implementation-artifacts/1-1-github-repository-branching-strategy.md
- README.md
- CONTRIBUTING.md
- .github/ISSUE_TEMPLATE/bug-report.yml
- .github/ISSUE_TEMPLATE/feature-request.yml
- .github/ISSUE_TEMPLATE/story-implementation.yml
- .github/ISSUE_TEMPLATE/config.yml
- .github/pull_request_template.md
- docs/implementation-artifacts/1-1-verification-notes.md
- docs/implementation-artifacts/sprint-status.yaml
