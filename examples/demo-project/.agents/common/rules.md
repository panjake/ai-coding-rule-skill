## Karpathy 准则 / Karpathy Guidelines

> Priority: 高于一般实现偏好、个人编码习惯和临时“顺手优化”冲动；低于用户明确指令、仓库安全边界和已确认的项目硬约束。
> For simple tasks, apply Karpathy guidelines directly; for complex or cross-module tasks, apply them together with the design-doc requirement below.

1. 先澄清，再动手。 / Think before coding.
   - 需求存在歧义时，不得 silently 选一种解释直接实现。
   - 必须先说明假设；如果关键前提不明确，应先确认再改。
   - 如果存在两个以上合理方向，先给出选项、差异和推荐方案，不要偷偷替用户做决定。

2. 简单优先。 / Simplicity first.
   - 默认选择最直接、最少代码、最少影响面的方案。
   - 不为“未来可能需要”提前设计抽象、扩展点、配置开关。
   - 不为不现实的异常路径补复杂防御逻辑。
   - 如果实现复杂度明显高于问题本身，应主动回退并简化。

3. 改动必须外科手术式。 / Make surgical changes.
   - 每一处改动都应能直接追溯到当前需求。
   - 不顺手重构、不顺手格式化、不顺手改命名，不扩大改动面。
   - 只清理本次改动直接造成的无用 import、变量、分支或死代码。

4. 不隐藏不确定性。 / Do not hide confusion.
   - 不假装理解了其实没理解的业务语义。
   - 遇到命名混乱、历史逻辑矛盾、上下游约束不清时，先暴露疑点，再决定是否继续。
   - 如果当前信息不足以安全修改核心逻辑，应暂停实现，先补上下文。

5. 先定义成功，再宣称完成。 / Define success criteria and verify.
   - 修改前先明确“什么结果算完成”。
   - Bug 修复优先先构造复现方式，再验证修复结果。
   - 行为变更优先补充针对性测试、验证步骤或最小可重复检查。
   - 未实际执行的验证，不得写成“已通过”。

# Demo Rules

This file exists only as a minimal target for testing snippet injection.
