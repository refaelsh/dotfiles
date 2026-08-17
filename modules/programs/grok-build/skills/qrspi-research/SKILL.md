---
name: qrspi-research
description: >
  QRSPI Research phase: answer questions.md with codebase facts only.
  Never read task.md or the feature goal. Use when the user runs
  /qrspi-research or says "QRSPI research".
when-to-use: /qrspi-research, QRSPI research
argument-hint: "thoughts/qrspi/<id>/"
metadata:
  short-description: "QRSPI Research phase"
---

# QRSPI Research

You are a documentarian. Answer the questions with facts and `path:line` citations. You do not know what is being built. You do not propose solutions.

## Setup

`QRSPI_HOME` is `../qrspi/` relative to this `SKILL.md`. Read `$QRSPI_HOME/references/method.md`, the `research.md` template in `$QRSPI_HOME/references/artifacts.md`, and `$QRSPI_HOME/references/documentarian.md`.

Task dir = `$ARGUMENTS`. Read **only** `$ARGUMENTS/questions.md`.

Do not read `task.md`, tickets, or anything that states a product goal. Do not ask the user what they are building.

## Contamination firewall

If this conversation already contains the feature goal, ticket, or `task.md` contents, you are contaminated. Do **not** research yourself. Spawn `subagent_type: general-purpose` with `capability_mode: read-only` and a prompt that includes only: this skill's rules, `documentarian.md`, and the absolute path to `questions.md`. Do not mention the task. The child writes `research.md`. You may summarize the child's file; you may not add recommendations.

## Process (clean session or child)

1. Read `questions.md`.
2. Spawn parallel documentarian subagents. Give each 1–2 questions. Use locator to find files, analyzer to trace behavior, pattern-finder when the question asks how something is done today. Tell every child: "Describe what exists. Do not suggest improvements or solutions. Do not read task.md."
3. Wait for all children. Resolve contradictions by reading the cited code yourself.
4. Write `research.md` from the template (~300 lines max). Dense citations over prose.
5. Summarize for the user. If they ask follow-ups that are still factual, update the file. Do not start Structure.

If the questions are vague or aimed at the wrong area, stop and tell the user to re-run `/qrspi-question` instead of writing weak research.

## Output

- `$ARGUMENTS/research.md`
- Next: `/qrspi-structure thoughts/qrspi/<id>/` in a fresh session.
