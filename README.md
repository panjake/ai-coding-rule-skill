# ai-coding-rule-skill

Reusable AI coding rules, installable Codex skills, and execution-first helper scripts.

可复用的 AI 编码规则仓库，目标不是“收集提示词”，而是把模型更容易执行的规则、脚本和工作流固定下来。

## What This Repo Is

Use this repository when you want:

- clearer AI coding boundaries
- less overengineering and fewer hidden assumptions
- reusable project rules instead of repeating prompts
- installable Codex skills plus tool-agnostic snippets
- helper scripts that inject rules and persist memory in real repositories

Do not treat this repository as a long prompt library.

Treat it as:

- one shared rule layer
- one shared project-map layer
- one developer-memory workflow
- one small model-adapter layer for execution drift

## Execution Model

Keep the layers explicit:

- `karpathy`:
  high-priority coding behavior layer
- `context`:
  navigation-first project map layer
- developer memory:
  `progress.md`, `bugs.md`, `sessions/`, `decisions/`
- workflow scripts:
  explicit file-writing actions for memory persistence
- model adapters:
  short prompts for Cursor, Qwen, Codex, Claude, and Gemini

The `karpathy` base layer comes from:

- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

In this repository:

- keep Karpathy as the highest-priority coding behavior layer
- add project onboarding and governance around it
- add explicit workflow scripts where prompt compliance alone is not reliable

## Language Strategy

Use language intentionally instead of forcing the whole repository into one language.

- Pure execution protocols, structured memory templates, and model-facing rule blocks should prefer English.
- Human-facing explanation, rollout notes, and example prompts may stay Chinese or mixed Chinese and English when that is easier for the repository owner.
- If a section is primarily for model execution, optimize for instruction clarity instead of natural prose.

## Runtime Goals

The repository is working if the model reliably does these things:

- reads the right files in the right order
- still echoes identity first when identity and task appear in the same message
- reports recovery before larger changes
- declares write scope before non-trivial implementation
- pauses between design and coding when confirmation is required
- keeps code changes minimal and verifiable
- writes memory files instead of only summarizing
- asks for approval before long-context recovery escalation
- leaves the next session with enough state to resume safely

## Repository Layout

```text
docs/
  concepts/       Background ideas and rationale
  guides/         How to use rules, skills, and scripts
  model-adapters/ Short model-specific execution prompts
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

Use Codex `skill-installer` to install the skill from this repository path:

```text
https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

Example:

