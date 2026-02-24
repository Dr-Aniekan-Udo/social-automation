# Sprint Change Proposal - 2026-02-24

## Workflow Context
- Workflow: `correct-course`
- Agent role: Scrum Master (Bob)
- Mode: Batch (direct remediation requested)
- Trigger source: `docs/planning-artifacts/implementation-readiness-report-2026-02-24.md`

## 1. Issue Summary
Critical readiness defects were identified during implementation-readiness validation:
1. Enabler work was mixed into the primary product-epic chain (Epics 1-3).
2. Stories declared `Depends on: None` while still referencing future epics in acceptance criteria.
3. Story 10.3 blended unrelated concerns and did not cleanly satisfy FR49 fallback behavior.
4. Story language for analytics implied dedicated MVP dashboards, conflicting with contextual MVP analytics direction.
5. FR98/NFR-P13 transcription requirements were not explicitly represented in architecture boundaries.
6. FR14 wording did not explicitly capture agreed multimodal quick-capture scope.

## 2. Impact Analysis
### Epic Impact
- Reclassified former Epics 1-3 as prerequisite tracks (`Track P1`, `Track P2`, `Track P3`) while keeping value-delivery epics starting at Epic 4.
- Epic 10 scope clarified by separating fallback payment behavior from billing preferences and subscription tier changes.
- Epics 8 and 12 analytics stories aligned to contextual MVP surfaces.

### Story Impact
Updated stories:
- Dependency/forward-reference remediation: `4.5`, `5.9`, `6.4`, `6.8`, `7.3`, `7.4`, `7.6`, `8.4`, `9.4`
- Analytics context remediation: `8.8`, `12.1`
- Traceability/scope remediation: `10.3`
- New separated stories created from 10.3 split: `10.8` (FR104), `10.9` (FR110)

### Artifact Conflicts Resolved
- PRD + requirements inventory: FR14 updated for quick form plus multimodal capture path.
- Architecture boundaries: explicit transcription boundary and NFR-P13 mapping added.
- Architecture validation matrix: FR98 + NFR-P13 coverage rows added.

### Technical Impact
- Planning artifacts only; no production code changes.
- Backlog sequencing clarity improved with explicit dependency semantics and single-concern story boundaries.

## 3. Recommended Approach
### Options Evaluated
1. Direct Adjustment: **Viable** (Medium effort, Low risk)
2. Potential Rollback: **Not viable** (High effort, no benefit for doc-only defects)
3. MVP Review/Scope Reduction: **Not required** (MVP remains achievable)

### Selected Path
**Option 1 - Direct Adjustment**
- Fix in-place planning defects.
- Preserve MVP goals and delivery timeline.
- Enforce explicit story traceability and dependency clarity.

### Effort / Risk / Timeline
- Effort: Medium
- Risk: Low
- Timeline impact: No sprint delay expected; minor backlog grooming required due added stories 10.8/10.9.

## 4. Detailed Change Proposals
### A. Epic Taxonomy Realignment
Artifact: `docs/planning-artifacts/epics/epic-list.md`, `docs/planning-artifacts/epics/stories.md`

OLD:
- `### Epic 1: DevOps Foundation & Infrastructure`
- `### Epic 2: Backend Scaffolding & Data Foundation`
- `### Epic 3: Frontend Scaffolding & Design System`

NEW:
- `### Track P1 (Prerequisite Enabler, Formerly Epic 1): ...`
- `### Track P2 (Prerequisite Enabler, Formerly Epic 2): ...`
- `### Track P3 (Prerequisite Enabler, Formerly Epic 3): ...`

Rationale:
- Separates readiness enablers from user-value epic chain.

### B. Hidden Forward Dependency Remediation
Artifact: `docs/planning-artifacts/epics/stories.md`

Representative OLD -> NEW corrections:
- Story 5.9
  - OLD: "uses AI content generation from Epic 6 ..."
  - NEW: "uses AI content generation when enabled for the tenant ..."
- Story 6.8
  - OLD: "FR69 mechanism from Epic 12" / "admin Epic 13"
  - NEW: direct requirement phrasing without cross-epic dependency leakage.
- Story 9.4
  - OLD: "team member name (from Epic 11)"
  - NEW: "responding team member display name when applicable"

Validation result:
- `Depends on: None` stories with hidden forward epic references: **0**

### C. Story 10.3 Scope Split (Single-Concern Stories)
Artifact: `docs/planning-artifacts/epics/stories.md`

OLD Story 10.3:
- Mixed FR49 + FR104 + FR110 in one story.

