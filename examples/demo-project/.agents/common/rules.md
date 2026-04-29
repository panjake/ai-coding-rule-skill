## Karpathy Behavioral Guidelines

> Priority: higher than general implementation taste, personal coding habits, and opportunistic cleanup; lower than explicit user instructions, repository safety boundaries, and confirmed project hard constraints.
> For simple tasks, apply Karpathy guidelines directly. For complex or cross-module tasks, apply them together with the design-doc requirement below.

1. Think before coding.
   - Do not silently choose one interpretation when requirements are ambiguous.
   - State assumptions before implementation.
   - If multiple reasonable directions exist, present the options, tradeoffs, and recommendation before coding.

2. Simplicity first.
   - Default to the most direct solution with the smallest code and smallest blast radius.
   - Do not add abstraction, extension points, or config switches for hypothetical future needs.
   - Do not build defensive logic for unrealistic scenarios.
   - If the implementation becomes more complex than the problem, simplify it.

3. Make surgical changes.
   - Every changed line should map directly to the current request.
   - Do not refactor, reformat, or rename unrelated code.
   - Only clean up unused imports, variables, branches, or dead code created by your own change.

4. Do not hide confusion.
   - Do not pretend to understand business semantics when you do not.
   - Surface naming confusion, contradictory legacy logic, or unclear upstream/downstream constraints before continuing.
   - If there is not enough information to safely change core logic, stop and recover more context first.

5. Define success criteria and verify.
   - Define what completion means before changing code.
   - For bug fixes, prefer a reproducible check first, then verify the fix.
   - For behavior changes, prefer targeted tests, validation steps, or minimal repeatable checks.
   - Never claim unexecuted validation as passed.

# Common Agent Rules

## Core Rules

1. Keep only stable, high-frequency hard constraints.
   - This file records long-lived rules that affect quality often.
   - Do not write temporary preferences, one-off requests, or unverified ideas here.

2. Default to minimal changes.
   - Prefer the smallest necessary modification that solves the problem.
   - Do not add opportunistic refactors, unrelated formatting, or unrelated renames.
   - If you find a broader issue, record the risk or propose a plan instead of widening the change immediately.

3. Read before editing on non-trivial tasks.
   - For business logic, database, config, framework entrypoints, shared helpers, core models, payments, messaging, or scheduled tasks, read the relevant code first.
   - Do not edit core logic from filename guesses or memory alone.

4. Write a design note before complex tasks.
   - For cross-module refactors, core-path behavior changes, database semantic changes, reporting definition changes, or bulk migrations, write a design or refactoring note first.
   - The note should cover goal, current state, approach, impact scope, risks, and validation.

5. Code is the source of truth.
   - `.agents` memory is for navigation and handoff, not a substitute for code.
   - If memory and code conflict, trust code and record the mismatch in the active developer's `bugs.md` or `sessions/`.

## Collaboration Rules

1. Confirm developer identity before reading personal memory.
   - Before a developer profile is confirmed, read only `AGENTS.md` and `.agents/common/`.
   - Read `.agents/developers/{developer}/` only after the user explicitly confirms the profile.
   - Do not infer the profile from git config, directory names, prior sessions, branch names, or file authors.
   - A valid confirmation should name the profile explicitly, for example: `Use the jake profile.`
   - After confirmation and before the first personal read or write, restate the active profile and boundary, for example: `Current developer profile: jake. Only read and write .agents/developers/jake/.`
   - If identity confirmation and a task request appear in the same message, treat identity confirmation as the first mandatory step and the task request as second.
   - In that case, first restate the active profile and write boundary, then continue into recovery or task execution.
   - Do not skip the identity echo just because the task itself is immediately actionable.

2. Keep memory layers separate.
   - Project map -> `.agents/common/context.md`
   - Current task progress -> `.agents/developers/{developer}/progress.md`
   - Confirmed problems, failed approaches, and risks -> `.agents/developers/{developer}/bugs.md`
   - Session handoff summary -> `.agents/developers/{developer}/sessions/`
   - Accepted important decisions -> `.agents/developers/{developer}/decisions/`

3. Do not pollute another developer's directory.
   - Do not read, summarize, or modify another developer's personal memory unless the user explicitly asks for that developer's context.
   - Without an explicit developer profile, do not read or write any personal directory.
   - If you cite another developer's conclusion, mark the source and whether you verified it.

4. Report recovery explicitly.
   - After reading context, explicitly report the recovery result before larger changes.
   - The report should include active profile, write boundary, files read, current progress, known risks, blockers, and next recommended action.
   - Do not skip this recovery confirmation and jump straight into implementation.

