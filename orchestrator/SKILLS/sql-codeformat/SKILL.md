---
name: sql-codeformat
description: 使用确定性脚本格式化和规范化 SQL 文件。当用户要求格式化、规范化、美化、整理或统一 SQL 代码风格时使用；对于 StarRocks CREATE TABLE DDL，当目标文件位于 ddl 目录下、文件名不包含 view、且文件内容包含 create table 语句时，触发 DDL 格式化脚本；对于 StarRocks INSERT SELECT DML，当目标文件位于 dml 目录下、文件内容包含 insert into 或 insert overwrite，且主体是 select 或 with ... select 时，触发 DML 格式化脚本；对于 FineBI SQL，当目标文件位于 Application/FineBI 目录下、文件内容包含 select 或 with 时，触发 FineBI 格式化脚本。
---

# SQL 代码格式化

使用此 skill 格式化 SQL 文件。根据目标文件路径和 SQL 类型，选择匹配范围最窄的格式化器。

## 工作流程

1. 编辑前先检查目标路径和 SQL 内容。
2. 如果请求目标是 StarRocks `create table` DDL 文件，并且满足下方全部触发条件，调用 `scripts/format_starrocks_create_table.py`。
3. 如果请求目标是 StarRocks `insert into` 或 `insert overwrite` DML 文件，并且满足下方全部触发条件，调用 `scripts/format_starrocks_insert_select.py`。
4. 如果请求目标是 FineBI SQL 文件，并且路径包含 `Application/FineBI`，调用 `scripts/format_finebi.py`。
5. 如果没有匹配的内置格式化器，则手动格式化并保持语义不变。
6. 格式化后检查 diff。对脚本保守保留的可疑语法进行说明。

## StarRocks CREATE TABLE 格式化器

仅当全部条件都满足时，才触发 Python 格式化脚本：

- 目标文件是 `.sql` 文件。
- 目标文件的父目录名为 `ddl`。
- 目标文件名不包含 `view`，大小写不敏感。
- SQL 内容包含 `create table` 语句。
- 当前任务是格式化或规范化，而不是修改表结构语义。

在仓库根目录执行：

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_create_table.py path/to/file.sql --write
```

对于 `ods` 文件，标准头部需要以下信息，因此执行前必须先向用户确认：

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_create_table.py path/to/ods_table.sql --write --source-instance "..." --source-table "..." --source-owner "..." --developer "..."
```

使用 `--check` 校验文件是否已经符合格式要求，且不写入变更。不传 `--write` 和 `--check` 时，将格式化后的 SQL 输出到 stdout。

检查 CREATE TABLE 格式化细节时，加载 [references/createTable-format-rules.md](references/createTable-format-rules.md)。

格式化器采用保守策略：

- 保留列顺序、数据类型、注释、键定义、分区、分桶、桶数和属性值。
- 删除反引号和 StarRocks `engine` 子句。
- 根据文件名前三个字符推导库名，并将表名规范为 `db_name.file_stem`。
- 将 `create table` 改写成 `create table if not exists`。
- 将引号外的 SQL 关键字和数据类型转为小写。
- 对齐列名、类型、属性和注释。
- 按 StarRocks 顺序保留表级子句：键/模型、表注释、分区、分桶、属性。

不要将此格式化器用于视图，或文件名包含 `view` 的文件。

## StarRocks INSERT SELECT 格式化器

仅当全部条件都满足时，才触发 Python 格式化脚本：

- 目标文件是 `.sql` 文件。
- 目标文件的父目录名为 `dml`。
- SQL 内容包含 `insert into` 或 `insert overwrite`。
- `insert` 主体是 `select` 或 `with ... select`。
- 当前任务是格式化或规范化，而不是修改 ETL 逻辑语义。

