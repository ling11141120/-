# 数仓开发流程

## 开发周期

```
需求评审 → 方案设计(Plan) → DDL/DML 开发 → 数据验证 → MR → 合 master → 调度上线
```

---

## 1. 方案设计

使用 Plan（`plans/`）记录：
- 修改范围（涉及哪些表/DML）
- 字段变更（新增/改源/改口径）
- 数据血缘变化（上游表替换）
- 待确认问题

Plan 确认后再动代码。

## 2. 分支管理

```
master          ← 生产稳定版本
  └── stage     ← 集成测试（MR 只能从 stage 合入 master）
       └── dev+{owner}+{jira}+{desc}  ← 功能开发分支
```

### 创建分支

```bash
git checkout stage
git pull origin stage
git checkout -b "dev+roger+RTM-30352+北斗短剧源数据替换"
```

### 提交代码

```bash
git add starrocks/ads/ddl/xxx.sql starrocks/ads/dml/P_xxx.sql
git commit -m "feat(ads): 北斗短剧底表替换为endwatching_view"
git push -u origin HEAD
```

## 3. SQL 开发规范

### DDL 规范

```sql
-- 新建表
CREATE TABLE {schema}.{table_name} (
    dt          date     not null comment "日期"
    ,field1     type     not null comment "说明"
    ...
) ENGINE = OLAP
PRIMARY KEY(dt, ...)
COMMENT "表中文说明"
PARTITION BY date_trunc("day", dt)
DISTRIBUTED BY hash(...) BUCKETS 2
PROPERTIES (...);

-- 增加字段（生产表用 ALTER，不要 DROP+CREATE）
ALTER TABLE {schema}.{table_name}
ADD COLUMN {col} {type} COMMENT "说明"
AFTER {existing_col};
```

### DML 规范

```sql
-- 文件头注释
----------------------------------------------------------------
-- 程序功能： xxx
-- 程序名： P_{table_name}
-- 目标表： {schema}.{table_name}
-- 负责人： xxx
-- 开发日期：yyyy-mm-dd
-- 版本号： v1.0
----------------------------------------------------------------

-- DML
INSERT INTO {schema}.{table_name}
WITH
cte_1 AS (...),
cte_2 AS (...)
SELECT ...
FROM cte_1
...;
```

### SQL 编码风格

- 关键字小写：`select`、`from`、`left join`、`group by`
- 缩进：4 空格
- 字段对齐：逗号前置（`, field`）
- GROUP BY 用位置数字：`group by 1, 2, 3`
- CTE 优先于子查询（可读性 + StarRocks CTE 复用优化）
- 大表 CTE 开头加 `SET cbo_cte_reuse = true;`
- 时间参数使用 DolphinScheduler 变量：`'${dt}'`、`'${bf_4_dt}'`
- SQL文件编码统一：`UTF-8 无 BOM`
- SQL行尾统一：`CRLF`

### 数据质量兜底

- 脏数据过滤：`left semi join` 或 `inner join` 维表
- NULL 兜底：`coalesce(field, 0)` 或 `coalesce(field, 'Unknown')`
- 数值封顶：`least(value, max_bound)`
- 避免 fan-out：join 维表时确认粒度唯一，必要时先去重

## 4. 数据验证

修改完成后，编写验证 SQL 检查：

```sql
-- 枚举值一致性
SELECT DISTINCT core, language_code FROM ads.{table} WHERE dt = '${dt}';

-- 指标对比（新旧口径）
SELECT dt, series_id, old_metric, new_metric
FROM old_table a JOIN new_table b ON ...
WHERE a.metric != b.metric;

-- 数据量级检查
SELECT dt, count(*) FROM ads.{table} GROUP BY dt ORDER BY dt DESC LIMIT 7;
```

## 5. 合并与上线

```bash
# 推送到 stage
git push origin HEAD

# 创建 MR: stage → master
# GitLab CI 自动验证 + 合并 + 触发 DolphinScheduler
```

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
| `fix` | 修复数据口径/逻辑Bug |
| `refactor` | 重构 SQL（不改口径） |
| `perf` | 性能优化（分桶/索引/分区） |
| `docs` | 文档/注释 |
| `chore` | 杂项（验证脚本等） |

Scope 使用数仓层级：`ods`、`dwd`、`dws`、`dim`、`ads`

示例：
- `feat(ads): 北斗短剧底表替换为endwatching_view`
- `feat(ads): daily_stat_di 新增 first_pay_epis_num 字段`
- `fix(ads): 修复 play_count 重复计数（去重底表）`
- `refactor(ads): 去掉 dws join，core 改从 app_id 提取`
