# Model Adapters

Use these files when the shared rules are not enough to produce stable execution behavior.

Do not fork the core rules per model.

Keep one shared rule layer, then add a small model adapter layer for:

- common failure patterns
- stronger execution prompts
- short recovery checks
- short session-close checks
- design-then-confirm checks for non-trivial work
- test-only boundary checks for narrow-scope requests

Each adapter should help the model:

1. read the right files
2. report recovery clearly
3. call workflow scripts instead of only summarizing
4. prove which files were actually written
5. pause between design and coding when confirmation is required
6. avoid widening a narrow request without explicit approval

For a reusable black-box verification flow, see:

- [Validate Agent Workflow](../guides/validate-agent-workflow.md)

For a reusable Chinese prompt that handles long-context pressure safely, see:

- [How To Ask AI To Apply Skills](../guides/how-to-ask-ai-to-apply-skills.md)

That guide also contains a reusable Chinese scope-violation correction prompt.
