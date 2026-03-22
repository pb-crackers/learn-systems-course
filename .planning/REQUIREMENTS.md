# Requirements: Learn Systems

**Defined:** 2026-03-22
**Core Value:** Every lesson must be hands-on and interactive — the learner practices real skills on real systems, not just reads about them. Understanding comes through doing.

## v1.2 Requirements

Requirements for Enhanced Questions milestone. Each maps to roadmap phases.

### Quiz Component

- [ ] **QUIZ-01**: User sees 7-10 multiple choice questions at the bottom of each lesson page after the exercise
- [ ] **QUIZ-02**: User selects one answer per question and sees "Incorrect" with no correct answer revealed on wrong selection
- [ ] **QUIZ-03**: User sees an explanation reinforcing the reasoning when answering correctly
- [ ] **QUIZ-04**: User must retake the entire quiz when any answer is wrong
- [ ] **QUIZ-05**: User sees how many attempts they have made on the current quiz
- [ ] **QUIZ-06**: User sees a "Continue to Next Lesson" button after passing the quiz with 100%

### Progress Gating

- [ ] **GATE-01**: Lesson is marked complete only after quiz is passed with 100% — MarkCompleteButton retired for quiz-enabled lessons
- [ ] **GATE-02**: Existing completed lessons remain complete after v1.2 upgrade (grandfather rule)
- [ ] **GATE-03**: Lessons without quiz data retain current completion behavior (backward compatible)

### Data & Schema

- [ ] **DATA-01**: Quiz questions defined as typed MDX named exports with validated TypeScript schema
- [ ] **DATA-02**: Quiz type schema locked (question text, options array, correct index, explanation) before content authoring begins
- [ ] **DATA-03**: All 56 lessons have quiz data with 7-10 questions covering key concepts and commands

### Layout Integration

- [ ] **LAYOUT-01**: Quiz component rendered in LessonLayout after MDX content, consistent placement across all lessons
- [ ] **LAYOUT-02**: Quiz data extracted from MDX named export via existing dynamic import pipeline

## Future Requirements

### Quiz Enhancements

- **QUIZ-07**: User must complete hands-on exercise before quiz unlocks (exercise-first lock)
- **QUIZ-08**: User sees question order shuffled on retake attempts
- **QUIZ-09**: User can review all quiz results for completed lessons

## Out of Scope

| Feature | Reason |
|---------|--------|
| Correct answer reveal on wrong selection | Defeats retrieval practice — learner must earn the knowledge through retake |
| Per-question retry (retry just missed questions) | Full retake reinforces the entire concept set, not just the missed item |
| Score display (e.g., "7/10") | With 100% gate, partial scores add no information and invite "almost there" thinking |
| Question randomization on retake | Adds localStorage complexity for session shuffle state; defer to v1.3 |
| Timer/time limits on quizzes | Unnecessary pressure for a self-paced learning tool |
| Backend quiz storage | localStorage is sufficient for single-learner app |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| QUIZ-01 | Phase 13 | Pending |
| QUIZ-02 | Phase 13 | Pending |
| QUIZ-03 | Phase 13 | Pending |
| QUIZ-04 | Phase 13 | Pending |
| QUIZ-05 | Phase 13 | Pending |
| QUIZ-06 | Phase 13 | Pending |
| GATE-01 | Phase 14 | Pending |
| GATE-02 | Phase 12 | Pending |
| GATE-03 | Phase 12 | Pending |
| DATA-01 | Phase 12 | Pending |
| DATA-02 | Phase 12 | Pending |
| DATA-03 | Phase 15 | Pending |
| LAYOUT-01 | Phase 14 | Pending |
| LAYOUT-02 | Phase 14 | Pending |

**Coverage:**
- v1.2 requirements: 14 total
- Mapped to phases: 14
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-22*
*Last updated: 2026-03-22 after roadmap creation (phases 12-15)*
