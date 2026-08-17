# QRSPI artifact templates

Write only the sections shown. Do not add extra top-level headings.

## task.md

```markdown
# Task

<2-3 sentences: what is being built and why.>
```

## questions.md

`Context` must not mention the feature, goal, or desired behavior.

```markdown
# Research Questions

## Context
<2-3 sentences on which areas of the codebase to inspect. No feature goal.>

## Questions
1. <neutral fact-seeking question>
2. <neutral fact-seeking question>
```

## research.md

Every finding needs a `path:line` citation. Cap at ~300 lines.

```markdown
# Research Findings

## Q1: <question text>

### Findings
- <fact with `path:line`>
- <how components connect>
- <pattern observed>

## Q2: <question text>

### Findings
- ...

## Cross-Cutting Observations
<conventions that span questions, each with `path:line`>

## Open Areas
<questions that could not be fully answered>
```

## structure.md

Cap at ~2 pages. Vertical slices only. Signatures and types, not implementations.

```markdown
# Structure Outline

## Approach
<1-2 sentences from the task, grounded in research>

## Phase 1: <name>
<what this slice delivers end-to-end>

**Files**: `path/a`, `path/b`
**Key changes**:
- `fn(name: Type): Ret` — new/modified
- `Type { field: Type }` — new type

**Verify**: <project test command>; <manual check>

## Phase 2: <name>
...

## Testing Checkpoints
<what must be true after each phase>
```

## plan.md

Self-contained. An agent with only this file must be able to implement. Checkboxes are mandatory.

````markdown
# Implementation Plan

## Overview
<1-2 sentences from the task>

## Phase 1: <name from structure.md>

### Changes

#### 1. <file or component>
**File**: `path/to/file.ext`
**Action**: create | modify | delete

```language
// key snippet only
```

### Verification
#### Automated
- [ ] <project test/lint command>
- [ ] <phase-specific command>

#### Manual
- [ ] <what to check and expected result>
````
