# DAG JSON Spec

## 1. 输入

脚本入口：`scripts/generate_dag_json.py`

参数：
- `--input <sql_file_or_dir>`: DML SQL 文件或目录。
- `--repo-root <path>`: 仓库根目录。
- `--output <json_file_or_dir>`: 单文件输出 `.json` 或批量输出目录。
- `--config <json_or_path>`: 可选，覆盖默认调度配置。
- `--strict`: 目录模式下遇错即退出。

## 2. 字段映射

- `processDefinition.name`: `tbl_<table_name>`
- `processDefinition.description`: DDL 表级注释
- `taskDefinitionList[0].name`: DML 注释 `-- 程序名` 或 SQL 文件名
- `taskDefinitionList[0].taskParams.rawScript`: 
  - `bash run_sql.sh <sql相对路径> "k1=${k1}","k2=${k2}"`
- `taskParams.localParams` / `taskParamList` / `taskParamMap`:
  - 来源于 SQL `${var}` 参数

## 3. 参数映射

- `dt -> $[yyyy-MM-dd]`
- `bf_N_dt -> $[yyyy-MM-dd-N]`
- `af_N_dt -> $[yyyy-MM-dd+N]`
- 其他变量 -> `$[yyyy-MM-dd]`

顺序规则：`dt` 优先，其余按首次出现顺序，最终去重。

## 4. DDL 定位规则

目标表 `schema.table` 对应 DDL：
- `starrocks/{schema}/ddl/{table}.sql`

表级注释提取：
- `create table ... ) engine ... comment "..."`

## 5. 默认值

`id/code/version` 默认置 `0`，`schedule` 默认 `null`。

关键默认项（可被 `--config` 覆盖）：
- `projectCode`
- `userId`
- `environmentCode`
- `workerGroup`
- `resourceIds`
- `resourceList`
- 重试与超时相关字段

## 6. 配置示例

```json
{
  "defaults": {
    "projectCode": 10857427255392,
    "userId": 120032,
    "environmentCode": 18255652448032,
    "resourceIds": "120201,120042",
    "resourceList": [{"id": 120042}, {"id": 120201}]
  },
  "processDefinition": {
    "warningGroupId": 0
  },
  "taskDefinition": {
    "failRetryTimes": 2
  },
  "processTaskRelation": {
    "postTaskCode": 0
  }
}
```

## 7. 示例命令

单文件：

```bash
python scripts/generate_dag_json.py \
  --input starrocks/ads/dml/P_ads_sv_beidou_series_daily_stat_di.sql \
  --repo-root d:/IdeaProjects/dolphinscheduler \
  --output starrocks/test/tbl_ads_sv_beidou_series_daily_stat_di.json
```

批量：

```bash
python scripts/generate_dag_json.py \
  --input starrocks/ads/dml \
  --repo-root d:/IdeaProjects/dolphinscheduler \
  --output starrocks/test/generated_dags
```
