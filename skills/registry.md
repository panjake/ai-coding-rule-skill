# Skill Registry

This file maps reusable repository assets to their install or injection entrypoints.

## karpathy

- Purpose:
  Reduce overengineering, hidden assumptions, and oversized edits.
- Source:
  Based on `forrestchang/andrej-karpathy-skills`
  - https://github.com/forrestchang/andrej-karpathy-skills
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
  Updates or creates `AGENTS.md` and `.agents/common/rules.md`. In this repository, the Karpathy base layer is kept as the highest-priority rule layer, with onboarding and governance extensions appended around it.

## context

- Purpose:
  Create or extend the shared project map used during AI onboarding.
- Shared snippet:
  - `skills/shared/context/context-snippet.md`
- Apply script:
  `scripts/apply-context.sh`
- Unified command:
  `./scripts/apply-skill.sh context /absolute/path/to/project`
- Notes:
  Creates or updates `.agents/common/context.md`, preserving project-specific content below the shared guidance snippet. This is a repository-specific extension layer, not part of the original Karpathy source repository.

## all

- Purpose:
  Apply all currently supported shared repository assets in one pass.
- Unified command:
  `./scripts/apply-skill.sh all /absolute/path/to/project`
- Notes:
  Currently applies `karpathy` and `context`.

## developer-bootstrap

- Purpose:
  Initialize `.agents/developers/{developer}/` with standard progress, bugs, sessions, decisions, and template files.
- Apply script:
  `scripts/bootstrap-developer.sh`
- Unified command:
  `./scripts/bootstrap-developer.sh /absolute/path/to/project <developer-profile>`
- Notes:
  Creates the developer scaffold without overwriting existing files.

## init-project

- Purpose:
  Initialize project-level governance files and one developer scaffold in one step.
- Apply script:
  `scripts/init-project.sh`
- Unified command:
  `./scripts/init-project.sh /absolute/path/to/project <developer-profile> [manager-profile]`
- Notes:
  Runs `all` first, then `bootstrap-developer`, so a new project gets AGENTS, common rules, context, and one explicit developer directory.

## session-close-protocol

- Purpose:
  Make progress recording part of the normal completion workflow so agents leave fresh handoff state after meaningful work.
- Where:
  - `skills/shared/karpathy/AGENTS-snippet.md`
  - `skills/shared/karpathy/rules-snippet.md`
  - `skills/shared/developer-bootstrap/progress-template.md`
  - `skills/shared/developer-bootstrap/session-template.md`
- Notes:
  Before the final substantial response of a work session, update `.agents/developers/{developer}/progress.md`, update `bugs.md` when needed, and add a short session note when the session leaves blockers, risks, or resume context.

## memory-workflow-scripts

- Purpose:
  Provide explicit file-writing commands so progress, sessions, bugs, and decisions are actually persisted instead of relying only on prompt compliance.
- Scripts:
  - `scripts/update-progress.sh`
  - `scripts/append-session.sh`
  - `scripts/append-bug.sh`
  - `scripts/append-decision.sh`
  - `scripts/close-session.sh`
- Notes:
  Use `close-session.sh` as the default end-of-session entrypoint. Use the individual scripts when you only need to update one memory layer.

## model-adapters

- Purpose:
  Keep one shared rule layer while adding short model-specific execution prompts and validation prompts for mainstream coding models.
- Where:
  - `docs/model-adapters/cursor.md`
  - `docs/model-adapters/qwen.md`
  - `docs/model-adapters/codex.md`
  - `docs/model-adapters/claude.md`
  - `docs/model-adapters/gemini.md`
- Notes:
  Use adapters to reduce model-specific drift such as skipping session writes, over-summarizing without file writes, under-weighting workflow rules, or coding before design confirmation.
