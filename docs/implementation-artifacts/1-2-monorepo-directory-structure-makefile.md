# Story 1.2: Monorepo Directory Structure & Makefile

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer or AI agent,
I want the complete monorepo directory skeleton with a root Makefile, environment template, and gitignore,
so that I can immediately begin adding code to the correct locations with standard development commands available.

## Acceptance Criteria

1. **Given** the GitHub repository exists with branch protection (Story 1.1), **when** the monorepo structure is created, **then** the following top-level directories exist: `backend/`, `frontend/`, `infra/`, `docs/`, `api/`, `.github/` (`infra/` is a placeholder container for future deployment/IaC artifacts)
2. `backend/` contains placeholder directories: `cmd/server/`, `internal/domain/`, `internal/service/`, `internal/adapter/`, `internal/handler/`, `migrations/` (each tracked with `.gitkeep`)
3. `frontend/` contains a placeholder `README.md` stating it will be scaffolded in Track P3
4. `api/` contains a placeholder `openapi.yaml` with `info` section only (valid OpenAPI 3.1 stub)
5. `backend/docs/events/` directory exists with a `README.md` describing the event schema registry
6. A root `Makefile` exists with targets: `dev`, `test`, `lint`, `build`, `help`, `db-migrate-up`, `db-migrate-down`, `sqlc-generate`
7. `make help` prints all available targets with descriptions (self-documenting via `##` comments)
8. A `.env.example` file exists with all required environment variables (database URL, Redis URL, JWT secrets placeholder, API keys placeholder) with safe local defaults
9. `.gitignore` covers: Go binaries, `node_modules/`, `.env`, `.next/`, IDE files, OS files
10. All `make` targets that depend on Docker or services print a helpful error message if the dependency is not found

Deployment boundary for Story 1.2: keep `deploy-*.yml` workflows in `.github/workflows/` and keep local compose files at repo root (`docker-compose.yml`, `docker-compose.test.yml`); `infra/` remains a placeholder in this story.
Concrete deployment/IaC files under `infra/` are defined in Story 1.7; Story 1.2 only requires `infra/.gitkeep`.

Completion rule for this story: AC 1-10 are the only required success criteria. Additional preparatory scaffolding is optional and must not be treated as blocking for Story 1.2.

## Tasks / Subtasks

- [x] Create feature branch from `develop` (required)
  - [x] `git checkout develop && git pull origin develop && git checkout -b chore/1-2-monorepo-skeleton`

- [x] Create required directory skeleton (AC: 1, 2, 3, 4, 5)
  - [x] Create `backend/cmd/server/.gitkeep`
  - [x] Create `backend/internal/domain/.gitkeep`
  - [x] Create `backend/internal/service/.gitkeep`
  - [x] Create `backend/internal/adapter/.gitkeep`
  - [x] Create `backend/internal/handler/.gitkeep`
  - [x] Create `backend/migrations/.gitkeep`
  - [x] Create `backend/docs/events/README.md`
  - [x] Create `frontend/README.md`
  - [x] Create `infra/.gitkeep`
  - [x] Create `api/openapi.yaml`

- [x] Create root `Makefile` with required targets (AC: 6, 7, 10)
  - [x] Add `help`, `dev`, `test`, `lint`, `build`, `db-migrate-up`, `db-migrate-down`, `sqlc-generate`
  - [x] Ensure dependency checks print clear messages when Docker/services/CLIs are unavailable

- [x] Create `.env.example` (AC: 8)
  - [x] Include placeholders for `DATABASE_URL`, `REDIS_URL`, JWT secrets, and provider API keys
  - [x] Use safe local defaults and comments

- [x] Create `.gitignore` (AC: 9)
  - [x] Cover Go binaries, `node_modules/`, `.env`, `.next/`, IDE files, and OS files

- [x] Verify required acceptance criteria
  - [x] Run `make help` and confirm target descriptions are printed
  - [x] Verify all required directories/files exist

- [x] Optional early scaffolding (non-blocking; useful if team chooses)
  - [x] Add `make dev-down` and `make dev-reset` as convenience targets (owned by Story 1.3)
  - [x] Add `make api-generate` placeholder target (owned by Story 2.6)
  - [x] Create `backend/db/queries/.gitkeep` to pre-stage SQL query location (owned by Story 2.4)
  - [x] Create `backend/internal/adapter/postgres/migrations/.gitkeep` to pre-stage canonical migration path (owned by Story 2.3)
  - [x] Create `backend/Makefile` stub for backend-local commands (owned by Story 2.1)
  - [x] Add broader ignore entries (`.env.local`, `dist/`, `*.tsbuildinfo`) if desired; still non-blocking for Story 1.2

- [x] Create PR targeting `develop` (required)
  - [x] `gh pr create --base develop --head chore/1-2-monorepo-skeleton --title "chore: monorepo directory skeleton and root Makefile" --label "epic:1,chore"`

## Dev Notes

### Scope Guardrails

- This story is structural scaffolding only.
- Do not add Docker Compose files (Story 1.3).
- Do not initialize Go module or backend runtime code (Story 2.1+).
- Do not add CI workflows (Stories 1.4-1.7).
- Do not move `docker-compose.yml` or `docker-compose.test.yml` into `infra/`.
- Useful prep work may be included only if marked as optional and mapped to an owning downstream story.

