# KUNLUN-DOLPHINSCHEDULER 项目指令

## 项目本地 Skills

当当前工作区是 `kunlun-dolphinscheduler` 时，将 `AI/skills` 视为项目本地 skill 库。

对于此仓库中的任何用户请求：

1. 如果用户直接点名某个 skill，或者请求看起来匹配某个 skill 的 `description`，检查 `AI/skills/*/SKILL.md`。
2. 通过 YAML frontmatter 字段 `name` 和 `description` 匹配 skill。
3. 当匹配到项目本地 skill 时，先说明正在使用该项目本地 skill，然后读取它的 `SKILL.md` 并遵循其中的工作流程。
4. skill 中提到的相对路径，优先从该 skill 自身目录解析。
5. 只加载当前任务需要的被引用文件；不要批量加载 `AI/skills` 下的所有文件。
6. 如果多个项目本地 skill 匹配，使用满足需求的最小集合，并说明使用顺序。
7. 如果用户点名的项目本地 skill 缺失或格式不正确，简要说明，然后继续使用可用的最佳 fallback。

这些项目本地 skills 是对全局注册 Codex skills 的补充。它们可能不会出现在会话内置 skill 列表中，但仍应通过读取本地 `SKILL.md` 文件来使用。
