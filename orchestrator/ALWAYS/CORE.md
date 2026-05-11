# 核心工作协议

## Plan 确认流程

Program 创建后、代码开发前，**必须**先进入 Plan 模式与用户对话，确认以下内容后方可落盘并开始编码：

### 对话确认清单

| 序号 | 确认项 | 说明 |
|------|--------|------|
| 1 | 需求理解 | 用一句话复述用户需求，确认理解一致 |
| 2 | 目标层级 | 新表/修改表属于哪个分层（ods/dwd/dws/ads/dim） |
| 3 | 业务域 | 归属于哪个业务域 |
| 4 | 表命名 | 按命名规范生成候选表名，请用户确认 |
| 5 | 上游表 | 数据来源是哪些表，是否已有 DDL 可参考 |
| 6 | 字段清单 | 新增/修改哪些字段，每个字段的来源和计算口径 |
| 7 | 粒度 & 周期 | 日/小时/全量/增量 |
| 8 | 口径变更 | 是否有旧口径改新口径（如有，必须记录新旧差异） |
| 9 | 回刷需求 | 是否需要回刷历史数据 |
| 10 | 下游影响 | 本次修改是否影响已有下游表 |

### 确认后落盘

对话达成一致后，将以下内容写入 Program 目录：

- `PROGRAM.md`：任务目标、背景、方案概要、涉及文件
- `SCOPE.md`：写入范围（DDL 路径 + DML 路径）
- `STATUS.md`：初始状态
- `workspace/PLAN.md`：详细方案（使用 PLAN-TEMPLATE.md 结构）

用户确认 PROGRAM.md 和 SCOPE.md 内容无误后，方可开始编码。

---

## Scope 控制

- **只修改** SCOPE.md 中 `write` 允许的路径
- **超出范围**时询问用户，不要擅自修改
- `forbidden` 列表中的路径绝对不能写入

## 数仓开发原则

### 改表优先用 ALTER

- 生产表**禁止** DROP + CREATE（会丢数据）
- 新增字段用 `ALTER TABLE ... ADD COLUMN ... AFTER ...`
- 只有全新建表才用 CREATE TABLE

### DML 修改原则

- 改 DML 前**必须先看 DDL**，确认目标表结构
- CTE 名称和输出列名保持稳定，避免破坏下游引用
- 修改 join 逻辑时检查是否会导致 fan-out（一对多膨胀）
- 新增字段在 INSERT 语句中的位置必须与 DDL 字段顺序一致

### 数据口径变更

- 口径变更（改字段来源/计算方式）必须在 Plan 中明确记录
- 记录新旧口径差异、影响范围、是否需要回刷
- 变更需要用户确认后才能执行

## 状态持久化

工作过程中维护以下文件（都在 Program 的 `workspace/` 下）：

| 文件 | 时机 | 内容 |
|------|------|------|
| `STATUS.md` | 持续更新 | 阶段进度、任务状态 |
| `CHECKPOINT.md` | 上下文紧张时 | 当前状态快照，便于恢复 |
| `HANDOFF.md` | 会话结束未完成时 | 下次继续需要知道的信息 |
| `RESULT.md` | Program 完成时 | 最终成果总结 |

### HANDOFF 格式

```markdown
## HANDOFF

### 当前状态
- 已完成: xxx
- 进行中: yyy

### 分支
`dev+{owner}+{jira}+{desc}` @ <commit-sha>

### 修改文件
- `starrocks/{layer}/ddl/{table}.sql` — 改了什么
- `starrocks/{layer}/dml/P_{table}.sql` — 改了什么

### 下一步
1. 完成 zzz
2. 数据验证

### 口径变更记录
- {字段名}: 旧={来源A} → 新={来源B}
```

### CHECKPOINT 格式

当上下文窗口紧张时，写入 CHECKPOINT.md 保存当前工作快照：

```markdown
## CHECKPOINT

### 目标
当前 Program 的目标（一句话）

### 已完成
- [x] 任务 1
- [x] 任务 2

### 进行中
- [ ] 任务 3（进度：60%，卡在 xxx）

### 关键决策
- 选择方案 A 因为 yyy

### 文件变更
- `starrocks/{layer}/ddl/{table}.sql` — 改了什么
```

## 上下文管理

Agent 的上下文窗口有限。大任务必然跨越多次会话，HANDOFF / CHECKPOINT 机制保证跨会话零信息损失。

### 主动保存（推荐）

当对话已经很长、接近上下文上限时，用户会要求你保存进度：

1. commit 当前分支的所有变更
2. 更新 **STATUS.md**（任务进度）
3. 写入 **workspace/HANDOFF.md**（交接文档）
4. 如果上下文特别紧张，额外写 **workspace/CHECKPOINT.md**
5. 用户开新会话，说"继续 P-YYYY-NNN"，Agent 从 HANDOFF / CHECKPOINT 恢复

### 文件通信原则

- 大段 SQL、分析报告写入文件，不要塞进对话
- 引用文件路径而非复制内容
- 保护上下文窗口

## 工作节奏

1. Plan 确认 — 与用户对话，完成 Plan 确认清单
2. 落盘 — 写入 PROGRAM.md、SCOPE.md、STATUS.md、PLAN.md
3. 编码 — 按 DDL → DML 顺序开发
4. 验证 — 编写验证 SQL 检查数据质量
5. 更新 — 完成后更新 STATUS.md
