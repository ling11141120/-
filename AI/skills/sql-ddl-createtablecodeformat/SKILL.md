---
name: sql-ddl-createtablecodeformat
description: 对SQL建表语句（不含视图创建语句）进行格式化和规范化，以提高可读性和一致性。Use when the user asks for 格式化 or 规范化, the target file's parent directory is ddl, the target filename does not contain view, and the task is to normalize a StarRocks 3.2.15 create-table statement without changing semantics.
---

# SQL DDL CreateTable Code Format

Format and normalize `create table` statements for StarRocks 3.2.15 without changing semantics.

## Workflow

1. Read the full statement before editing. Preserve database, table, column names, data types, comments, keys, partitions, distribution clauses, and properties. Remove engine clauses.
2. Determine the database name from the first three characters of the target filename and qualify the table name as `库名.表名`.
3. Before editing, if the database name is `ods`, ask the user for the source instance, source table, and source-owner information.
4. Normalize layout first, then normalize style. Do not rename identifiers, infer missing constraints, or rewrite business logic.
5. Keep the output deterministic and diff-friendly. Put each major table-level clause on its own line and each column definition on its own line.
6. Use StarRocks 3.2.15 dialect features and preserve the existing semantics.

## Formatting Rules

Load [references/createTable-format-rules.md](references/createTable-format-rules.md) when formatting or reviewing `create table` style.

Apply these defaults unless the surrounding file already contains a stricter local convention:

- Use lowercase SQL keywords such as `create table`, `drop`, `primary key`, `duplicate key`, `comment`, `partition by`, `distributed by hash`, `properties`, and `buckets`.
- Remove all backticks.
- Keep identifier text and string literal content unchanged.
- Put each column definition on its own line.
- Put each table constraint or index clause on its own line.
- Split trailing table `properties` options into a stable multi-line block instead of one long line.
- Prefix the table name with the database name derived from the filename, using `库名.表名`.
- Add `drop table if exists 库名.表名;` immediately before `create table`.
- Remove extra blank lines, but keep blank lines between logical blocks when that improves scanning.
- Simplify partition descriptions when StarRocks 3.2.15 supports a shorter equivalent form.
- Add brief program comments only when they clarify non-obvious structure; keep comments deterministic and sparse.

## Guardrails

- Preserve semantics. Do not change column order, data types, nullability, comments, key definitions, partition logic, distribution logic, bucket counts, or property values unless the user explicitly requests a semantic change.
- Do not rewrite `create view` statements or files whose names contain `view`.
- Do not invent missing constraints, defaults, or quotes unless required to repair an obvious syntax error.
- If a statement mixes dialects or contains suspicious syntax, format conservatively and call out the uncertain part.

## Output Pattern

When editing files, modify only the requested `create table` statements.
When returning formatted SQL in chat, provide the full formatted statement in a fenced `sql` block.
