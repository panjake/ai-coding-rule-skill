# Release Notes

## v0.1.0 - Initial Public Skeleton

Initial repository bootstrap for reusable AI coding rules and Codex-first skills.

### Included

- `karpathy-guidelines` Codex skill
- shared Karpathy snippets for `AGENTS.md` and `.agents/common/rules.md`
- `apply-karpathy.sh` direct injector
- `apply-skill.sh` unified skill entrypoint
- registry-driven discovery entrypoint
- docs for AI prompting and project injection
- demo project for local verification

### Intended Use

- install Codex skills from this repo
- inject stable rule blocks into existing repositories
- reuse the same behavioral guidance across multiple AI coding environments

### Non-Goals For v0.1.0

- full multi-platform plugin packaging
- automatic project discovery
- automatic governance file generation
- large prompt collection without execution boundaries
