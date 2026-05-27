---
name: sql-codeformat
description: 使用确定性脚本格式化和规范化 SQL 文件。当用户要求格式化、规范化、美化、整理或统一 SQL 代码风格时使用；对于 StarRocks CREATE TABLE DDL，当目标文件位于 ddl 目录下、文件名不包含 view、且文件内容包含 create table 语句时，触发 DDL 格式化脚本；对于 StarRocks INSERT SELECT DML，当目标文件位于 dml 目录下、文件内容包含 insert into 或 insert overwrite，且主体是 select 或 with ... select 时，触发 DML 格式化脚本；对于 FineBI SQL，当目标文件位于 Application/FineBI 目录下、文件内容包含 select 或 with 时，触发 FineBI 格式化脚本。
---

# SQL 代码格式化

当用户提到"格式化""规范化""美化""整理""统一风格""format""normalize""beautify"等关键词，并指定了一个 `.sql` 文件时，自动执行此 skill。

## 执行流程

### 第一步：读取目标文件

读取用户指定的 SQL 文件，获取完整内容。

### 第二步：判断 SQL 类型

根据以下规则判断文件类型：

| 条件 | 类型 | 格式化器 |
|------|------|----------|
| 文件位于 `ddl/` 目录下，文件名不含 `view`，内容包含 `create table` | CREATE TABLE DDL | `format_starrocks_create_table.py` |
| 文件位于 `dml/` 目录下，内容包含 `insert into` 或 `insert overwrite`，主体是 `select` 或 `with ... select` | INSERT SELECT DML | `format_starrocks_insert_select.py` |
| 文件路径包含 `Application/FineBI`，内容包含 `select` 或 `with` | FineBI SQL | `format_finebi.py` |
| 以上都不匹配 | 不支持自动格式化 | 手动格式化，保持语义不变 |

### 第三步：执行格式化脚本

所有脚本从仓库根目录执行。

#### CREATE TABLE DDL 格式化

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_create_table.py <文件路径> --write
```

对于 `ods` 层文件，标准头部需要额外信息，执行前必须向用户确认：

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_create_table.py <文件路径> --write --source-instance "..." --source-table "..." --source-owner "..." --developer "..."
```

#### INSERT SELECT DML 格式化

先检查目标文件是否已有文件头（含 `-- 程序功能` 注释块）：

- **有文件头**：保留不变，直接格式化
  ```bash
  python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_insert_select.py <文件路径> --write
  ```

- **无文件头**：需要用户提供程序功能和负责人信息
  ```bash
  python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_insert_select.py <文件路径> --write --function "程序功能描述" --owner "负责人"
  ```
  执行前先向用户询问 `--function` 和 `--owner` 参数的值。

#### FineBI SQL 格式化

先检查目标文件是否已有 FineBI 文件头（含 `-- 应用报表` 注释块）：

- **有文件头**：保留不变，直接格式化
  ```bash
  python orchestrator/SKILLS/sql-codeformat/scripts/format_finebi.py <文件路径> --write
  ```

- **无文件头**：需要用户提供报表路径和报表名称
  ```bash
  python orchestrator/SKILLS/sql-codeformat/scripts/format_finebi.py <文件路径> --write --report-path "海剧-用户维度报表" --report-name "报表名称"
  ```
  执行前先向用户询问 `--report-path` 和 `--report-name` 参数的值。

### 第四步：验证与报告

格式化完成后：
1. 用 `--check` 参数验证文件已符合格式要求
2. 向用户报告格式化结果：文件路径、行数变化（如有）、格式类型
3. 对脚本保守保留的可疑语法进行说明

## 格式化规则摘要

### DDL 格式化器
- 保留列顺序、数据类型、注释、键定义、分区、分桶
- 删除反引号和 StarRocks `engine` 子句
- `create table` → `create table if not exists`
- 关键字和数据类型小写，列名/类型/属性/注释对齐

### DML 格式化器
- 不修改 SQL 语义、字段顺序、别名、表达式
- 删除不含中文的反引号，含中文保留
- 关键字/函数名小写，`inner join` → `join`
- `select` 列表前置逗号缩进，同段 `as` 垂直对齐
- `case when` 多行格式化
- `from`/`join` 与子查询缩进对齐，`on`/`and` 条件对齐
- `where`/`group by`/`order by`/`having` 与对应 `select` 对齐
- `union all` 顶格，前后各一空行
- 比较运算符两侧加空格

### FineBI 格式化器
- 不修改 SQL 语义、字段顺序、表达式、`${...}` 参数变量
- 含中文反引号保留，不含中文删除
- CTE 注释标准化：`---xxx` → `-- xxx`，保留在对应 CTE 上方
- 首个 CTE 用 `with`，后续用 `, ` 前置
- CTE 体缩进 4 空格
- 隐式别名自动补全 `as`
- `between...and` 保持在同一行
- 其他规则与 DML 格式化器一致（select 列表、from/join、where、union all 等）

详细规则参考：
- `orchestrator/SKILLS/sql-codeformat/references/createTable-format-rules.md`
- `orchestrator/SKILLS/sql-codeformat/references/dml-format-rules.md`
