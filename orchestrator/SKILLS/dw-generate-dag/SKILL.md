---
name: dw-generate-dag
description: 从 StarRocks DML SQL 生成 DolphinScheduler DAG 导入 JSON。用于将 `starrocks/*/dml/*.sql` 批量或单文件转换为包含 processDefinition、processTaskRelationList、taskDefinitionList 的标准导入结构。
---

# DW Generate DAG

优先运行 `scripts/generate_dag_json.py`，不要手工拼装 DAG JSON。

## 1) 输入准备

- 单文件模式：输入一个 DML SQL 文件。
- 批量模式：输入目录并递归扫描 `*.sql`。
- `--repo-root` 指向仓库根目录，用于定位 DDL 与生成相对 SQL 路径。

## 2) 常用命令

```bash
python scripts/generate_dag_json.py --input <sql_file_or_dir> --repo-root <repo_root> --output <json_file_or_dir>
```

```bash
python scripts/generate_dag_json.py --input <...> --repo-root <...> --output <...> --config <config_json_or_path>
```

```bash
python scripts/generate_dag_json.py --input <...> --repo-root <...> --dry-run
```

```bash
python scripts/generate_dag_json.py --input <...> --repo-root <...> --output <...> --report <report_json_path>
```

## 3) 参数与映射规则

- 目标表优先取注释 `-- 目标表: schema.table`，否则回退解析 `insert into`。
- DAG 名：`tbl_<table_name>`。
- DAG 描述：读取对应 DDL 的表注释。
- 节点名：优先 `-- 程序名`，否则 SQL 文件名。
- `${var}` 参数同步到 `localParams`、`taskParamList`、`taskParamMap`。
- 日期变量映射：`dt`、`bf_N_dt`、`af_N_dt`。

## 4) 错误处理

- 单文件：解析失败直接报错。
- 目录模式：默认跳过错误文件并汇总。
- `--strict`：目录模式下遇到首个错误立即退出。
- `--dry-run`：只解析并预览，不写 JSON 文件。

## 5) 验证清单

- 输出结构包含：`processDefinition`、`processTaskRelationList`、`taskDefinitionList`、`schedule`。
- `rawScript` 中参数与 SQL 中 `${var}` 一致。
- 若启用 `--report`，检查报告中的成功/失败条目及错误原因。

## 6) 参考

- 字段规范与配置示例：`references/dag-json-spec.md`
