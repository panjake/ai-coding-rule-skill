# ai-coding-rule-skill 中文说明

这是一套可复用的 AI 编码规则、项目地图模板和开发记忆工作流。

目标不是“收集提示词”，而是把模型更容易执行的规则、脚本和落盘动作固定下来。

## 最短使用路径

只记住两条主命令就够了。

安装 Codex skill：

```text
$skill-installer install https://github.com/panjake/ai-coding-rule-skill/tree/main/skills/codex/karpathy-guidelines
```

初始化一个新项目：

```bash
./scripts/init-project.sh /path/to/project jake
```

安装 skill 后，重启 Codex 才会生效。

`init-project.sh` 只会新增治理和记忆文件，不会改业务代码，也不会破坏现有项目结构。

它会生成：

```text
AGENTS.md
.agents/common/rules.md
.agents/common/context.md
.agents/developers/jake/AGENTS.md
.agents/developers/jake/progress.md
.agents/developers/jake/bugs.md
.agents/developers/jake/sessions/
.agents/developers/jake/decisions/
.agents/developers/jake/templates/
```

## 这套仓库做什么

它主要固定 4 层东西：

1. 共享规则层
   约束模型如何确认身份、恢复上下文、控制范围、结束会话。
2. 项目地图层
   约束 `.agents/common/context.md` 怎么写，重点是导航，不是百科全书。
3. 开发记忆层
   把 `progress.md`、`bugs.md`、`sessions/`、`decisions/` 分层存放。
4. 执行脚本层
   用脚本真正落盘，而不是只靠模型口头总结。

## 日常怎么用

平时只需要记住 5 个东西：

- `AGENTS.md`
- `.agents/common/rules.md`
- `.agents/common/context.md`
- `.agents/developers/{developer}/progress.md`
- `scripts/close-session.sh`

更重的东西，比如模型适配器、黑盒验收、越界纠偏模板，只有在模型开始漂移时再用。

## 核心规则

这套仓库最重要的约束是：

1. 先确认 developer profile，再读个人目录。
2. 即使“身份确认 + 任务”在同一句里，也要先回显 profile 和读写边界。
3. 先恢复上下文，再做较大改动。
4. 非 trivial 工作先设计，再确认，最后 coding。
5. 先声明 write scope，不要静默扩大范围。
6. 会话结束前要真实写 `progress` / `session`，必要时写 `bugs` / `decisions`。
7. 长上下文开始影响质量时，先通知用户并征得同意，不要擅自切流程。

## 主要命令

初始化项目：

```bash
./scripts/init-project.sh /path/to/project jake
```

可选补充命令：

```bash
./scripts/bootstrap-developer.sh /path/to/project jake
./scripts/apply-skill.sh all /path/to/project
```

会话收尾时落盘：

```bash
./scripts/close-session.sh
```

## 推荐阅读顺序

- 英文入口：[README.md](README.md)
- 中文指南：[docs/guides/中文说明.md](docs/guides/中文说明.md)
- 日常使用：[docs/guides/daily-workflow.md](docs/guides/daily-workflow.md)
- 快速接入：[docs/guides/project-rules-quickstart.md](docs/guides/project-rules-quickstart.md)
- 模型验收：[docs/guides/validate-agent-workflow.md](docs/guides/validate-agent-workflow.md)
- 模型适配：[docs/model-adapters/README.md](docs/model-adapters/README.md)

## 适合什么时候用

适合这些场景：

- 你不想每个项目都重复解释 AI 协作规则
- 你希望不同模型共享同一套项目记忆结构
- 你希望 AI 结束会话时真的写进度，而不是只说“我记住了”
- 你希望在 Cursor、Codex、Claude、Qwen、Gemini 之间复用一套治理思路

如果你只想先跑起来，先执行上面的 3 条命令就够了。