NEW:
- Story 10.3: `Payment Provider Outage Fallback` (FR49 only)
- Story 10.8: `Billing Notification Channel Preferences` (FR104)
- Story 10.9: `Subscription Tier Upgrade/Downgrade` (FR110)

Rationale:
- Eliminates blended scope and restores testable traceability.

### D. Analytics MVP Context Alignment
Artifact: `docs/planning-artifacts/epics/stories.md`

OLD:
- Story 8.8: `Sales Analytics Dashboard`
- Story 12.1: `Engagement Metrics Dashboard`

NEW:
- Story 8.8: `Contextual Sales Performance Insights`
- Story 12.1: `Contextual Engagement Metrics Surfaces`
- ACs explicitly enforce contextual MVP surfaces and keep dedicated dashboard routes post-MVP/gated.

Rationale:
- Aligns stories to FR64/NFR-P5 and MVP boundary decisions.

### E. PRD/Inventory FR14 Clarification
Artifacts:
- `docs/planning-artifacts/prd/functional-requirements.md`
- `docs/planning-artifacts/epics/requirements-inventory.md`

OLD FR14:
- Minimal quick form only.

NEW FR14:
- Minimal per-product data captured via quick form and/or multimodal shortcuts (camera-assisted + voice input), with mandatory canonical fields.

### F. Architecture Coverage for FR98 + NFR-P13
Artifacts:
- `docs/planning-artifacts/architecture/project-structure-boundaries.md`
- `docs/planning-artifacts/architecture/architecture-validation-results.md`

OLD:
- No explicit transcription boundary mapping.

NEW:
- Added transcription boundary (`domain/support -> service/support/transcription_service -> adapter/transcription`).
- Added FR98 and NFR-P13 coverage rows in architecture validation matrix.

## 5. Checklist Execution Status
### Section 1 - Trigger and Context
- `1.1` [x] Done
- `1.2` [x] Done
- `1.3` [x] Done

### Section 2 - Epic Impact Assessment
- `2.1` [x] Done
- `2.2` [x] Done
- `2.3` [x] Done
- `2.4` [x] Done
- `2.5` [x] Done

### Section 3 - Artifact Conflict Analysis
- `3.1` [x] Done
- `3.2` [x] Done
- `3.3` [x] Done
- `3.4` [x] Done

### Section 4 - Path Forward Evaluation
- `4.1` [x] Viable
- `4.2` [x] Not viable
- `4.3` [x] Not required
- `4.4` [x] Done (Option 1 selected)

### Section 5 - Proposal Components
- `5.1` [x] Done
- `5.2` [x] Done
- `5.3` [x] Done
- `5.4` [x] Done
- `5.5` [x] Done

### Section 6 - Final Review and Handoff
- `6.1` [x] Done
- `6.2` [x] Done
- `6.3` [x] Done (user requested full remediation and continuation)
- `6.4` [N/A] No active sprint status file in repository (template only)
- `6.5` [x] Done

## 6. Implementation Handoff
### Scope Classification
**Moderate**: Backlog/story reorganization with cross-artifact planning updates.

### Handoff Recipients and Responsibilities
- Product Owner / Scrum Master:
  - Accept story split (10.3 -> 10.3/10.8/10.9) and adjust sprint planning order.
  - Confirm contextual analytics acceptance criteria remain MVP-gated.
- Solution Architect:
  - Confirm transcription boundary aligns with adapter/provider strategy and NFR-P13 instrumentation expectations.
- Development Team:
  - Implement against updated stories and dependency semantics.
  - Preserve dependency integrity rule in future story edits.

### Success Criteria
1. No story with `Depends on: None` contains forward-epic references.
2. Story 10.3 traceability is FR49-only; FR104 and FR110 are independently testable stories.
3. Analytics stories reference contextual MVP surfaces only.
4. FR14 and FR98/NFR-P13 alignment is present across PRD, epics inventory, and architecture artifacts.

## 7. Artifacts Modified
- `docs/planning-artifacts/epics/epic-list.md`
- `docs/planning-artifacts/epics/stories.md`
- `docs/planning-artifacts/prd/functional-requirements.md`
- `docs/planning-artifacts/epics/requirements-inventory.md`
- `docs/planning-artifacts/architecture/project-structure-boundaries.md`
- `docs/planning-artifacts/architecture/architecture-validation-results.md`

## 8. Final Outcome
All critical and major readiness defects identified in the latest implementation-readiness assessment have been remediated in planning artifacts, with validation checks passing for the key dependency and traceability criteria.