```text
$skill-installer install https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

After installation, restart Codex to load the new skill.

### 2. Inject shared rules into a project

```bash
./scripts/apply-karpathy.sh /absolute/path/to/project
./scripts/apply-karpathy.sh /absolute/path/to/project jake
```

Or use the unified entrypoint:

```bash
./scripts/apply-skill.sh karpathy /absolute/path/to/project
./scripts/apply-skill.sh karpathy /absolute/path/to/project jake
```

### 3. Inject project-map context into a project

```bash
./scripts/apply-context.sh /absolute/path/to/project
```

Or through the unified entrypoint:

```bash
./scripts/apply-skill.sh context /absolute/path/to/project
./scripts/apply-skill.sh all /absolute/path/to/project
```

### 4. Initialize one developer profile

```bash
./scripts/bootstrap-developer.sh /absolute/path/to/project jake
```

Developer profiles are stored under `.agents/developers/{developer}/`.
Allowed profile characters are lowercase letters, digits, and hyphens.
Reserved names such as `common`, `templates`, `proposals`, `developers`, `system`, and `shared` are rejected.

### 5. Initialize a project in one command

```bash
./scripts/init-project.sh /absolute/path/to/project jake
./scripts/init-project.sh /absolute/path/to/project alice jake
```

The second form means:

- initialize the developer scaffold for `alice`
- render project-level governance examples with `jake` as the project manager

### 6. Expected onboarding response

After a model reads:

- `AGENTS.md`
- `.agents/common/rules.md`
- `.agents/common/context.md`
- `.agents/developers/{developer}/AGENTS.md`
- `.agents/developers/{developer}/progress.md`
- `.agents/developers/{developer}/bugs.md`
- recent `.agents/developers/{developer}/sessions/`

it should explicitly report:

- current developer profile
- write boundary
- which files were read
- project map summary
- current progress
- known risks
- blockers
- next recommended action

Do not accept “I have context” without this explicit recovery output.

If identity confirmation and a task arrive in the same message, the model should still:

- echo the active developer profile first
- echo the write boundary second
- only then continue into recovery or task execution

### 7. Expected session-close behavior

After meaningful work, the model should treat personal memory updates as part of completion.

Before the final substantial response of a session, it should normally:

- update `.agents/developers/{developer}/progress.md`
- update `.agents/developers/{developer}/bugs.md` if a new confirmed problem or risk appeared
- add a short note under `.agents/developers/{developer}/sessions/` when the work left blockers, decisions, or resume context

This repository does not rely on a background daemon.
It relies on:

- shared rules
- explicit workflow scripts
- recovery checks
- session-close checks

### 8. Expected non-trivial workflow behavior

For non-trivial work, the default protocol is:

1. design first
2. ask for confirmation when the approach changes scope, changes production code, or has non-obvious tradeoffs
3. declare expected write scope
4. code only after confirmation

If the real write scope grows beyond the declared scope, stop and confirm again.

### 9. Memory workflow scripts

When prompt compliance alone is not reliable, use:

- `./scripts/update-progress.sh`
- `./scripts/append-session.sh`
- `./scripts/append-bug.sh`
- `./scripts/append-decision.sh`
- `./scripts/close-session.sh`

Recommended close-session prompt:

```text
Before ending this work session, call close-session.sh to update jake's progress and session note, and also write bugs or decisions if new ones were confirmed.
```

Recommended long-context escalation rule:

```text
If context pressure starts degrading recovery quality or scope control, do not silently switch workflow. First notify the user, ask for approval, and if continuity depends on this session, explicitly warn them not to close it yet.
```

## How To Ask AI

Recommended prompt:

```text
请使用 ai-coding-rule-skill 仓库里的 apply-skill.sh，把 karpathy 注入到项目：/absolute/path/to/project
```

Developer bootstrap prompt:

```text
Use bootstrap-developer.sh from ai-coding-rule-skill to initialize the developer directory in /absolute/path/to/project with the jake profile.
```

Project init prompt:

```text
Use init-project.sh from ai-coding-rule-skill to initialize project rules and the developer directory in /absolute/path/to/project with the jake profile.
```

Recovery-summary prompt:

```text
After reading AGENTS.md, .agents/common/, and jake's personal memory, first report the current profile, write boundary, files read, and recovery summary before making changes.
```

More execution-oriented references are in:

- [中文说明](docs/guides/中文说明.md)
- [Daily Workflow](docs/guides/daily-workflow.md)
- [How To Ask AI To Apply Skills](docs/guides/how-to-ask-ai-to-apply-skills.md)
- [Project Rules Quickstart](docs/guides/project-rules-quickstart.md)
- [Validate Agent Workflow](docs/guides/validate-agent-workflow.md)
- [Model Adapters](docs/model-adapters/README.md)
- [Skill Registry](skills/registry.md)

## Main Assets

- [`skills/codex/karpathy-guidelines/`](skills/codex/karpathy-guidelines/SKILL.md)
  Installable Codex skill. Based on the original Karpathy-style rules from `forrestchang/andrej-karpathy-skills`.
- [`skills/shared/karpathy/`](skills/shared/karpathy)
  Shared snippets for project-level persistence. Includes the Karpathy base layer plus this repository's governance extensions.
- [`skills/shared/context/`](skills/shared/context)
  Shared snippet for project-map persistence. This is an extension layer, not part of the original Karpathy source.
- [`scripts/apply-karpathy.sh`](scripts/apply-karpathy.sh)
  Direct Karpathy injection script.
- [`scripts/apply-context.sh`](scripts/apply-context.sh)
  Direct project-map injection script.
- [`scripts/apply-skill.sh`](scripts/apply-skill.sh)
  Unified skill application entrypoint.
- [`scripts/bootstrap-developer.sh`](scripts/bootstrap-developer.sh)
  Standard developer-profile scaffold initializer.
- [`scripts/init-project.sh`](scripts/init-project.sh)
  One-shot project initializer for common files plus developer scaffold.
- [`scripts/update-progress.sh`](scripts/update-progress.sh)
  Structured progress writer for `.agents/developers/{developer}/progress.md`.
- [`scripts/append-session.sh`](scripts/append-session.sh)
  Session-note writer for `.agents/developers/{developer}/sessions/`.
- [`scripts/append-bug.sh`](scripts/append-bug.sh)
  Bug and risk recorder for `.agents/developers/{developer}/bugs.md`.
- [`scripts/append-decision.sh`](scripts/append-decision.sh)
  Decision-record writer for `.agents/developers/{developer}/decisions/`.
- [`scripts/close-session.sh`](scripts/close-session.sh)
  Unified session-close workflow for progress, sessions, bugs, and decisions.

## Design Principles

- Explicit path in, no directory scanning by default
- Minimal changes, no surprise repo rewrites
- Shared rules first, tool-specific packaging second
- Keep source layers explicit: preserve the Karpathy base rules, then add project-governance, memory, and adapter layers separately
- Idempotent scripts where possible
- Prefer execution protocols over long explanations

## Publishing Notes

- License: [MIT](LICENSE)
- Initial release notes: [RELEASE.md](RELEASE.md)

## Roadmap

- add more reusable coding rule packs
- support more shared rule injectors
- improve cross-tool usage docs for Codex, Cursor, and Gemini-based IDE flows
- add lightweight validation helpers for repository rule adoption
