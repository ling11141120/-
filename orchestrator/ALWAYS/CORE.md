# 核心工作协议

## Scope 控制

- **只修改** SCOPE.yml 中 `write` 允许的路径
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

工作过程中维护以下文件（都在 Program 的 workspace/ 下）：

| 文件 | 时机 | 内容 |
|------|------|------|
| `STATUS.yml` | 持续更新 | 阶段进度、任务状态 |
| `CHECKPOINT.md` | 上下文紧张时 | 当前状态快照，便于恢复 |
| `HANDOFF.md` | 会话结束未完成时 | 下次继续需要知道的信息 |
| `RESULT.md` | Program 完成时 | 最终成果总结 |

## HANDOFF 格式

```markdown
## HANDOFF

### 当前状态
- 已完成: xxx
- 进行中: yyy

### 分支
`dev+roger+RTM-30352+xxx` @ <commit-sha>

### 修改文件
- `starrocks/ads/dml/P_xxx.sql` — 改了什么
- `starrocks/ads/ddl/xxx.sql` — 改了什么

### 下一步
1. 完成 zzz
2. 数据验证

### 口径变更记录
- core: 旧=dws.corever → 新=app_id 提取
- language_code: 旧=user_accountinfo → 新=series_view.language
```

## CHECKPOINT 格式

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
- `starrocks/ads/dml/P_xxx.sql` — 改了什么
```

## 上下文管理

Agent 的上下文窗口有限。大任务必然跨越多次会话，HANDOFF / CHECKPOINT 机制保证跨会话零信息损失。

### 主动保存（推荐）

当对话已经很长、接近上下文上限时，用户会要求你保存进度：

1. **push** 当前分支的所有 commit
2. 更新 **STATUS.yml**（任务进度）
3. 写入 **workspace/HANDOFF.md**（交接文档）
4. 如果上下文特别紧张，额外写 **workspace/CHECKPOINT.md**
5. 用户开新会话，说 "继续 P-YYYY-NNN"，Agent 从 HANDOFF / CHECKPOINT 恢复

### Compress 后恢复

如果上下文已被自动压缩（compress），信息可能丢失：

1. 回退到 compress 之前的状态
2. 在回退后的完整上下文中执行 HANDOFF 流程
3. 开新会话，从 HANDOFF 恢复

HANDOFF 写入的是结构化的交接文档，信息密度远高于 compress 后的残留上下文。

---

## 文件通信原则

- 大段 SQL、分析报告写入文件，不要塞进对话
- 引用文件路径而非复制内容
- 保护上下文窗口

## 工作节奏

1. 明确当前任务
2. 执行并记录进度
3. 遇到决策点询问用户
4. 完成后更新状态

---

## 代码开发规范

### Worktree 使用

**推荐使用 git worktree** 进行功能开发，不在主仓库上切分支：

```bash
cd repos/<repo>
git worktree add ../repos/<repo>-<feature> -b feature/xxx main
```

原因：
- 主仓库可能有其他未提交的变更
- 多个任务并行时互不影响
- 保持主仓库干净

清理：开发完成后 `git worktree remove ../repos/<repo>-<feature>`

### 提交代码前

1. 明确当前任务（读 Plan / PROGRAM.md）
2. 先改 DDL 再改 DML
3. 遇到口径决策点询问用户
4. 完成后更新 STATUS.yml
5. 编写数据验证 SQL