5. Leave handoff memory before ending meaningful work.
   - Before ending a substantial session, update `progress.md`, update `bugs.md` when needed, and add a session note when the work left blockers, risks, or resume context.
   - Promote only stable shared facts to `.agents/common/context.md`.

6. Auto-initialize a new developer profile.
   - After the user confirms a developer profile, if the personal directory does not exist, create `AGENTS.md`, `progress.md`, `bugs.md`, `sessions/`, `decisions/`, and `templates/`.
   - Initialize `progress.md` with `Task not initialized yet. Waiting for the developer to define the task.`
   - Initialize `bugs.md` with `No known bugs or risks recorded yet.`
   - After initialization, continue the normal read order before coding.

7. Shared common rules require approval.
   - `.agents/common/` is shared infrastructure and must not be edited casually.
   - Unless `jake` explicitly asks for it or approves it, other developers and agents should not directly modify `.agents/common/rules.md` or `.agents/common/context.md`.
   - Proposed changes should go under `.agents/common/proposals/` using `.agents/common/templates/common-change-proposal-template.md`.
   - Unapproved proposals are not active rules.

8. Recovery must be explicit.
   - After reading `AGENTS.md`, `.agents/common/`, and the selected developer memory, explicitly report the recovery result before larger changes.
   - Do not skip this and jump straight into implementation.
   - The recovery report should at least include: current developer profile, write boundary, files read, project-map summary, current progress, known risks, blockers, and next recommended action.

9. Keep the project map compressed.
   - `.agents/common/context.md` primarily serves later model navigation, not human storytelling.
   - Each section should usually stay within 3-8 bullets.
   - Only expand one or two truly high-risk domains.

10. Long-context recovery escalation requires user consent.
   - If the context becomes so long that recovery quality, scope discipline, or rule-following appears to degrade, do not silently switch strategy or ask the user to restart on your own.
   - First notify the user that context pressure may be reducing execution reliability.
   - Explain the proposed recovery action and why it may help.
   - Ask for explicit approval before using a new recovery step, a new thread, or a reset-style workflow.
   - If the proposed action depends on the current thread state, explicitly tell the user not to close the current session yet, because doing so may prevent complete recovery of prior memory.

## Project Rules

1. Follow the existing project structure first.
   - Prefer the current entry layers, base classes, models, helpers, libraries, and config layout.
   - Do not casually introduce new directory layers, DI containers, or modern framework-style abstractions.

2. Do not smuggle refactors into test-only work.
   - If the user asked for unit tests, feature tests, or validation only, production-code changes require explicit approval.
   - "This is easier to test after a refactor" is not approval.
   - When you believe a refactor is justified, pause and present the minimal non-refactor option and the refactor option side by side.

3. No silent scope expansion.
   - Do not expand a narrow request into broader cleanup, restructuring, or adjacent improvements without explicit approval.
   - If the real fix touches more files or modules than expected, stop and restate the new write scope before continuing.
   - If the user approved tests, docs, or validation only, that is not approval for production changes, refactors, or module-wide cleanup.

4. Check environment-facing config when editing config.
   - For database, object storage, third-party APIs, or cache config changes, inspect the relevant config directories and example files together.
   - Do not record sensitive config values in shared memory.

5. Be careful with shared helpers and base classes.
   - Shared helpers, base classes, and shared libraries have wide blast radius, so read call sites or entrypoints first.
   - When changing shared functions or base behavior, explain compatibility impact.

6. Confirm the call path before changing an entry layer.
   - Before editing a controller, route, command, or task entrypoint, confirm the dependent model, view, helper, config, and static asset path.
   - For command or task entrypoints, note execution style and execution environment.

7. Standard response after a scope violation.
   - If you already crossed the approved scope, do not defend the change with a long technical justification first.
   - First report:
     - original request
     - actual widened scope
     - why the widening was out of bounds
     - smallest compliant option
     - broader option that would require approval
   - Then wait for the user's decision when rollback, rewrite, or a narrower path is required.

8. Do not fake validation.
   - Never claim that a command passed if you did not run it.
   - Report only validation that actually happened.

## Verification Rules

1. Run the smallest relevant validation when possible.
   - After code changes, prefer the smallest check that matches the change, such as `php -l`, `phpunit`, targeted unit tests, script tests, or a concrete manual verification path.
   - If environment or dependency limits prevent validation, state that explicitly.

2. Explain the validation path for business-logic changes.
   - Cover the normal path and important boundaries.
   - For config, tasks, messaging, payments, export, or similar flows, explain the impact scope clearly.

# Demo Rules

This file exists only as a minimal target for testing snippet injection.