在仓库根目录执行：

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_starrocks_insert_select.py path/to/file.sql --write --function "程序功能描述" --owner "负责人"
```

- 若目标文件已有文件头（含 `-- 程序功能` 注释块），格式化时保留不变；否则自动生成文件头，此时 `--function` 和 `--owner` 为必填参数。
- 使用 `--check` 校验文件是否已经符合格式要求，且不写入变更。不传 `--write` 和 `--check` 时，将格式化后的 SQL 输出到 stdout。

检查 DML 格式化细节时，加载 [references/dml-format-rules.md](references/dml-format-rules.md)。

格式化器采用保守策略：

- 不修改 SQL 语义、不改字段顺序、不改别名、不重写表达式、不补目标字段列表。
- 不修改字符串字面量、SQL 注释、`${...}` 调度变量。
- 删除不含中文的别名/列名/表名的反引号，含中文时保留。
- 所有 SQL 关键字、函数名、类型关键字统一小写，`inner join` 缩写为 `join`。
- `select` 列表前置逗号缩进，同段 `as` 垂直对齐；`case when` 多行格式化。
- `from`/`join` 与子查询缩进对齐，`on`/`and` 条件对齐。
- `where`/`group by`/`order by`/`having` 关键字与对应 `select` 对齐。
- `union all` 顶格，前后各一空行。
- 比较运算符两侧加空格，函数调用参数内逗号不额外加空格。
- 支持一个文件多段 `insert`，逐段格式化，不合并、不拆分语句。
- 脚本无法可靠判断的复杂 SQL 保留原结构，必要时手动按规则补齐。

## FineBI 格式化器

仅当全部条件都满足时，才触发 Python 格式化脚本：

- 目标文件是 `.sql` 文件。
- 目标文件路径包含 `Application/FineBI`（大小写不敏感）。
- SQL 内容包含 `select` 或 `with`。
- 当前任务是格式化或规范化，而不是修改业务逻辑语义。

在仓库根目录执行：

```bash
python orchestrator/SKILLS/sql-codeformat/scripts/format_finebi.py Application/FineBI/海剧/xxx.sql --write --report-path "海剧-用户维度报表" --report-name "报表名称"
```

- `--report-path`：FineBI 报表路径（如 `海剧-用户维度报表`），用于自动生成文件头。
- `--report-name`：FineBI 报表名称（如 `海剧三方支付漏斗链路报表`），用于自动生成文件头。
- 若目标文件已有 FineBI 文件头（含 `-- 应用报表` 注释块），格式化时保留不变；否则自动生成文件头，此时 `--report-path` 和 `--report-name` 为必填参数。
- 使用 `--check` 校验文件是否已经符合格式要求，且不写入变更。不传 `--write` 和 `--check` 时，将格式化后的 SQL 输出到 stdout。

格式化器采用保守策略：

- 不修改 SQL 语义、不改字段顺序、不重写表达式。
- 不修改字符串字面量、`${...}` FineBI 参数变量。
- 含中文的反引号别名/列名保留；不含中文的反引号删除。
- 所有 SQL 关键字、函数名统一小写，`inner join` 缩写为 `join`。
- `select` 列表前置逗号缩进，同段 `as` 垂直对齐；`case when` 多行格式化。
- CTE 注释标准化：`---xxx` 格式统一为 `-- xxx`，并在格式化后保留在对应 CTE 上方。
- 首个 CTE 使用 `with name as (`，后续 CTE 使用 `, name as (`。
- CTE 体缩进 4 空格。
- `from`/`join` 缩进对齐，`on`/`and` 条件对齐。
- `where` 条件首行与 `select` 对齐，续行额外缩进 2 空格；`between...and` 保持在同一行。
- `group by`/`order by`/`having` 关键字与对应 `select` 对齐。
- `union all` 顶格，前后各一空行。
- 比较运算符两侧加空格。
- 隐式别名自动补全 `as` 关键字（如 `Id id` → `Id as id`）。
- 脚本无法可靠判断的复杂 SQL 保留原结构，必要时手动按规则补齐。
