# Skill Registry

This file maps reusable repository assets to their install or injection entrypoints.

## karpathy

- Purpose:
  Reduce overengineering, hidden assumptions, and oversized edits.
- Codex skill:
  `skills/codex/karpathy-guidelines/`
- Shared snippets:
  - `skills/shared/karpathy/AGENTS-snippet.md`
  - `skills/shared/karpathy/rules-snippet.md`
- Apply script:
  `scripts/apply-karpathy.sh`
- Unified command:
  `./scripts/apply-skill.sh karpathy /absolute/path/to/project`
- Notes:
  Updates existing `AGENTS.md` and `.agents/common/rules.md` only.
