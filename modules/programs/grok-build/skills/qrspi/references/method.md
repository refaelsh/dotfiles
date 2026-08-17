# QRSPI method

Question → Research → Structure → Plan → Implement

Use for complex, multi-file work in an existing codebase. If the task fits in one sentence and touches fewer than 3 files, say so and stop — QRSPI is overkill.

Do not invoke bundled `/design`, `/implement`, or plan-mode. Those are different workflows.

## Artifact directory

All files for one task live in one directory:

```
thoughts/qrspi/<id>/
```

`<id>` is `TICKET-brief-slug` when a ticket exists, otherwise `YYYY-MM-DD-brief-slug`.

Create the directory with `mkdir -p`. Persist progress in these files, not in conversation history.

## Files

| File | Writer | Readers | Must not read |
|------|--------|---------|---------------|
| `task.md` | Question | Structure, Plan | **Research** |
| `questions.md` | Question | Research | — |
| `research.md` | Research | Structure, Plan | — |
| `structure.md` | Structure | Plan, Implement | Research |
| `plan.md` | Plan | Implement | Research |

## Skills

| Phase | Skill | Inputs | Output | Human gate |
|-------|-------|--------|--------|------------|
| Question | `qrspi-question` | task text / ticket | `task.md`, `questions.md` | Approve or edit questions |
| Research | `qrspi-research` | `questions.md` only | `research.md` | Review facts |
| Structure | `qrspi-structure` | task + research | `structure.md` | Approve slices |
| Plan | `qrspi-plan` | structure + research + task | `plan.md` | Spot-check |
| Implement | `qrspi-implement` | `plan.md` | code + checkbox updates | After each phase |

## Resolve paths

`QRSPI_HOME` is the directory that contains `references/method.md`. From a sibling skill at `.../qrspi-<phase>/SKILL.md`, that is `.../qrspi/`.

Read `$QRSPI_HOME/references/artifacts.md` for file templates. Read `$QRSPI_HOME/references/documentarian.md` before spawning research subagents. Read `$QRSPI_HOME/references/uncle-bob.md` before implementing.

## Context

Prefer a fresh session per phase. Load only the files listed as inputs for that phase.

Research is a context firewall: the researcher must not see `task.md`, the ticket, or the feature goal. If this conversation already contains that information, the parent must not research itself — spawn a child that receives only `questions.md`.

Keep the working context lean. After a phase, the artifact file is the source of truth.

## Human gates

Stop after Question, Research, Structure, and after each Implement phase. Present the artifact (or a short summary plus the path) and wait. Do not start the next phase until the user approves, edits, or names a different next phase.

## Going back

- Questions miss the real surface → re-run Question
- Research cannot answer, or answers the wrong area → re-run Question, then Research
- Structure is missing facts → Question + Research
- Plan cannot follow the outline → Structure
- Implement hits a structural mismatch (wrong API, missing dependency) → Plan or Structure
- Small local mismatches during Implement: adapt in place and note the drift

Do not work around a known-bad artifact.
