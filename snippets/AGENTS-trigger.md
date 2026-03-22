## 项目（必须）

每次对话的**第一条消息**必须：读取 `ACTIVE-PROJECT.md`。
- 如果存在激活项目：读取 `projects/PROJECT-RULES.md`，然后读取项目的 `PROJECT.md`。遵循 PROJECT-RULES.md 中的所有规则。
- 如果没有激活项目或文件为空/缺失：正常工作，无需项目上下文。

命令 — 在执行前始终先读取 `projects/PROJECT-RULES.md`：
- "Project: [名称]" → 激活项目
- "End project" → 停用项目
- "Projects" → 显示项目概览
- "New project: [名称]" → 创建新项目

只有明确的用户命令可以修改 ACTIVE-PROJECT.md。切勿通过 cron、子智能体或其他自动化自动修改。
