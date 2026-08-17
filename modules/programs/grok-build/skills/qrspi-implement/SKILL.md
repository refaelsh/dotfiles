---
name: qrspi-implement
description: >
  QRSPI Implement phase: grow plan.md one vertical slice at a time with
  TDD (red-green-refactor) and Clean Code, as Robert C. Martin. Use when
  the user runs /qrspi-implement or says "QRSPI implement". Do not use
  for generic "implement this" — that is /implement.
when-to-use: /qrspi-implement, QRSPI implement
argument-hint: "thoughts/qrspi/<id>/"
metadata:
  short-description: "QRSPI Implement phase (TDD)"
---

# QRSPI Implement

Implement `plan.md` as Uncle Bob. TDD is the process. Clean Code is the standard. Checkboxes track phase progress. Do not invoke `/implement`.

## Tests are the spec — do not cheat

Once a test exists, it is the spec. You will **never** change a test to make implementation easier or to make the bar go green. That includes rewriting assertions, deleting tests, skipping them, weakening fixtures, or running a narrower command so a failure disappears.

If production cannot satisfy a test, **stop and ask**. The test stays. You fix the code, or you wait for the user to change the spec. You do not negotiate with the test.

## Setup

`QRSPI_HOME` is `../qrspi/` relative to this `SKILL.md`. Read `$QRSPI_HOME/references/method.md` and `$QRSPI_HOME/references/uncle-bob.md`. Follow `uncle-bob.md` for every edit.

Read `$ARGUMENTS/plan.md` fully. Resume at the first unchecked item. Trust completed `[x]` work unless it is clearly broken.

## Process (one plan phase)

1. Read every file that phase touches before editing.
2. Grow the planned behavior with TDD. For each next behavior:
   - **Red** — write one failing test. Run it. See it fail for the reason you expect.
   - **Green** — write the minimum production code that passes that test. Nothing else. Do not edit the test.
   - **Refactor** — remove duplication, name intent, shrink functions. Tests stay green. Do not edit the test.
   The plan's snippets are hints, not a script. Tests the plan omitted are still required. Do not write production code the current failing test does not demand.
3. Stay inside the phase. Refactor files you opened for the current test (Boy Scout). Do not clean unrelated files; mention them after the phase.
4. On a mismatch, stop and ask:

   ```
   Issue in Phase N:
   Expected: ...
   Found: ...
   Impact: ...
   How should I proceed?
   ```

   Small mismatch: adapt after the user agrees. Structural failure (wrong API, missing dependency): send them back to `/qrspi-plan` or `/qrspi-structure`.
5. When the phase's behaviors are covered, run its automated verification. Fix failures with TDD — a new failing test first if coverage was the gap. Never by changing a test that already exists.
6. Check off automated items in `plan.md` (`- [ ]` → `- [x]`). Do not check manual items until the user confirms.
7. Commit that phase only: `Phase N: <name from plan>`.
8. Pause:

   ```
   Phase N complete — ready for manual verification.
   Automated: <passed>
   Please verify: <manual items>
   Say when to start Phase N+1.
   ```

9. Repeat when the user continues. When every checkbox is `[x]`, stop. The plan is done.

Use subagents only for a targeted debug or an unfamiliar file. Do not skip ahead. Do not skip red.

## Output

- Tests and production code grown in TDD cycles
- One commit per completed phase
- `$ARGUMENTS/plan.md` checkboxes updated
