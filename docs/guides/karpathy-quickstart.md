# Karpathy Quickstart

## Install As A Codex Skill

Use Codex `skill-installer` with the `skills/codex/karpathy-guidelines` path from this repository.

## Apply As Shared Project Rules

Use [`scripts/apply-karpathy.sh`](../../scripts/apply-karpathy.sh) with an explicit project path:

```bash
./scripts/apply-karpathy.sh /path/to/project
```

Or use the unified entrypoint:

```bash
./scripts/apply-skill.sh karpathy /path/to/project
```

The script:

- updates `AGENTS.md` when present
- updates `.agents/common/rules.md` when present
- skips repeated application
- does not scan or create governance files

## Recommended Use

- Use the Codex skill for session-level behavior guidance.
- Use the shared snippets for repository-level persistence.
- Use the script when you want repeatable project bootstrapping.