### Target Structure (Required for Story 1.2 Success)

```text
repo-root/
|- .env.example
|- .gitignore
|- Makefile
|- api/
|  `- openapi.yaml
|- backend/
|  |- cmd/server/.gitkeep
|  |- internal/domain/.gitkeep
|  |- internal/service/.gitkeep
|  |- internal/adapter/.gitkeep
|  |- internal/handler/.gitkeep
|  |- migrations/.gitkeep
|  `- backend/docs/events/README.md
|- docs/
|- frontend/
|  `- README.md
`- infra/.gitkeep
```

### Optional Prep Mapping (Not Required for Story 1.2 Completion)

| Optional item | Owner story |
| --- | --- |
| `make dev-down`, `make dev-reset` | Story 1.3 |
| `make api-generate` | Story 2.6 |
| `backend/db/queries/.gitkeep` | Story 2.4 |
| `backend/internal/adapter/postgres/migrations/.gitkeep` | Story 2.3 |
| `backend/internal/adapter/*` provider subdirectory stubs | Story 2.1 |
| `backend/Makefile` stub | Story 2.1 |
| deployment artifacts inside `infra/` | Story 1.7 |

Note: `backend/db/queries` (architecture) vs `backend/queries` (current Story 2.4 text) is an existing cross-story naming mismatch that should be reconciled in Story 2.4 before implementation.

### Event Registry Clarification

- `backend/docs/events/` is the backend event schema registry.
- It documents event contracts used by backend async flows (for example, events published via Redis Streams) so producers and consumers stay aligned.

### References

- [Source: docs/planning-artifacts/epics/stories.md#story-12-monorepo-directory-structure--makefile]
- [Source: docs/planning-artifacts/architecture/project-structure-boundaries.md#complete-project-directory-structure]
- [Source: docs/planning-artifacts/architecture/implementation-patterns-consistency-rules.md#communication-patterns]
- [Source: docs/project-context.md#development-workflow-rules]

## Dev Agent Record

### Agent Model Used

GPT-5 Codex

### Debug Log References

- `git checkout develop; git pull origin develop; git checkout -b chore/1-2-monorepo-skeleton`
- `bash -lc "make help"`
- `bash -lc "make test"`
- `bash -lc "make dev"`
- `bash -lc "make db-migrate-up"`
- `bash -lc "make db-migrate-down"`
- `bash -lc "make sqlc-generate"`
- `gh pr create --base develop --head chore/1-2-monorepo-skeleton --title "chore: monorepo directory skeleton and root Makefile" --label "epic:1" --label "chore" --body "..."`

### Completion Notes List

- Created the required monorepo skeleton directories and placeholder files for backend, frontend, API, and infra.
- Added root `Makefile` with required targets (`help`, `dev`, `test`, `lint`, `build`, `db-migrate-up`, `db-migrate-down`, `sqlc-generate`) and clear dependency failure messages.
- Added `.env.example` with safe local defaults for database/redis and placeholders for JWT and provider keys.
- Preserved and validated `.gitignore` coverage for Go binaries, Node/Next artifacts, `.env`, IDE files, and OS files.
- Added `tools/verify-structure.sh` and wired `make test` to verify required structure, required target docs, OpenAPI stub, and dependency-help text.
- Completed optional preparatory scaffolding: `dev-down`, `dev-reset`, `api-generate`, backend query/migration placeholders, and backend-local `Makefile` stub.
- Updated story documentation to fully reflect all files changed in commit `c8b5165` and separated source files from story tracking artifacts in the File List.
- Opened PR: https://github.com/Dr-Aniekan-Udo/social-automation/pull/2

### File List

**Implementation and project source files changed**
- .env.example
- CONTRIBUTING.md
- Makefile
- api/openapi.yaml
- backend/Makefile
- backend/cmd/server/.gitkeep
- backend/db/queries/.gitkeep
- backend/docs/events/README.md
- backend/internal/adapter/.gitkeep
- backend/internal/adapter/postgres/migrations/.gitkeep
- backend/internal/domain/.gitkeep
- backend/internal/handler/.gitkeep
- backend/internal/service/.gitkeep
- backend/migrations/.gitkeep
- docs/implementation-artifacts/1-1-github-repository-branching-strategy.md
- docs/planning-artifacts/architecture/core-architectural-decisions.md
- docs/planning-artifacts/architecture/implementation-patterns-consistency-rules.md
- docs/planning-artifacts/architecture/project-structure-boundaries.md
- docs/planning-artifacts/architecture/starter-template-evaluation.md
- docs/planning-artifacts/epics/epic-list.md
- docs/planning-artifacts/epics/stories.md
- docs/project-context.md
- frontend/README.md
- infra/.gitkeep
- tools/verify-structure.sh

**Story tracking artifacts changed**
- docs/implementation-artifacts/1-2-monorepo-directory-structure-makefile.md
- docs/implementation-artifacts/sprint-status.yaml

## Change Log

- 2026-02-25: Implemented Story 1.2 scaffold, Makefile targets, environment template, verification checks, optional prep tasks, and created PR #2.
- 2026-02-25: Addressed review report discrepancies by synchronizing File List with commit `c8b5165`, refining `.gitignore`, narrowing `verify-structure.sh` to required Story 1.2 checks, and improving `.env.example` variable comments.
