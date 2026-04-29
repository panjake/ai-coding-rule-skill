# Demo AGENTS

This file exists only as a minimal target for testing snippet injection.

## AI Project Onboarding Guide

> Any AI agent joining this repository must read this file first.
> This guide explains how to understand the project, recover developer context, start work safely, and leave handoff notes.

## Why This Exists

This repository uses `.agents/` as an external memory base for AI-assisted development.

The goal is to keep context continuous across:

- different devices
- different AI models
- different days
- different developers

The memory base separates:

- shared rules
- project facts
- developer identity
- current task progress
- known problems
- session handoff notes

## Join Flow

Follow this order before starting non-trivial work:

1. Read this file: `AGENTS.md`.
2. Read shared rules: `.agents/common/rules.md`.
3. Read the project map: `.agents/common/context.md`.
4. Confirm the developer profile.
5. If `.agents/developers/{developer}/` does not exist, initialize it with the standard scaffold.
6. Read only the selected developer profile:
   - `.agents/developers/{developer}/AGENTS.md`
   - `.agents/developers/{developer}/progress.md`
   - `.agents/developers/{developer}/bugs.md`
   - relevant recent files in `.agents/developers/{developer}/sessions/`
7. Read task-specific docs and code.
8. Summarize the recovered context before making larger changes.

If the user does not specify a developer name, ask which developer profile to use before reading `.agents/developers/{developer}/`.

For this repository, `jake` is one developer profile, but it is not the default for everyone.

## Developer Identity Guard

Developer identity must be explicit.

- Do not infer a developer profile from git config, file ownership, previous sessions, branch names, or the existence of `.agents/developers/jake/`.
- Before a profile is confirmed, only read `AGENTS.md` and `.agents/common/`.
- A valid profile confirmation should name the profile explicitly, for example: `Use the jake profile.`
- After confirmation and before reading or writing any personal directory, state the active profile and write boundary, for example: `Current developer profile: jake. Only read and write .agents/developers/jake/.`
- If the same user message both confirms the profile and assigns a task, still perform the profile echo first, then move to the task.
- If another developer is joining temporarily, prefer an isolated profile such as `guest-{name}`, `temp-{YYYY-MM-DD}`, or `contractor-{name}`.
- Developer profile names must use lowercase letters, digits, or hyphens, and must not use reserved names such as `common`, `templates`, `proposals`, `developers`, `system`, or `shared`.
- If the selected profile does not exist, initialize only that profile from the standard scaffold. Do not copy another developer's personal memory.

## Recovery Summary

After reading the required files, summarize:

- project map
- current task progress
- blockers
- known risks
- next recommended action

Keep the summary concise and grounded in the files you actually read.

After the recovery is complete and before making larger changes, explicitly report the recovery result to the developer. The response should include:

- current developer profile
- write boundary
- which memory files were read
- project map summary
- current progress
- known risks
- blockers
- next recommended action

For example:

```text
Current developer profile: jake. Only read and write .agents/developers/jake/.

Context recovery complete:
- Read `AGENTS.md`
- Read `.agents/common/rules.md`
- Read `.agents/common/context.md`
- Read `.agents/developers/jake/AGENTS.md`
- Read `.agents/developers/jake/progress.md`
- Read `.agents/developers/jake/bugs.md`
- Read recent relevant session notes
```

## Memory Layers

- Common hard rules -> `.agents/common/rules.md`
- Project-level facts -> `.agents/common/context.md`
- Proposed common changes -> `.agents/common/proposals/`
- Developer-level operating rules -> `.agents/developers/{developer}/AGENTS.md`
- Current task progress -> `.agents/developers/{developer}/progress.md`
- Confirmed problems, failed approaches, and risks -> `.agents/developers/{developer}/bugs.md`
- Single-session handoff notes -> `.agents/developers/{developer}/sessions/`
- Important accepted decisions -> `.agents/developers/{developer}/decisions/`

Do not mix these layers. A clean split is more valuable than a long memory file.

## Understand The Project

Use `.agents/common/context.md` as the project map. It should tell you:

- architecture
- modules
- technology stack
- dependency direction
- key business areas
- important documents and code entry points

Use code as the source of truth. If `.agents` memory conflicts with code, trust code and record the mismatch in the selected developer's `bugs.md` or `sessions/`.

## Start Work Safely

The common rules in `.agents/common/rules.md` are mandatory.

High-level defaults:

- Keep changes minimal by default.
- For non-simple tasks, read relevant code before editing.
- For non-trivial work, follow this order: design first, ask for confirmation second, code only after confirmation.
- For non-trivial work, declare the expected write scope before coding. If the real change grows beyond that scope, stop and confirm again.
- Respect the requested task shape. If the user asked only for tests, docs, or validation, do not change production code unless the user explicitly approves it.
- Do not silently widen a narrow request into broader cleanup, refactoring, or adjacent improvement work.
- If long-context pressure starts degrading recovery or scope control, notify the developer first, ask for explicit approval before any recovery escalation, and warn them not to close the current session if that would break memory continuity.
- After developer identity is confirmed, guide the developer to initialize the project map when it is missing or too weak to navigate the codebase.
- For complex tasks, write a design or refactoring note before implementation.
- Do not fake validation results.
- Prefer explicit dependencies and existing project conventions over introducing new framework-style abstractions casually.

