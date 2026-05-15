#!/usr/bin/env python3
"""Generate DolphinScheduler DAG import JSON from StarRocks DML SQL."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

TARGET_TABLE_RE = re.compile(
    r"^\s*--\s*目标表\s*[:：]\s*([A-Za-z0-9_]+\.[A-Za-z0-9_]+)",
    re.MULTILINE,
)
PROGRAM_NAME_RE = re.compile(
    r"^\s*--\s*程序名\s*[:：]\s*([A-Za-z0-9_]+)",
    re.MULTILINE,
)
INSERT_INTO_RE = re.compile(
    r"\binsert\s+into\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)",
    re.IGNORECASE,
)
PARAM_RE = re.compile(r"\$\{([A-Za-z0-9_]+)\}")
DDL_TABLE_COMMENT_RE = re.compile(
    r"\)\s*engine\b[\s\S]*?\bcomment\s+([\"'])(.*?)\1",
    re.IGNORECASE,
)
BF_RE = re.compile(r"^bf_(\d+)_dt$")
AF_RE = re.compile(r"^af_(\d+)_dt$")

DEFAULTS = {
    "projectCode": 0,
    "userId": 0,
    "tenantId": -1,
    "warningGroupId": 0,
    "executionType": "PARALLEL",
    "workerGroup": "default",
    "environmentCode": 0,
    "failRetryTimes": 2,
    "failRetryInterval": 1,
    "timeoutFlag": "CLOSE",
    "timeoutNotifyStrategy": "WARN",
    "timeout": 0,
    "delayTime": 0,
    "taskPriority": "MEDIUM",
    "taskExecuteType": "BATCH",
    "resourceIds": "",
    "resourceList": [],
    "flag": "YES",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate DolphinScheduler DAG JSON from StarRocks DML SQL.",
    )
    parser.add_argument("--input", required=True, help="SQL file or directory")
    parser.add_argument("--repo-root", default=".", help="Repository root path")
    parser.add_argument("--output", help="Output JSON file (single) or directory (batch)")
    parser.add_argument("--config", help="JSON file path or inline JSON string for overriding defaults")
    parser.add_argument("--strict", action="store_true", help="Fail immediately when a SQL file cannot be parsed in directory mode")
    parser.add_argument("--dry-run", action="store_true", help="Parse and preview only, do not write DAG JSON files")
    parser.add_argument("--report", help="Write execution report JSON with success/failed details")
    return parser.parse_args()


def load_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def extract_target_table(sql_text: str) -> str:
    match = TARGET_TABLE_RE.search(sql_text)
    if match:
        return match.group(1)
    fallback = INSERT_INTO_RE.search(sql_text)
    if fallback:
        return fallback.group(1)
    raise ValueError("无法从 SQL 提取目标表（缺少目标表注释和 insert into）")


def extract_program_name(sql_text: str, sql_path: Path) -> str:
    match = PROGRAM_NAME_RE.search(sql_text)
    if match:
        return match.group(1)
    return sql_path.stem


def extract_params(sql_text: str) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for param in PARAM_RE.findall(sql_text):
        if param not in seen:
            seen.add(param)
            ordered.append(param)

    if "dt" in seen:
        ordered = ["dt"] + [p for p in ordered if p != "dt"]
    return ordered


def map_param_value(param: str) -> str:
    if param == "dt":
        return "$[yyyy-MM-dd]"

    bf_match = BF_RE.match(param)
    if bf_match:
        return f"$[yyyy-MM-dd-{bf_match.group(1)}]"

    af_match = AF_RE.match(param)
    if af_match:
        return f"$[yyyy-MM-dd+{af_match.group(1)}]"

    return "$[yyyy-MM-dd]"


def build_script(sql_rel_path: str, params: list[str]) -> str:
    if not params:
        return f"bash run_sql.sh {sql_rel_path}"
    args = ",".join([f'\"{p}=${{{p}}}\"' for p in params])
    return f"bash run_sql.sh {sql_rel_path} {args}"


def load_config(config_arg: str | None) -> dict[str, Any]:
    if not config_arg:
        return {}

    possible_path = Path(config_arg)
    if possible_path.exists() and possible_path.is_file():
        return json.loads(load_text(possible_path))

    return json.loads(config_arg)


def merge_defaults(config: dict[str, Any]) -> dict[str, Any]:
    merged = dict(DEFAULTS)

    for key in DEFAULTS:
        if key in config:
            merged[key] = config[key]

    defaults_block = config.get("defaults")
    if isinstance(defaults_block, dict):
        for key in DEFAULTS:
            if key in defaults_block:
                merged[key] = defaults_block[key]

    return merged


def extract_table_comment(ddl_text: str, target_table: str) -> str:
    match = DDL_TABLE_COMMENT_RE.search(ddl_text)
    if match:
        return match.group(2).strip()
    return target_table


def to_relative_sql_path(sql_path: Path, repo_root: Path) -> str:
    rel = sql_path.resolve().relative_to(repo_root.resolve())
    return str(rel).replace("\\", "/")


def build_local_params(params: list[str]) -> list[dict[str, str]]:
    return [
        {
            "prop": p,
            "direct": "IN",
            "type": "VARCHAR",
            "value": map_param_value(p),
        }
        for p in params
    ]


def build_dag_json(
    sql_path: Path,
    repo_root: Path,
    config: dict[str, Any],
) -> tuple[str, list[dict[str, Any]]]:
    sql_text = load_text(sql_path)

    target_table = extract_target_table(sql_text)
    schema, table_name = target_table.split(".", 1)
    dag_name = f"tbl_{table_name}"

    ddl_path = repo_root / "starrocks" / schema / "ddl" / f"{table_name}.sql"
    if not ddl_path.exists():
        raise FileNotFoundError(f"未找到 DDL 文件: {ddl_path}")

    ddl_text = load_text(ddl_path)
    task_name = extract_table_comment(ddl_text, target_table)
    node_name = extract_program_name(sql_text, sql_path)
    params = extract_params(sql_text)

    sql_rel_path = to_relative_sql_path(sql_path, repo_root)
    raw_script = build_script(sql_rel_path, params)

    merged_defaults = merge_defaults(config)
    pd_overrides = config.get("processDefinition", {})
    td_overrides = config.get("taskDefinition", {})
    relation_overrides = config.get("processTaskRelation", {})
    schedule = config.get("schedule", None)

    local_params = build_local_params(params)
    task_param_map = {p: map_param_value(p) for p in params}

    process_definition = {
        "id": 0,
        "code": 0,
        "name": dag_name,
        "version": 0,
        "releaseState": "OFFLINE",
        "projectCode": merged_defaults["projectCode"],
        "description": task_name,
        "globalParams": "[]",
        "globalParamList": [],
        "globalParamMap": {},
        "createTime": "",
        "updateTime": "",
        "flag": merged_defaults["flag"],
        "userId": merged_defaults["userId"],
        "userName": None,
        "projectName": None,
        "locations": "[]",
        "scheduleReleaseState": None,
        "timeout": merged_defaults["timeout"],
        "tenantId": merged_defaults["tenantId"],
        "tenantCode": None,
        "modifyBy": None,
        "warningGroupId": merged_defaults["warningGroupId"],
        "executionType": merged_defaults["executionType"],
    }
    process_definition.update(pd_overrides)

    process_task_relation = {
        "id": 0,
        "name": "",
        "processDefinitionVersion": 0,
        "projectCode": merged_defaults["projectCode"],
        "processDefinitionCode": 0,
        "preTaskCode": 0,
        "preTaskVersion": 0,
        "postTaskCode": 0,
        "postTaskVersion": 0,
        "conditionType": "NONE",
        "conditionParams": {},
        "createTime": "",
        "updateTime": "",
        "operator": merged_defaults["userId"],
        "operateTime": "",
    }
    process_task_relation.update(relation_overrides)

    task_definition = {
        "id": 0,
        "code": 0,
        "name": node_name,
        "version": 0,
        "description": "",
        "projectCode": merged_defaults["projectCode"],
        "userId": merged_defaults["userId"],
        "taskType": "SHELL",
        "taskParams": {
            "localParams": local_params,
            "rawScript": raw_script,
            "resourceList": merged_defaults["resourceList"],
        },
        "taskParamList": local_params,
        "taskParamMap": task_param_map,
        "flag": merged_defaults["flag"],
        "taskPriority": merged_defaults["taskPriority"],
        "userName": None,
        "projectName": None,
        "workerGroup": merged_defaults["workerGroup"],
        "environmentCode": merged_defaults["environmentCode"],
        "failRetryTimes": merged_defaults["failRetryTimes"],
        "failRetryInterval": merged_defaults["failRetryInterval"],
        "timeoutFlag": merged_defaults["timeoutFlag"],
        "timeoutNotifyStrategy": merged_defaults["timeoutNotifyStrategy"],
        "timeout": merged_defaults["timeout"],
        "delayTime": merged_defaults["delayTime"],
        "resourceIds": merged_defaults["resourceIds"],
        "createTime": "",
        "updateTime": "",
        "modifyBy": None,
        "taskGroupId": 0,
        "taskGroupPriority": 0,
        "cpuQuota": -1,
        "memoryMax": -1,
        "taskExecuteType": merged_defaults["taskExecuteType"],
        "operator": merged_defaults["userId"],
        "operateTime": "",
    }
    task_definition.update(td_overrides)

    dag = {
        "processDefinition": process_definition,
        "processTaskRelationList": [process_task_relation],
        "taskDefinitionList": [task_definition],
        "schedule": schedule,
    }
    return dag_name, [dag]


def write_json(path: Path, content: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(content, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def collect_sql_files(input_path: Path) -> list[Path]:
    if input_path.is_file():
        return [input_path]
    if input_path.is_dir():
        return sorted([p for p in input_path.rglob("*.sql") if p.is_file()])
    raise FileNotFoundError(f"输入路径不存在: {input_path}")


def write_report(path: Path, records: list[dict[str, Any]], success: int, failed: int) -> None:
    payload = {
        "summary": {
            "success": success,
            "failed": failed,
            "total": success + failed,
        },
        "records": records,
    }
    write_json(path, payload)


def main() -> int:
    args = parse_args()

    input_path = Path(args.input).resolve()
    repo_root = Path(args.repo_root).resolve()
    output_path = Path(args.output).resolve() if args.output else None
    report_path = Path(args.report).resolve() if args.report else None

    if not repo_root.exists():
        raise FileNotFoundError(f"repo-root 不存在: {repo_root}")

    config = load_config(args.config)

    sql_files = collect_sql_files(input_path)
    if not sql_files:
        raise RuntimeError("未找到任何 SQL 文件")

    is_single = len(sql_files) == 1 and input_path.is_file()

    if input_path.is_dir() and output_path is None and not args.dry_run:
        raise ValueError("目录模式必须提供 --output（输出目录），或使用 --dry-run")

    success = 0
    failed = 0
    records: list[dict[str, Any]] = []

    for sql_file in sql_files:
        try:
            dag_name, dag_json = build_dag_json(sql_file, repo_root, config)

            planned_output = None
            if output_path is not None:
                if is_single and output_path.suffix.lower() == ".json":
                    planned_output = output_path
                else:
                    planned_output = output_path / f"{dag_name}.json"

            if args.dry_run:
                if is_single:
                    print(json.dumps(dag_json, ensure_ascii=False, indent=2))
                print(f"[DRY-RUN] {sql_file} -> {planned_output or '<stdout>'}")
            elif output_path is None:
                print(json.dumps(dag_json, ensure_ascii=False, indent=2))
            else:
                write_json(planned_output, dag_json)
                print(f"[OK] {sql_file} -> {planned_output}")

            records.append(
                {
                    "status": "success",
                    "input": str(sql_file),
                    "dag_name": dag_name,
                    "output": str(planned_output) if planned_output else "<stdout>",
                }
            )
            success += 1
        except Exception as exc:  # noqa: BLE001
            failed += 1
            msg = str(exc)
            print(f"[ERROR] {sql_file}: {msg}", file=sys.stderr)
            records.append(
                {
                    "status": "failed",
                    "input": str(sql_file),
                    "error": msg,
                }
            )
            if args.strict:
                if report_path:
                    write_report(report_path, records, success, failed)
                    print(f"[REPORT] {report_path}")
                return 1

    if report_path:
        write_report(report_path, records, success, failed)
        print(f"[REPORT] {report_path}")

    print(f"[SUMMARY] success={success}, failed={failed}")
    return 0 if failed == 0 else 2


if __name__ == "__main__":
    sys.exit(main())
