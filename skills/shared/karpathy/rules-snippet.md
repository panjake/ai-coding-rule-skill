## Karpathy Behavioral Guidelines

> Priority: higher than personal coding preferences and opportunistic cleanups; lower than explicit user instructions, repository safety boundaries, and confirmed project constraints.
> For simple tasks, apply these rules directly. For complex or cross-module tasks, apply them together with the design-note requirement below.

1. Think before coding.
   - Do not silently choose one interpretation when the request is ambiguous.
   - State assumptions explicitly.
   - If two or more reasonable paths exist, present options, tradeoffs, and your recommendation.

2. Simplicity first.
   - Prefer the smallest solution that fully solves the problem.
   - Do not add speculative abstraction, configuration, or extension points.
   - Do not add defensive handling for unrealistic scenarios.
   - If the implementation is obviously more complex than the problem, simplify it.

3. Make surgical changes.
   - Every changed line should trace directly to the request.
   - Do not refactor, reformat, or rename unrelated code.
   - Only remove imports, variables, branches, or dead code that your change made unnecessary.
   - If the user asked for tests only, default to changing only test files unless the user explicitly approves production-code changes.

4. Do not hide confusion.
   - Do not pretend to understand unclear business meaning.
   - Surface naming conflicts, legacy contradictions, and unclear upstream or downstream constraints before continuing.
   - If the current information is not enough for a safe change, stop and gather context first.

5. Define success criteria and verify.
   - Define what counts as done before claiming completion.
   - For bug fixes, prefer a reproducible check first, then a verification step after the fix.
   - For behavior changes, prefer targeted tests, verification steps, or a minimal repeatable check.
   - Do not claim that unexecuted validation has passed.

# Common Agent Rules

> Scope: stable execution rules and hard constraints for all developer agents.

## Core Rules

1. Keep only high-value stable rules.
   - This file stores long-lived constraints, not temporary preferences or task-local ideas.

2. Default to minimal changes.
   - Prefer the smallest necessary change.
   - Do not add opportunistic refactors, formatting sweeps, or unrelated renames.
   - If you discover a larger issue, record the risk or propose a follow-up instead of expanding the current task.
   - When the requested scope is narrow, keep the file scope narrow too. For example, "add tests" does not implicitly authorize refactoring production code.
   - Do not silently expand scope from one file, one module, or one task shape into a broader change.

3. Read before editing for non-trivial tasks.
   - Read relevant code and context before touching business logic, data flow, configuration, entry points, shared helpers, payment logic, messaging, or scheduled work.

4. Respect task-shape boundaries.
   - If the user asked for tests, documentation, or validation only, do not change production behavior by default.
   - If writing the requested test appears to require a production-code refactor, stop and say so explicitly.
   - Present the smallest viable options, for example:
     - integration-style test without production changes
     - mock-based unit test
     - production refactor plus tests
   - Do not silently choose the refactor path.
   - The same rule applies to docs-only, validation-only, and narrow bugfix tasks: do not widen the task shape without explicit approval.

5. Design first, ask second, code only after confirmation.
   - For non-trivial work, do not move directly from idea to implementation.
   - First write the proposed approach, scope, and expected file changes.
   - Then ask for confirmation when the approach has non-obvious tradeoffs, broad impact, or changes the requested task shape.
   - Start coding only after the user confirms the proposed direction.
   - Do not silently transition from design discussion into implementation.

6. Declare expected write scope before coding.
   - For non-trivial work, state the files or modules you expect to modify before implementation starts.
   - If the actual write scope grows beyond that declared scope, stop and ask for confirmation before continuing.
   - If the request is narrow, the declared write scope should stay narrow too.

7. Write a design note before complex work.
   - For cross-module refactors, core workflow changes, data-semantic changes, reporting-definition changes, or bulk migrations, write a short design note first.

8. Code is the source of truth.
   - `.agents` memory is for routing and handoff, not for overriding code.
   - If memory conflicts with code, trust code and record the mismatch in the developer's `bugs.md` or `sessions/`.

## Collaboration Rules

1. Confirm the developer profile first.
   - Before the profile is confirmed, only read `AGENTS.md` and `.agents/common/`.
   - Only read `.agents/developers/{developer}/` after the user explicitly confirms the profile.
   - Do not infer the developer profile from git config, directory names, previous sessions, branch names, or file authors.
   - A valid confirmation must name the profile explicitly, for example: `Use the jake profile.`
   - Before the first read or write in the personal directory, restate the active profile and write boundary, for example: `Current developer profile: jake. Only read and write .agents/developers/jake/.`
   - If identity confirmation and a task request appear in the same message, treat identity confirmation as the first mandatory step and the task request as second.
   - In that case, first restate the active profile and write boundary, then continue into recovery or task execution.
   - Do not skip the identity echo just because the task itself is immediately actionable.

