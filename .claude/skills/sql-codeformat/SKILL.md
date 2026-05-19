---
name: sql-codeformat
description: 使用确定性脚本格式化和规范化 StarRocks SQL 文件。当用户要求格式化、规范化、美化、整理或统一 SQL 代码风格时自动触发。支持 CREATE TABLE DDL 和 INSERT SELECT DML 两类文件。
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
- `case when` 多行格式化（`end` 的 `d` 与 `case` 的 `e` 对齐）
- `from`/`join` 与子查询缩进对齐，`on`/`and` 条件对齐
- `where`/`group by`/`order by`/`having` 与对应 `select` 对齐
- `union all` 顶格，前后各一空行
- 比较运算符两侧加空格

详细规则参考：
- `orchestrator/SKILLS/sql-codeformat/references/createTable-format-rules.md`
- `orchestrator/SKILLS/sql-codeformat/references/dml-format-rules.md`
