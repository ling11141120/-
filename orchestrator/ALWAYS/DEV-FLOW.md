# 数仓开发流程

## 开发周期

```
Plan 确认 → 方案设计(PLAN.md) → DDL/DML 开发 → 数据验证 → MR → 合 master → 调度上线
```

---

## 1. Plan 确认

Program 创建后，Agent **必须先进入 Plan 模式**与用户对话，不可跳过直接写代码。

### 1.1 需求理解

- 用户描述需求后，Agent 用一句话复述目标
- 确认需求理解一致后继续

### 1.2 表血缘分析

- Agent 扫描 `starrocks/` 目录，识别上游依赖表
- 如果上游表有 DDL，读取其字段结构作为参考
- 列出可能受影响的下游表

### 1.3 字段 & 口径

- 新表：逐字段确认来源和计算逻辑
- 修改表：确认新增/变更字段的来源
- 口径变更：明确记录新旧口径差异

### 1.4 待确认问题

生成待确认清单，逐项与用户确认。用户确认全部问题后，写入 PROGRAM.md、SCOPE.yml、STATUS.yml、workspace/PLAN.md。

---

## 2. 分支管理

```
master          ← 生产稳定版本
  └── dev+{owner}+{jira}+{desc}  ← 功能开发分支（从 master 拉出）
```

### 创建分支

```bash
git checkout master
git pull origin master
git checkout -b "dev+{owner}+{jira}+{desc}"
```

### 提交代码

```bash
git add starrocks/{layer}/ddl/{table}.sql starrocks/{layer}/dml/P_{table}.sql
git commit -m "feat({layer}): {描述}"
git push -u origin HEAD
```

---

## 3. SQL 开发规范

### DDL 规范

```sql
-- 新建表
create table if not exists {schema}.{table_name} (
     dt          date     not null comment "日期"
    ,field1      type     not null comment "说明"
    ...
)
primary key(dt, ...)
comment "表中文说明"
partition by date_trunc("day", dt)
distributed by hash(...)
properties (...)
;

-- 增加字段（生产表用 ALTER，不要 DROP+CREATE）
alter table {schema}.{table_name}
add column {col} {type} COMMENT "说明"
;
```

### DML 规范

```sql
----------------------------------------------------------------
-- 程序功能： xxx
-- 程序名： P_{table_name}
-- 目标表： {schema}.{table_name}
-- 负责人： xxx
-- 开发日期：yyyy-mm-dd
----------------------------------------------------------------

insert into {schema}.{table_name}
WITH cte_1 as (...)
,cte_2 as (...)
select ...
from cte_1
...
;
```

### SQL 编码风格

- 关键字小写：`select`、`from`、`left join`、`group by`
- 缩进：4 空格
- 字段对齐：逗号前置（`, field`）
- GROUP BY 用位置数字：`group by 1, 2, 3`
- CTE 优先于子查询（可读性 + StarRocks CTE 复用优化）
- 大表 CTE 开头加 `set cbo_cte_reuse = true;`
- 时间参数使用 DolphinScheduler 变量：`'${dt}'`、`'${bf_4_dt}'`
- SQL 文件编码统一：`UTF-8 无 BOM`
- SQL 行尾统一：`CRLF`

### 数据质量兜底

- 脏数据过滤：`left semi join` 或 `inner join` 维表
- NULL 兜底：`coalesce(field, 0)` 或 `coalesce(field, 'Unknown')`
- 数值封顶：`least(value, max_bound)`
- 避免 fan-out：join 维表时确认粒度唯一，必要时先去重

---

## 4. 数据验证

修改完成后，编写验证 SQL 检查：

```sql
-- 枚举值一致性
select distinct {col1}, {col2} from {schema}.{table} where dt = '${dt}';

-- 指标对比（新旧口径）
select dt, key_col, old_metric, new_metric
from old_table a join new_table b on ...
where a.metric <> b.metric;

-- 数据量级检查
select dt, count(*) from {schema}.{table} group by dt order by dt desc limit 7;
```

---

## 5. 合并与上线

```bash
# 推送到远程
git push origin HEAD

# 创建 MR: dev+xxx → master
# GitLab CI 自动验证 + 合并 + 触发 DolphinScheduler
```

---

## 6. 回刷数据

如果修改影响历史数据，需要回刷：

- DolphinScheduler 中设置回刷日期范围
- DML 中的 `'${bf_4_dt}'` ~ `'${dt}'` 支持窗口回刷
- 回刷完成后验证数据一致性

---

## Commit 规范

格式：`<type>(<scope>): <description>`

| Type | 说明 |
|------|------|
| `feat` | 新增表/字段/指标 |
| `fix` | 修复数据口径/逻辑 Bug |
| `refactor` | 重构 SQL（不改口径） |
| `perf` | 性能优化（分桶/索引/分区） |
| `docs` | 文档/注释 |
| `chore` | 杂项（验证脚本等） |

Scope 使用数仓层级：`ods`、`dwd`、`dws`、`dim`、`ads`

示例：

- `feat(ads): 新增 {业务} 用户流失趋势表`
- `feat(ads): {表名} 新增 {字段名} 字段`
- `fix(ads): 修复 {字段} 重复计数`
- `refactor(ads): {字段} 口径切换为 {新来源}`