2. Require explicit profile input for initialization.
   - If `.agents/developers/{developer}/` does not exist, ask for the exact nickname or profile name first.
   - Do not substitute the git username, file owner, previous session name, or a guessed default.
   - Profile names may contain only lowercase letters, digits, and hyphens.
   - Reject reserved names such as `common`, `templates`, `proposals`, `developers`, `system`, and `shared`.
   - Do not read or copy another developer's personal memory during initialization.
   - Temporary collaborators should use isolated profiles such as `guest-{name}`, `temp-{YYYY-MM-DD}`, or `contractor-{name}`.

3. Keep memory layers separate.
   - Project map: `.agents/common/context.md`
   - Current progress: `.agents/developers/{developer}/progress.md`
   - Problems, failed approaches, and risks: `.agents/developers/{developer}/bugs.md`
   - Session handoff: `.agents/developers/{developer}/sessions/`
   - Stable accepted decisions: `.agents/developers/{developer}/decisions/`
   - Project maps should focus on reading order, dependency direction, core domain index, and knowledge boundaries. Do not turn them into encyclopedias.

4. Do not pollute another developer's memory.
   - Do not read, summarize, or modify another developer's personal directory unless the user explicitly asks for that developer's context.
   - Do not read or write any `.agents/developers/{developer}/` directory without an explicit profile selection.
   - When referencing another developer's conclusion, cite the source and whether it has been verified.

5. Always hand off before a substantial session ends.
   - Update `progress.md`, `bugs.md`, and relevant `sessions/` entries before the final substantial response.
   - If the repository provides `scripts/update-progress.sh`, `scripts/append-session.sh`, `scripts/append-bug.sh`, `scripts/append-decision.sh`, or `scripts/close-session.sh`, prefer those scripts over manual edits.
   - If personal memory could not be updated, explicitly say so in the final response instead of pretending the handoff is complete.
   - Promote only stable shared facts into `.agents/common/context.md`.

6. Auto-bootstrap new developer profiles.
   - When the profile is confirmed and the personal directory is missing, create `AGENTS.md`, `progress.md`, `bugs.md`, `sessions/`, `decisions/`, and `templates/`.
   - Initialize `progress.md` with an explicit "task not initialized yet" state.
   - Initialize `bugs.md` with "no known bugs or risks yet".
   - Continue normal reading only after initialization.

7. Shared directory changes require review.
   - `.agents/common/` is shared infrastructure and must not be changed casually.
   - Only the project manager may directly approve or merge changes to `.agents/common/rules.md` and `.agents/common/context.md`.
   - Other developers or agents should write a proposal under `.agents/common/proposals/`.
   - Proposals should use `.agents/common/templates/common-change-proposal-template.md`.
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

1. Follow existing project style.
   - Reuse the existing layout for entry points, base classes, models, helpers, libraries, and configuration.
   - Do not introduce new directory layers, dependency injection containers, or framework-style abstractions without a strong reason.

2. Do not smuggle refactors into test-only work.
   - If the user asked for unit tests, feature tests, or validation only, production-code changes require explicit approval.
   - "This is easier to test after a refactor" is not approval.
   - When you believe a refactor is justified, pause and present the minimal non-refactor option and the refactor option side by side.

3. No silent scope expansion.
   - Do not expand a narrow request into broader cleanup, restructuring, or adjacent improvements without explicit approval.
   - If the real fix touches more files or modules than expected, stop and restate the new write scope before continuing.
   - If the user approved tests, docs, or validation only, that is not approval for production changes, refactors, or module-wide cleanup.

4. Check environment and config files together.
   - When changing database, storage, third-party API, or cache configuration, also inspect the relevant config directories and examples.
   - Do not record secrets in shared memory.

5. Be careful with shared helpers and base classes.
   - Read callers or entry points before modifying a shared helper, base class, or shared library.
   - Explain compatibility impact when shared behavior changes.

6. Confirm the call path before changing an entry point.
   - Before changing a controller, route, command, or task entry point, confirm the related models, views, helpers, config, and static resources.
   - Pay attention to execution style and runtime environment for commands and jobs.

7. Standard response after a scope violation.
   - If you already crossed the approved scope, do not defend the change with a long technical justification first.
   - First report:
     - original request
     - actual widened scope
     - why the widening was out of bounds
     - smallest compliant option
     - broader option that would require approval
   - Then wait for the user's decision when rollback, rewrite, or a narrower path is required.

8. Never fake validation.
   - Do not say a command passed unless it was actually executed.

## Verification Rules

1. Run the smallest relevant validation you can.
   - Prefer targeted validation after a change: lints, unit tests, script tests, or a manual verification path tied to the changed entry point.
   - If environment or dependency limits prevent validation, say so explicitly.

2. Explain the validation path for business logic changes.
   - Cover the normal path and key edge cases.
   - For config, jobs, messaging, payment, or export flows, explain the affected scope clearly.
