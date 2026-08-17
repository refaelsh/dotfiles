---
name: qrspi-question
description: >
  QRSPI Question phase: turn a ticket or task into task.md plus 3-7
  neutral research questions. Questions must not reveal what is being
  built. Use when the user runs /qrspi-question or says "QRSPI question".
when-to-use: /qrspi-question, QRSPI question, QRSPI questions
argument-hint: "<ticket file, issue URL, or task description>"
metadata:
  short-description: "QRSPI Question phase"
---

# QRSPI Question

Turn the task into a short `task.md` and 3–7 **neutral** research questions. The next phase answers those questions with no knowledge of the feature.

## Setup

`QRSPI_HOME` is `../qrspi/` relative to this `SKILL.md`. Read `$QRSPI_HOME/references/method.md` and the `task.md` / `questions.md` sections of `$QRSPI_HOME/references/artifacts.md`.

## Process

1. Read any ticket file or URL the user provided.
2. Spawn one locator subagent (see `$QRSPI_HOME/references/documentarian.md`) so the questions hit real code, not guesses.
3. Write 3–7 questions:
   - Each targets a different area.
   - Neutral: what exists and how it works, never how to build the feature.
   - Prefer "trace the flow" over yes/no.
   - Good: "How does the middleware chain handle authentication, and where are policies defined?"
   - Bad: "What's the best way to add a new authenticated endpoint?"
4. Choose `<id>`: `TICKET-brief-slug` or `YYYY-MM-DD-brief-slug`. Create `thoughts/qrspi/<id>/`.
5. Write `task.md` and `questions.md` using the templates. `questions.md` Context must not mention the goal.
6. Show the questions to the user and wait. Edit if they ask. Do not start Research.

If fewer than 3 honest questions exist, say QRSPI is the wrong tool and stop.

## Output

- `thoughts/qrspi/<id>/task.md`
- `thoughts/qrspi/<id>/questions.md`
- Next: `/qrspi-research thoughts/qrspi/<id>/` in a fresh session.
