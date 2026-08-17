---
name: qrspi-plan
description: >
  QRSPI Plan phase: expand structure.md into a self-contained plan.md
  with file paths, snippets, and checkbox verification. Use when the
  user runs /qrspi-plan or says "QRSPI plan".
when-to-use: /qrspi-plan, QRSPI plan
argument-hint: "thoughts/qrspi/<id>/"
metadata:
  short-description: "QRSPI Plan phase"
---

# QRSPI Plan

Write the agent's working document. The human already approved structure; they only spot-check this. An implementer with only `plan.md` must be able to finish the work.

## Setup

`QRSPI_HOME` is `../qrspi/` relative to this `SKILL.md`. Read `$QRSPI_HOME/references/method.md` and the `plan.md` template in `$QRSPI_HOME/references/artifacts.md`.

Read `$ARGUMENTS/structure.md`, `research.md`, and `task.md`.

## Process

1. Keep the phase order from `structure.md`. Do not reorder.
2. For each phase: exact paths, create/modify/delete, snippets for non-obvious bits only, concrete verify commands from this repo (`Makefile`, `package.json`, `AGENTS.md`, etc.).
3. Every file named in `structure.md` must appear. No extra refactors or drive-by cleanup.
4. If a question is still open, ask the user and wait. Do not write a plan with unresolved questions.
5. Schema or codegen work must include how to update tests / what to do if codegen is unavailable.
6. Write `plan.md` from the template. Checkboxes (`- [ ]`) on every verification item.
7. Summarize for the user. Note any drift from `structure.md`. Do not start Implement.

If a phase cannot be implemented as outlined, stop and send the user back to `/qrspi-structure`.

## Output

- `$ARGUMENTS/plan.md`
- Next: `/qrspi-implement thoughts/qrspi/<id>/`
