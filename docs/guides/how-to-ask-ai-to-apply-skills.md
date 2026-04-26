# How To Ask AI To Apply Skills

Use short, explicit instructions with a concrete project path. Do not rely on the AI to discover the path by scanning.

## Recommended Prompts

Apply a shared project rule:

```text
把 karpathy 注入到项目：/absolute/path/to/project
```

Apply through the repository script:

```text
请使用 ai--code-rule-skill 仓库里的 apply-skill.sh，把 karpathy 注入到项目：/absolute/path/to/project
```

Install a Codex skill and also apply the project snippets:

```text
先导入 codex skill，再把 karpathy 注入到项目：/absolute/path/to/project
```

Let AI choose from the registry:

```text
读取 ai--code-rule-skill 的 skills/registry.md，帮我把合适的 skill 注入到项目：/absolute/path/to/project
```

## Best Practices

- Always provide an explicit absolute project path.
- Say whether you want `install`, `inject`, or both.
- If the project should not be scanned, say that directly.
- If a repository has existing governance files, prefer injection over regeneration.

## Expected AI Behavior

For this repository, AI should:

- read `skills/registry.md`
- use `scripts/apply-skill.sh` when possible
- avoid scanning for target paths
- report which files were updated or skipped
