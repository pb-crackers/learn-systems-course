# Requirements: Learn Systems v1.1 Command Pedagogy

**Defined:** 2026-03-20
**Core Value:** Every lesson must be hands-on and interactive — the learner practices real skills and understands how machines actually work. Understanding comes through doing.

## v1.1 Requirements

### Command Annotations

- [x] **ANNO-01**: Foundation exercises display per-flag/argument annotations below each command block explaining what each part does
- [x] **ANNO-02**: Annotations are static and always visible (not tooltips/hover) for maximum readability
- [x] **ANNO-03**: AnnotatedCommand component renders command first (copyable), then flag breakdown rows below

### Challenge Mode

- [x] **CHAL-01**: Intermediate exercises describe step goals in plain English without giving the exact command
- [x] **CHAL-02**: Challenge exercises provide only the overall goal with no procedural steps
- [x] **CHAL-03**: Challenge exercises include a scoped command reference sheet (using QuickReference) at the bottom
- [x] **CHAL-04**: Progressive hints available for learners who get stuck (expandable reveal)

### Difficulty-Aware Rendering

- [x] **DIFF-01**: ExerciseCard renders differently based on difficulty tier (Foundation=annotated, Intermediate=recall, Challenge=compose)
- [x] **DIFF-02**: Global learner preference toggle allows overriding to harder/easier mode
- [x] **DIFF-03**: Foundation exercises are always guided regardless of toggle (safety net for beginners)
- [x] **DIFF-04**: Preference persists in localStorage alongside existing progress data

### Scenario Integration

- [x] **SCEN-01**: Exercises include scenario-contextualized questions between command steps ("I am running this command so I can answer THIS question")
- [x] **SCEN-02**: Questions reference the exercise's opening scenario so commands feel purposeful, not isolated
- [x] **SCEN-03**: Scenario questions have expected answers revealed after the learner thinks (expandable reveal pattern)

### Content Migration

- [ ] **MIGR-01**: All Foundation lessons (~22) have annotated command blocks for every exercise
- [ ] **MIGR-02**: All Intermediate lessons (~20) have step descriptions rewritten to be actionable without commands
- [ ] **MIGR-03**: Challenge/capstone exercises have goal-only format with reference sheets
- [ ] **MIGR-04**: All exercises include scenario-contextualized questions tying commands back to the opening scenario
- [ ] **MIGR-05**: Each module passes `next build` after migration
- [x] **MIGR-06**: Linux Fundamentals migrated first as prototype to validate the pattern

## Future Requirements

### v2 (deferred)

- **K8S-01**: Kubernetes basics — pods, deployments, services, configmaps
- **ANSI-01**: Configuration management with Ansible — playbooks, inventory, idempotency
- **SEC-01**: Security hardening module — SSH hardening, secrets management, vulnerability scanning
- **TERM-01**: Embedded web-based terminal emulator for in-browser exercises
- **QUIZ-01**: Interactive quizzes after each lesson

## Out of Scope

| Feature | Reason |
|---------|--------|
| In-browser terminal for live command execution | High complexity, deferred to v2 — current Docker labs work well |
| Per-exercise difficulty toggle | UX confusion — global preference is cleaner per research |
| Gamification / scoring | Not aligned with pedagogy goals — learning, not competing |
| Auto-grading of challenge mode answers | No backend — would require server infrastructure |
| Video walkthroughs | Text and code-based curriculum only (PROJECT.md constraint) |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| ANNO-01 | Phase 9 | Complete |
| ANNO-02 | Phase 8 | Complete |
| ANNO-03 | Phase 9 | Complete |
| CHAL-01 | Phase 9 | Complete |
| CHAL-02 | Phase 8 | Complete |
| CHAL-03 | Phase 8 | Complete |
| CHAL-04 | Phase 9 | Complete |
| DIFF-01 | Phase 9 | Complete |
| DIFF-02 | Phase 9 | Complete |
| DIFF-03 | Phase 8 | Complete |
| DIFF-04 | Phase 8 | Complete |
| SCEN-01 | Phase 9 | Complete |
| SCEN-02 | Phase 9 | Complete |
| SCEN-03 | Phase 9 | Complete |
| MIGR-01 | Phase 11 | Pending |
| MIGR-02 | Phase 11 | Pending |
| MIGR-03 | Phase 11 | Pending |
| MIGR-04 | Phase 11 | Pending |
| MIGR-05 | Phase 11 | Pending |
| MIGR-06 | Phase 10 | Complete |

**Coverage:**
- v1.1 requirements: 20 total
- Mapped to phases: 20
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-20*
*Last updated: 2026-03-20 — traceability mapped after roadmap creation*
