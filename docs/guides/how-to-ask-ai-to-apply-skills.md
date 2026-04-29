# How To Ask AI To Apply Skills

Use short, explicit instructions with a concrete project path.
Do not rely on the AI to discover the path by scanning.
Prefer commands the model can execute over prose the model must reinterpret.

协议块优先让模型更容易执行；面向人的说明和示例 prompt 可以继续使用中文或中英混合。

## Recommended Prompts

Apply a shared project rule:

```text
把 karpathy 注入到项目：/absolute/path/to/project
```

Apply through the repository script:

```text
请使用 ai-coding-rule-skill 仓库里的 apply-skill.sh，把 karpathy 注入到项目：/absolute/path/to/project
```

Apply shared project-map context:

```text
请使用 ai-coding-rule-skill 仓库里的 apply-skill.sh，把 context 导入到项目：/absolute/path/to/project
```

Install a Codex skill and also apply the project snippets:

```text
先导入 codex skill，再把 karpathy 注入到项目：/absolute/path/to/project
```

Apply everything currently supported:

```text
请使用 ai-coding-rule-skill 仓库里的 apply-skill.sh，把 all 导入到项目：/absolute/path/to/project
```

Initialize one developer profile explicitly:

```text
Use bootstrap-developer.sh from ai-coding-rule-skill to initialize the developer directory in /absolute/path/to/project with the jake profile.
```

Initialize the whole project in one step:

```text
Use init-project.sh from ai-coding-rule-skill to initialize project rules and the developer directory in /absolute/path/to/project with the jake profile.
```

Apply shared assets and initialize the developer profile in one session:

```text
先把 all 导入到项目：/absolute/path/to/project，再用 jake 身份初始化开发者目录
```

Ask the AI to prove that onboarding rules were actually followed:

```text
After reading AGENTS.md, .agents/common/, and jake's personal memory, first report the current profile, write boundary, files read, and recovery summary before making changes.
```

When identity confirmation and a task are combined in one sentence, force identity-first behavior:

```text
使用 jake 身份，并生成项目地图。

先不要直接开始任务。
先只输出：
1. 当前 developer profile
2. 当前读写边界
3. 你接下来会先读取哪些共享文件和个人记忆文件

完成这一步后，再继续项目地图初始化。
```

Ask the AI to close the session with progress updates:

```text
完成本轮工作前，先更新 .agents/developers/jake/progress.md、必要时更新 bugs.md 和 sessions/，再输出最终总结
```

Ask the AI to use the workflow script directly:

```text
Before ending this work session, call close-session.sh from ai-coding-rule-skill to write jake's progress and session note, and also update bugs and decisions if new ones were confirmed.
```

Ask the AI to handle long-context pressure correctly:

```text
如果你觉得当前上下文已经过长，并开始影响恢复质量、范围控制或规则执行，不要自行切换策略，也不要直接让我重开会话。

先只回答：
1. 你观察到的质量风险是什么
2. 你建议的恢复动作是什么
3. 为什么这一步必须先征得我同意
4. 当前会话是否必须保持打开，才能完整恢复之前的记忆

如果当前会话必须保持打开，请明确提醒我：先不要关闭当前会话。

在我明确同意前，不要切换到新的恢复流程。
```

Ask the AI to recover correctly after crossing scope:

```text
你已经超出了我批准的范围。

不要先长篇解释技术原因，也不要继续实现。
先只回答：
1. 我原始批准的请求是什么
2. 你实际扩大的范围是什么
3. 为什么这个扩大是越界的
4. 现在开始最小合规方案是什么
5. 如果要继续走更大方案，还需要我额外批准什么

如果需要我决定回滚、改写还是接受更大范围，请停在这里等我确认。
```

Let AI choose from the registry:

```text
读取 ai-coding-rule-skill 的 skills/registry.md，帮我把合适的 skill 注入到项目：/absolute/path/to/project
```

## Best Practices

- Always provide an explicit absolute project path.
- Say whether you want `install`, `inject`, or both.
- When developer memory is involved, provide the explicit developer profile, for example `jake`.
- If the project should not be scanned, say that directly.
- If a repository has existing governance files, prefer injection over regeneration.
- When you need persistence, say which script must be called.
- When you need proof, require the final response to list the actual written file paths.

## Expected AI Behavior

For this repository, AI should:

- read `skills/registry.md`
- use `scripts/apply-skill.sh` when possible
- use `scripts/bootstrap-developer.sh` when asked to initialize a developer profile
- use `scripts/init-project.sh` when asked to initialize both common governance files and the developer scaffold
- avoid scanning for target paths
- confirm the active developer profile and write boundary before touching personal memory
- report the recovery summary after reading context and before larger changes
- treat personal memory updates as part of completion, not optional cleanup
- update `progress.md` before the final substantial response of a work session
- prefer `close-session.sh` over manual end-of-session summaries when the script exists
- report which files were updated or skipped
