# Release Notes

## v0.2.0 - Project Bootstrap And Memory Workflow Upgrade

This release turns the repository from a small Karpathy-rule injector into a fuller project-governance bootstrap kit.

### Included

- shared `context` snippet and `apply-context.sh`
- `bootstrap-developer.sh` for developer memory scaffolding
- `init-project.sh` for one-command project initialization
- `.agents/developers/{developer}/` namespace for developer memory isolation
- developer profile validation with reserved-name protection
- stronger `AGENTS.md` and `.agents/common/rules.md` templates
- explicit recovery-summary response requirements
- session-close protocol for `progress.md`, `bugs.md`, and `sessions/`
- richer demo project example with developer memory scaffold
- integration tests for `apply-skill`, `bootstrap-developer`, and `init-project`

### Behavior Changes

- project-level shared files can now be created for empty projects
- developer scaffolds now live under `.agents/developers/{developer}/`
- progress recording is treated as part of normal completion workflow rather than optional cleanup
- examples and docs now reflect project bootstrap plus handoff workflow, not just snippet injection

### Intended Use

- initialize a new repository with `AGENTS.md`, shared rules, shared context, and one explicit developer profile
- inject stable governance snippets into existing repositories
- keep developer memory isolated while keeping shared project facts reusable
- make onboarding, recovery, and handoff behavior more consistent across AI sessions

### Upgrade Notes

- repositories using the older `.agents/{developer}/` layout should plan a follow-up migration to `.agents/developers/{developer}/`
- no background daemon was added for progress recording; the workflow is enforced through templates, prompts, and agent expectations

### Verification

- `sh tests/apply-skill-test.sh`
- `sh tests/bootstrap-developer-test.sh`
- `sh tests/init-project-test.sh`

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
