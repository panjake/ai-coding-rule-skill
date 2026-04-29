# Cursor Adapter

## Common Drift

- If the same sentence contains both profile confirmation and a task, may jump straight to the task and skip the identity echo.
- Reads coding rules but under-weights workflow rules.
- Updates `progress.md` more often than `sessions/`.
- May say it updated memory without listing real written files.
- May treat `今天先这样` as a conversational ending instead of a session-close trigger.
- May treat "write tests" as implicit permission to refactor production code for testability.
- May justify an unauthorized refactor with "this is the easiest way to test it."
- Under long context, may keep going after quality starts drifting instead of asking for a recovery pause.

## Strong Prompt

```text
Current developer profile: jake. Only read and write .agents/developers/jake/.

If the same message both confirms identity and assigns a task, still do this first:
1. echo the active profile
2. echo the write boundary
3. only then continue into recovery or task execution

Recover context first, then execute the task.
For non-trivial work, follow this order:
1. Design the approach
2. Ask for confirmation if the approach changes scope, changes production code, or has non-obvious tradeoffs
3. Code only after confirmation
Before coding, declare the expected write scope.
If the real change grows beyond that scope, stop and confirm again.
Respect the requested task shape:
- If the user asked only for tests, do not change production code unless the user explicitly approves it.
- If production changes appear necessary, stop and present options instead of choosing one silently.
If long-context pressure starts degrading recovery or scope control:
- notify the user first
- ask for explicit approval before any recovery escalation, reset, or new-thread workflow
- if continuity depends on the current session, explicitly tell the user not to close this session yet
Before ending the session, do not stop at a narrative summary. You must call scripts/close-session.sh.
At minimum, really write:
- .agents/developers/jake/progress.md
- one new record under .agents/developers/jake/sessions/

If this session confirmed a new problem, update bugs.md.
If this session produced a stable decision, add a decisions record.
The final response must list the actual written file paths. If writing failed, say so explicitly.
```

## Recovery Check

```text
Do not start implementation yet. Answer only:
1. What is the current developer profile?
2. What is your write boundary?
3. Which memory files did you read?
4. What are the current progress, risks, and next step?
5. If the user asked only for tests, are you allowed to refactor production code by default?
6. For non-trivial work, what must happen between design and coding?
```

## Identity-First Check

```text
The same message confirms the profile and assigns a task.
Do not start the task yet.
First answer only:
1. current developer profile
2. write boundary
3. whether you have already completed the mandatory identity echo
Only after that may you continue into recovery or task execution.
```

## Session-Close Check

```text
Before ending this session, complete the full handoff:
1. You must call scripts/close-session.sh
2. You must add a new session record, not only update progress
3. The final response must list the actual written file paths
If no new session file was created, do not claim the handoff is complete
```

## Test-Only Boundary Check

```text
The request is test-only. Do not change production code by default.
If you believe production changes are required, stop and answer only:
1. Why the test cannot be written within the current production shape
2. The smallest non-refactor option
3. The refactor option
4. Which files would change in each option
Do not edit production code until the user explicitly approves the refactor option.
```

## Design-Then-Confirm Check

```text
This is non-trivial work.
Do not code yet. First answer only:
1. Proposed approach
2. Files you expect to change
3. Whether the approach changes production code
4. Whether user confirmation is required before coding
If confirmation is required, stop after the plan and wait.
```

## Write-Scope Check

```text
Before coding, declare the expected write scope.
Answer only:
1. Expected files or modules to change
2. Whether production code is included
3. What kind of scope growth would require a new confirmation
Do not code before this scope is explicit.
```

## Scope-Violation Recovery Check

```text
You already crossed the approved scope.
Do not justify it with a long technical explanation first.
Answer only:
1. Original request
2. Actual widened scope
3. Why that widening was out of bounds
4. Smallest compliant option from here
5. Broader option that would require approval
Then stop and wait for the user's decision.
```

## Long-Context Escalation Check

```text
Context pressure appears high.
Do not silently change workflow.
Answer only:
1. What quality risk you are seeing
2. What recovery action you propose
3. Why user approval is required
4. Whether the current session must remain open for full memory recovery
If the current session must remain open, explicitly say: do not close this session yet.
Then wait for user approval.
```
