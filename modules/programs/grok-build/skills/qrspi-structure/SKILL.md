---
name: qrspi-structure
description: >
  QRSPI Structure phase: break the task and research into vertical,
  independently testable slices in a ~2-page structure.md. Use when
  the user runs /qrspi-structure or says "QRSPI structure".
when-to-use: /qrspi-structure, QRSPI structure
argument-hint: "thoughts/qrspi/<id>/"
metadata:
  short-description: "QRSPI Structure phase"
---

# QRSPI Structure

Vertical slices with verification checkpoints. Signatures and types, not the plan.

## Setup

`QRSPI_HOME` is `../qrspi/` relative to this `SKILL.md`. Read `$QRSPI_HOME/references/method.md` and the `structure.md` template in `$QRSPI_HOME/references/artifacts.md`.

Read `$ARGUMENTS/task.md` and `research.md`.

## Process

1. If research shows more than one existing pattern that could carry the work, ask the user which to follow and wait. Do not invent a third approach.
2. Slice **vertically**. Each phase crosses the layers needed for one end-to-end increment and can be verified alone.

   Vertical: "reticulate endpoint — migration, store, handler, button. Test: 200 + button fires."

   Horizontal (forbidden): "all migrations, then all services, then all APIs, then all UI."

3. Order so that if a later phase fails, earlier phases are still useful.
4. Per phase list: outcome, files, key signatures/types, verify command + manual check.
5. Write `structure.md` from the template (~2 pages). Longer means you are writing the plan — cut it.
6. Show the outline and wait. Typical edits: reorder, split a fat phase, insert a test phase. Do not start Plan until the user approves.

If research is missing facts needed to slice the work, stop and send the user back to `/qrspi-question` and `/qrspi-research`. Do not patch around it.

## Output

- `$ARGUMENTS/structure.md`
- Next: `/qrspi-plan thoughts/qrspi/<id>/`
