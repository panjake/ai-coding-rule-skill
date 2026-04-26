# ai--code-rule-skill

Reusable AI coding rules, installable Codex skills, and small helper scripts.

可复用的 AI 编码规则仓库，面向 `Codex` 优先，同时兼容 `Cursor`、`Gemini`、IDE 工作流里的规则复用与项目注入。

## What This Repo Is

This repository is for teams or individuals who want:

- clearer AI coding boundaries
- less overengineering and fewer hidden assumptions
- reusable project rules instead of repeating prompts
- installable Codex skills plus tool-agnostic snippets
- helper scripts that inject rules into real repositories

这个仓库的定位不是“大而全提示词集合”，而是：

- 把真正高频、稳定、有边界感的规则沉淀下来
- 能装进 Codex 的，做成 skill
- 不能直接装的，做成 snippet 或 script
- 让 AI 在新项目里也能按统一方式落规则

## Current Focus

The first packaged asset is `karpathy-guidelines`:

- Codex skill for behavior guidance
- shared snippets for `AGENTS.md` and `.agents/common/rules.md`
- injection scripts for explicit project paths

当前第一批内容围绕 `Karpathy-style coding guidelines`，重点解决：

- 不要脑补需求
- 不要过度设计
- 改动要外科手术式
- 先定义成功标准，再说完成

## Repository Layout

```text
docs/
  concepts/       Background ideas and rationale
  guides/         How to use rules, skills, and scripts
  snippets/       Small copy-paste references
skills/
  codex/          Installable Codex skills
  shared/         Cross-tool snippets and rule blocks
  registry.md     Registry of supported skills and entrypoints
scripts/          Injection / apply helpers
examples/         Minimal demo targets for verification
```

## Quick Start

### 1. Install the Codex skill

```text
$skill-installer install https://github.com/panjake/ai--code-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

After installation, restart Codex to load the new skill.

### 2. Inject shared rules into a project

```bash
./scripts/apply-karpathy.sh /absolute/path/to/project
```

Or use the unified entrypoint:

```bash
./scripts/apply-skill.sh karpathy /absolute/path/to/project
```

## How To Ask AI

Recommended prompt:

```text
请使用 ai--code-rule-skill 仓库里的 apply-skill.sh，把 karpathy 注入到项目：/absolute/path/to/project
```

More examples are in:

- [How To Ask AI To Apply Skills](docs/guides/how-to-ask-ai-to-apply-skills.md)
- [Karpathy Quickstart](docs/guides/karpathy-quickstart.md)
- [Skill Registry](skills/registry.md)

## Current Assets

- [`skills/codex/karpathy-guidelines/`](skills/codex/karpathy-guidelines/SKILL.md)
  Installable Codex skill.
- [`skills/shared/karpathy/`](skills/shared/karpathy)
  Shared snippets for project-level persistence.
- [`scripts/apply-karpathy.sh`](scripts/apply-karpathy.sh)
  Direct Karpathy injection script.
- [`scripts/apply-skill.sh`](scripts/apply-skill.sh)
  Unified skill application entrypoint.

## Design Principles

- Explicit path in, no directory scanning by default
- Minimal changes, no surprise repo rewrites
- Shared rules first, tool-specific packaging second
- Idempotent scripts where possible
- Human-readable docs before automation sprawl

## Publishing Notes

- License: [MIT](LICENSE)
- Initial release notes: [RELEASE.md](RELEASE.md)

## Roadmap

- add more reusable coding rule packs
- support more shared rule injectors
- improve cross-tool usage docs for Codex, Cursor, and Gemini-based IDE flows
- add lightweight validation helpers for repository rule adoption
