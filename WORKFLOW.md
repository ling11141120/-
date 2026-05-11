# 端到端工作流程

用户说"新需求"之后，Agent 的完整行为序列。

---

## 场景一：全新 Program（新建表）

```
用户: 新 Program: ads 层新增 {业务} 统计表

【0. 初始化】
  Agent 读取:
    - orchestrator/ALWAYS/CORE.md       → 工作协议 + Plan 确认清单
    - orchestrator/ALWAYS/DEV-FLOW.md    → 开发流程 + SQL 规范
    - orchestrator/ALWAYS/RESOURCE-MAP.yml → 仓库配置

【1. Plan 对话】
  Agent 逐项确认:
    Q1. 需求理解 — 复述目标，确认理解一致
    Q2. 分层 & 表名 — 按命名规范生成候选，确认
    Q3. 业务域 — 确认归属
    Q4. 上游表 — 确认数据来源，读取现有 DDL
    Q5. 字段清单 — 逐字段确认来源和计算口径
    Q6. 粒度 & 周期 — 确认 di / hi / df / ed
    Q7. 回刷需求 — 是否需要回刷历史

【2. 落盘】
  用户确认后，Agent 写入:
    - orchestrator/PROGRAMS/P-YYYY-NNN-xxx/PROGRAM.md
    - orchestrator/PROGRAMS/P-YYYY-NNN-xxx/SCOPE.yml
    - orchestrator/PROGRAMS/P-YYYY-NNN-xxx/STATUS.yml
    - orchestrator/PROGRAMS/P-YYYY-NNN-xxx/workspace/PLAN.md

  展示文件给用户，确认无误后继续。

【3. DDL 开发】
  Agent 根据 PLAN.md 编写 DDL:
    - 读取 DEV-FLOW.md 的 DDL 规范
    - 写入 starrocks/{layer}/ddl/{table_name}.sql
    - 更新 STATUS.yml（t1: done）

【4. DML 开发】
  Agent 根据 DDL 和 PLAN.md 编写 DML:
    - 读取 DDL 确认表结构
    - 写入 starrocks/{layer}/dml/P_{table_name}.sql
    - 更新 STATUS.yml（t2: done）

【5. 数据验证】
  Agent 编写验证 SQL:
    - 数据量级检查
    - 枚举值一致性
    - 写入 workspace/validation.sql
    - 更新 STATUS.yml（t3: done）

【6. 提交】
  Agent 执行:
    git add ...
    git commit -m "feat({layer}): {描述}"
    git push
    创建 MR
    更新 STATUS.yml → phase: done
    写入 workspace/RESULT.md
```

---

## 场景二：修改已有表（新增字段 / 改口径）

```
用户: 新 Program: {表名} 新增 {字段} / 修改 {字段} 口径

【0. 初始化】
  同场景一

【1. Plan 对话】
  Agent 逐项确认:
    Q1. 需求理解 — 复述目标
    Q2. 读取现有 DDL — 确认表结构和字段顺序
    Q3. 新增字段: 名称、类型、位置(AFTER xxx)、来源
       / 口径变更: 旧口径 → 新口径，变更原因
    Q4. 下游影响 — 扫描引用此表的 DML，评估影响
    Q5. 回刷需求 — 是否需要回刷

【2. 落盘】
  同场景一，PLAN.md 额外记录口径变更详情

【3. DDL 修改】
  ALTER TABLE ... ADD COLUMN ... AFTER ...（不是 DROP + CREATE）

【4. DML 修改】
  在 INSERT 语句中追加新字段，位置与 DDL 一致

【5-6. 验证 & 提交】
  同场景一，验证 SQL 增加新口径对比
```

---

## 场景三：跨会话继续

```
用户: 继续 P-YYYY-NNN

【0. 初始化】
  Agent 读取:
    - orchestrator/PROGRAMS/P-YYYY-NNN/STATUS.yml
    - orchestrator/PROGRAMS/P-YYYY-NNN/workspace/HANDOFF.md（如有）
    - orchestrator/PROGRAMS/P-YYYY-NNN/workspace/CHECKPOINT.md（如有）

  输出:
    Program: {名称}
    当前阶段: {phase}
    已完成: {done tasks}
    下一步: {next_action}

【继续开发】
  从 STATUS.yml 的 next_action 或 HANDOFF.md 的"下一步"开始执行
```

---

## 关键原则

1. **Plan 先行** — 必须先对话确认，再落盘编码，不可跳过
2. **DDL 先于 DML** — 先定表结构，再写数据逻辑
3. **只写 SCOPE 内的路径** — 超出范围先询问
4. **跨会话靠 HANDOFF** — 会话结束未完成时必须写 HANDOFF.md
5. **口径变更必记录** — 在 PLAN.md 和 HANDOFF.md 中都要记录
