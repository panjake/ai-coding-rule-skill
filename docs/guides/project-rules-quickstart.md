# Project Rules Quickstart

## Fastest Path

Install the Codex skill:

```text
$skill-installer install https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

Initialize one project with common rules plus one developer profile:

```bash
./scripts/init-project.sh /path/to/project jake
```

These are the two main commands.
After skill installation, restart Codex to load the new skill.

`init-project.sh` only adds governance and memory files.
It does not rewrite application structure, move source code, or modify business logic.

It creates:

```text
AGENTS.md
.agents/common/rules.md
.agents/common/context.md
.agents/developers/{developer}/AGENTS.md
.agents/developers/{developer}/progress.md
.agents/developers/{developer}/bugs.md
.agents/developers/{developer}/sessions/
.agents/developers/{developer}/decisions/
.agents/developers/{developer}/templates/
```

This repository's `karpathy` layer is based on the original source:

- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

Here, `karpathy` is treated as the high-priority base rule layer. The AGENTS / rules / context structure in this repository is an extension built around that base.

## Install As A Codex Skill

Use Codex `skill-installer` to install the skill from this repository path:

```text
https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

Command:

```text
$skill-installer install https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

## Optional: Apply Shared Project Rules Separately

Use [`scripts/apply-karpathy.sh`](../../scripts/apply-karpathy.sh) with an explicit project path:

```bash
./scripts/apply-karpathy.sh /path/to/project
./scripts/apply-karpathy.sh /path/to/project jake
```

Or use the unified entrypoint:

```bash
./scripts/apply-skill.sh karpathy /path/to/project
./scripts/apply-skill.sh karpathy /path/to/project jake
```

The script:

- updates `AGENTS.md` when present
- updates `.agents/common/rules.md` when present
- skips repeated application
- does not scan or create governance files

## Apply Shared Project Map Context

Use [`scripts/apply-context.sh`](../../scripts/apply-context.sh) with an explicit project path:

```bash
./scripts/apply-context.sh /path/to/project
```

Or use the unified entrypoint:

```bash
./scripts/apply-skill.sh context /path/to/project
./scripts/apply-skill.sh all /path/to/project
```

The context script:

- creates `.agents/common/context.md` when missing
- prepends shared project-map guidance when the file already exists
- preserves any project-specific content below the shared guidance

## Initialize A Developer Profile

Use [`scripts/bootstrap-developer.sh`](../../scripts/bootstrap-developer.sh) to create one explicit developer scaffold:

```bash
./scripts/bootstrap-developer.sh /path/to/project jake
```

The scaffold is created under `.agents/developers/{developer}/`.
Use only lowercase letters, digits, and hyphens for the profile name.
Reserved names such as `common`, `templates`, `proposals`, `developers`, `system`, and `shared` are rejected.

The bootstrap script creates:

- `.agents/developers/jake/AGENTS.md`
- `.agents/developers/jake/progress.md`
- `.agents/developers/jake/bugs.md`
- `.agents/developers/jake/sessions/`
- `.agents/developers/jake/decisions/`
- `.agents/developers/jake/templates/`

It does not guess the developer name from git, file ownership, or previous sessions.

## Initialize A Project In One Command

Use [`scripts/init-project.sh`](../../scripts/init-project.sh) when you want common governance files and one developer scaffold together:

```bash
./scripts/init-project.sh /path/to/project jake
```

Or separate developer and manager names:

```bash
./scripts/init-project.sh /path/to/project alice jake
```

## Session Close Expectation

After meaningful work, the default workflow is:

- update `.agents/developers/{developer}/progress.md`
- update `.agents/developers/{developer}/bugs.md` when a new confirmed problem or risk appears
- add a short note under `.agents/developers/{developer}/sessions/` when the session leaves blockers or resume context
- then send the final substantial response

This repository does not rely on a background process for progress recording.
Instead, it makes progress updates part of the expected agent workflow.

If the repository includes the helper scripts, prefer them over manual edits:

- `scripts/update-progress.sh`
- `scripts/append-session.sh`
- `scripts/append-bug.sh`
- `scripts/append-decision.sh`
- `scripts/close-session.sh`

## Recommended Use

- Use the Codex skill for session-level behavior guidance.
- Use the shared snippets for repository-level persistence.
- Use [Daily Workflow](daily-workflow.md) as the normal day-to-day path.
- Use `all` when you want shared rules plus project-map guidance in one pass.
- Use `bootstrap-developer.sh` after the developer profile is explicitly confirmed.
- After reading AGENTS, common files, and developer memory, explicitly report the recovery summary before larger changes.
- If identity confirmation and task assignment arrive together, still echo profile and write boundary before starting the task.
- For non-trivial work, design first, ask for confirmation second, declare write scope third, and code only after confirmation.
- If context pressure starts degrading quality, ask for approval before any recovery escalation and warn the user not to close the current session when continuity depends on it.
- Use [Validate Agent Workflow](validate-agent-workflow.md) when you need a black-box check for whether the model is actually following recovery, scope, and session-close rules.
