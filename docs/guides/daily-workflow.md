# Daily Workflow

This guide describes the default day-to-day usage path.

Use this when you want the system to stay helpful without feeling heavy.

Do not start with every adapter, every validation prompt, and every escalation rule.

Start with the smallest workflow that keeps context stable.

## The Default Daily Set

For normal daily work, you usually need only these pieces:

1. `AGENTS.md`
2. `.agents/common/rules.md`
3. `.agents/common/context.md`
4. `.agents/developers/{developer}/progress.md`
5. `scripts/close-session.sh`

Everything else is an upgrade path, not the default starting point.

## Daily Flow

### 1. Initialize once

For a new project, run:

```bash
./scripts/init-project.sh /path/to/project jake
```

This gives you:

- project-level onboarding rules
- common rules
- a project map scaffold
- one developer memory directory

### 2. Confirm identity first

At the start of a work session:

- confirm the developer profile
- restate the write boundary
- only then read personal memory

If identity and task appear in the same message, still do identity echo first.

### 3. Recover only the core memory

For normal work, read:

1. `AGENTS.md`
2. `.agents/common/rules.md`
3. `.agents/common/context.md`
4. `.agents/developers/{developer}/AGENTS.md`
5. `.agents/developers/{developer}/progress.md`
6. `.agents/developers/{developer}/bugs.md`
7. recent session notes if needed

You do not need to read every old session file every time.

### 4. Work with narrow scope by default

For most daily tasks:

- keep changes small
- declare scope before non-trivial implementation
- do not widen the task without approval

If the task is simple and local, you usually do not need a long design step.
If the task is non-trivial, use the design-then-confirm protocol.

### 5. Close the session properly

At the end of meaningful work, prefer:

```bash
./scripts/close-session.sh /path/to/project jake ...
```

This is the main daily persistence action.

If you skip this, the system starts to feel unreliable because the next session loses continuity.

## When To Stay In Daily Mode

Stay in daily mode when:

- the task is straightforward
- the file scope is small
- the model is following rules normally
- the session is not showing context drift

In this mode, do not overuse:

- model adapters
- black-box validation prompts
- scope-violation recovery templates
- long-context escalation prompts

Those are for troubleshooting, not for every routine task.

## When To Upgrade Beyond Daily Mode

Upgrade from daily mode only when you see a real problem.

### Use model adapters when:

- one model repeatedly skips identity echo
- one model keeps widening scope
- one model summarizes without real file writes
- one model ignores session-close steps

See:

- [Model Adapters](../model-adapters/README.md)

### Use black-box validation when:

- you are evaluating a new model
- a model keeps violating the workflow
- you want proof that recovery / scope / handoff rules really work

See:

- [Validate Agent Workflow](validate-agent-workflow.md)

### Use long-context escalation when:

- recovery quality is clearly degrading
- scope control is drifting
- the model starts forgetting earlier constraints

This is not automatic.
The model should first notify the user, ask for approval, and warn not to close the current session when continuity depends on it.

## Practical Recommendation

If you want the system to feel light in daily use, think of it like this:

- daily mode:
  onboarding + rules + context + progress + close-session
- escalation mode:
  adapters + validation + correction prompts

The repository is not too heavy if you keep those two modes separate in practice.

It only feels heavy when escalation tools are treated like the default path.