## New Developer Bootstrap

When a developer profile is confirmed and `.agents/developers/{developer}/` does not exist, create:

- Ask the developer to input their nickname or profile name explicitly, for example `jake`.
- Use that exact nickname as the `{developer}` directory name.
- Only allow lowercase letters, digits, and hyphens.
- Reject reserved names such as `common`, `templates`, `proposals`, `developers`, `system`, and `shared`.
- Do not substitute git username, file owner, previous session name, or a guessed default.

```text
.agents/developers/{developer}/
  AGENTS.md
  progress.md
  bugs.md
  sessions/
  decisions/
  templates/
```

Initialize the files with:

- `AGENTS.md`: developer identity, read order, write boundaries.
- `progress.md`: `Task not initialized yet. Waiting for the developer to define the task.`
- `bugs.md`: `No known bugs or risks recorded yet.`
- `templates/session-template.md`: minimal session handoff template.
- `templates/decision-template.md`: minimal decision record template.

Use only `.agents/common/rules.md` and `.agents/common/context.md` for initialization. Do not read or copy another developer's personal memory as a template.

After initialization, continue with the normal read order and update `progress.md` once the task is clear.

## Session Close Protocol

Treat developer memory updates as part of the work, not as optional cleanup.

Before sending the final substantial response of a work session:

1. When available, prefer calling repository workflow scripts such as `scripts/update-progress.sh`, `scripts/append-session.sh`, `scripts/append-bug.sh`, `scripts/append-decision.sh`, or `scripts/close-session.sh`.
2. Update `.agents/developers/{developer}/progress.md`.
3. Update `.agents/developers/{developer}/bugs.md` if you confirmed a new problem, failed attempt, or risk.
4. Add or update a short session note under `.agents/developers/{developer}/sessions/` when the work changed direction, left blockers, or produced decisions worth resuming from.
5. Record long-lived decisions under `.agents/developers/{developer}/decisions/` when the session produced a stable rule, architecture choice, or workflow commitment.
6. Then send the final response to the developer.

The default expectation is:

- `progress.md` always reflects the latest known status after meaningful work.
- A final answer should not claim completion while personal memory is stale.
- If the agent could not update memory, it must explicitly say so in the final response.

If context pressure starts degrading recovery or scope control:

- do not silently switch workflow
- notify the developer first
- ask for explicit approval before any recovery escalation
- if continuity depends on the current session, explicitly warn the developer not to close it yet

## Common Directory Governance

`.agents/common/` is shared infrastructure and must not be changed casually.

- Only `jake` may directly approve and merge changes to `.agents/common/rules.md` or `.agents/common/context.md`.
- Other developers or agents should write a proposal under `.agents/common/proposals/YYYY-MM-DD-{developer}-{topic}.md`.
- Proposals should use `.agents/common/templates/common-change-proposal-template.md`.
- A proposal must explain reason, suggested change, impact, risk, and evidence.
- Until approved by `jake`, proposed common changes are not active rules.

## Privacy And Ownership

- `.agents/common/` is shared.
- `.agents/developers/{developer}/` belongs to that developer.
- Do not inspect or summarize another developer's personal memory unless the user asks for that developer's context.
- Do not read or write `.agents/developers/{developer}/` until the user explicitly confirms that developer profile.
- Do not copy one developer's progress, bugs, or sessions into another developer's directory without explicit instruction.
- Do not overwrite another developer's personal directory unless explicitly asked.

## End With Handoff

Before ending a substantial development session:

1. Update `.agents/developers/{developer}/progress.md` with current status, next step, and blockers.
2. Update `.agents/developers/{developer}/bugs.md` with new confirmed problems, failed approaches, or risks.
3. Add a short session note under `.agents/developers/{developer}/sessions/` when useful.
4. For stable multi-developer facts, submit a common proposal or ask `jake` to approve the common change.

## Karpathy-Style Coding Guidelines

Apply these guidelines for code changes unless the user explicitly asks otherwise:

- Think before coding. State assumptions explicitly, and do not silently choose between multiple interpretations when requirements are ambiguous.
- Prefer the simplest solution that fully solves the requested problem. Do not add speculative abstraction, configurability, or defensive handling for unrealistic scenarios.
- Keep changes surgical. Touch only the lines needed for the task, match existing style, and do not refactor unrelated code.
- Define success in a verifiable way. For bug fixes and behavior changes, prefer a reproducible check or test before claiming completion.
- If a simpler approach exists, say so. If something is unclear, stop and surface the confusion instead of guessing.
