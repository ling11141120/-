# AI 赋能效率占比 — CHANGELOG 规范

## 目标

通过 `CHANGELOG.md` 记录每个需求的 AI/人工开发占比，
最终在 master 分支按成员、按周期统计「AI 赋能效率占比」。

## 整体流程

```
dev 分支 (CHANGELOG.md，记录本条需求) 
    ↓ MR 合并，追加内容
stage 分支 (CHANGELOG.md，累计多个需求) 
    ↓ MR 合并，整体合入
master 分支 (CHANGELOG.md，最终累计)
    ↓ 发给 AI 分析
AI 赋能效率占比报表
```

## CHANGELOG.md 格式

每个分支在仓库根目录维护一个 `CHANGELOG.md`，格式如下：

```markdown
# 变更日志 (Changelog)

---
## {分支名} | 负责人: {中文名/英文名} | 周期: {开始日期} ~ {结束日期}

### YYYY-MM-DD
- [AI] {具体做了什么}
- [人工] {具体做了什么}
- [AI] {具体做了什么}

### YYYY-MM-DD
- [AI] {具体做了什么}
- [人工] {具体做了什么}

---
## {下一个分支的 section，合并时追加}
```

### 条目规则

| 规则 | 说明 |
|------|------|
| 标签 | 每条以 `- [AI]` 或 `- [人工]` 开头，方括号+大写，一个条目一个标签 |
| 粒度 | 以"可独立交付的单元"为粒度（如：写 DDL、写 DML、数据验证、口径确认）；不要拆太细 |
| 描述 | 写清楚做了什么，对事不对人（如 "编写 DML 数据加载脚本" 而非 "我写了 DML"） |
| 归属 | 如果一条工作 AI 和人都有大量参与，拆成两条分别标记；少量辅助不单独记 |
| 不确定 | 不确定归属时标记为 `[人工]` |

### 条目示例

```markdown
### 2026-05-10
- [AI] 扫描上游 ODS 表结构，生成 DWD 层 DDL 建表语句
- [人工] 确认字段映射关系和业务口径
- [AI] 根据字段映射编写 DWD 层 DML 数据加载脚本
- [AI] 改造下游 3 个 ADS/DWS 的 DML 文件，适配新字段
- [人工] 编写数据验证 SQL，对比新旧口径数据量级
- [人工] 数据验证通过，确认可以提交 MR
```

## 合并规则

### dev → stage

当 dev 分支通过 MR 合并到 stage 时：

1. **冲突处理**：`CHANGELOG.md` 必然冲突，手动解决
2. **解决方式**：将 dev 分支的整个 `## {分支名}` section **追加**到 stage 的 `CHANGELOG.md` 末尾
3. **不修改**：不要修改 stage 上已有的其他 section
4. **分隔符**：每个 section 之间用 `---` 分隔线隔开

操作步骤：
```bash
git checkout stage
git merge dev+xxx
# CHANGELOG.md 冲突
# 手动编辑：把 dev 的 section 追加到 stage CHANGELOG.md 末尾
git add CHANGELOG.md
git commit -m "chore: 合并 dev+xxx 的 CHANGELOG"
```

### stage → master

当 stage 通过 MR 合并到 master 时：

1. 同样会有 `CHANGELOG.md` 冲突
2. **解决方式**：将 stage 的 `CHANGELOG.md` 整体合入 master（因为 master 上之前的内容应该和 stage 在分叉前一致）
3. 如果 master 和 stage 的 CHANGELOG.md 完全一致（正常情况），则无冲突

## 初始化

### dev 分支初始化

从 master 拉出 dev 分支时，`CHANGELOG.md` 为空（或只有 master 上已有的累计内容）。开发者在开发过程中持续更新。

如果在 dev 分支创建时 master 上已有历史 CHANGELOG.md（之前的需求记录），则 dev 分支继承该文件，在文件末尾追加自己的 section。

### stage / master 初始化

在 stage 和 master 分支上创建一个空的 `CHANGELOG.md`：

```markdown
# 变更日志 (Changelog)

> 本文件记录所有需求的 AI/人工开发占比。
> 每个 `## {分支名}` section 对应一个需求分支的完整开发记录。
> 格式规范详见 `orchestrator/ALWAYS/CHANGELOG-SPEC.md`。

```

## 分析统计方法

将 master 分支的 `CHANGELOG.md` 发给 AI，给定如下 prompt：

```
分析这个 CHANGELOG.md，统计以下指标：

1. 按成员统计：每个成员（按 section 中的"负责人"字段分组）的 AI 条目数 / 总条目数
2. 按时间周期统计：指定周期内（如 2026 年 Q1）的 AI 条目数 / 总条目数
3. 按成员+周期交叉统计：每个成员在指定周期内的 AI 占比

输出格式：
| 成员 | 总条目 | AI 条目 | 人工条目 | AI 占比 |
```

**注意**：统计的是**条目数**（即 `- [AI]` 和 `- [人工]` 的行数），不是字符数或 commit 数。

## 文件位置

- 规范文档：`orchestrator/ALWAYS/CHANGELOG-SPEC.md`（本文件）
- 各分支 CHANGELOG.md：仓库根目录 `CHANGELOG.md`
