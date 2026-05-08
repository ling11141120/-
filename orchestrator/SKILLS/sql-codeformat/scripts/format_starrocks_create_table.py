#!/usr/bin/env python3
"""Format project StarRocks CREATE TABLE DDL files."""

from __future__ import annotations

import argparse
import datetime as _dt
import re
import sys
from dataclasses import dataclass
from pathlib import Path


KEYWORDS = (
    "create table",
    "create table if not exists",
    "primary key",
    "duplicate key",
    "aggregate key",
    "unique key",
    "comment",
    "partition by",
    "distributed by hash",
    "properties",
    "buckets",
    "not null",
    "default",
    "null",
)


@dataclass
class Column:
    name: str
    dtype: str
    attrs: str
    comment: str | None
    raw: str


def lower_outside_quotes(text: str) -> str:
    out: list[str] = []
    quote: str | None = None
    i = 0
    while i < len(text):
        ch = text[i]
        if quote:
            out.append(ch)
            if ch == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    out.append(text[i + 1])
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"'):
            quote = ch
            out.append(ch)
        else:
            out.append(ch.lower())
        i += 1
    return "".join(out)


def normalize_space(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip())


def split_top_level(text: str, delimiter: str = ",") -> list[str]:
    parts: list[str] = []
    start = 0
    depth = 0
    quote: str | None = None
    i = 0
    while i < len(text):
        ch = text[i]
        if quote:
            if ch == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"'):
            quote = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth = max(0, depth - 1)
        elif ch == delimiter and depth == 0:
            parts.append(text[start:i].strip())
            start = i + 1
        i += 1
    tail = text[start:].strip()
    if tail:
        parts.append(tail)
    return parts


def find_matching_paren(text: str, open_index: int) -> int:
    depth = 0
    quote: str | None = None
    i = open_index
    while i < len(text):
        ch = text[i]
        if quote:
            if ch == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"'):
            quote = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    raise ValueError("unmatched parenthesis in CREATE TABLE statement")


def find_statement_end(text: str, start: int) -> int:
    depth = 0
    quote: str | None = None
    i = start
    while i < len(text):
        ch = text[i]
        if quote:
            if ch == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"'):
            quote = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth = max(0, depth - 1)
        elif ch == ";" and depth == 0:
            return i + 1
        i += 1
    return len(text)


def tokenize_sql(text: str) -> list[str]:
    tokens: list[str] = []
    cur: list[str] = []
    depth = 0
    quote: str | None = None
    i = 0
    while i < len(text):
        ch = text[i]
        if quote:
            cur.append(ch)
            if ch == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    cur.append(text[i + 1])
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"'):
            quote = ch
            cur.append(ch)
        elif ch == "(":
            depth += 1
            cur.append(ch)
        elif ch == ")":
            depth = max(0, depth - 1)
            cur.append(ch)
        elif ch.isspace() and depth == 0:
            if cur:
                tokens.append("".join(cur))
                cur = []
        else:
            cur.append(ch)
        i += 1
    if cur:
        tokens.append("".join(cur))
    return tokens


def normalize_dtype(dtype: str) -> str:
    dtype = normalize_space(lower_outside_quotes(dtype))
    dtype = re.sub(r"\b(bigint|int|tinyint)\s*\(\s*\d+\s*\)", r"\1", dtype)
    dtype = re.sub(r"\bvarchar\s*\(\s*65533\s*\)", "string", dtype)
    dtype = re.sub(r"\s+\(", "(", dtype)
    return dtype


def normalize_comment(comment: str | None) -> str:
    if comment is None:
        return ""
    return f'comment "{comment}"'


def parse_column(item: str) -> Column | None:
    original = normalize_space(item.strip().lstrip(",").strip().rstrip(","))
    if not original:
        return None
    first_word = re.split(r"\s+", original, maxsplit=1)[0].lower()
    if first_word in {"primary", "duplicate", "aggregate", "unique", "key", "index", "constraint"}:
        return None

    m = re.search(r"\bcomment\s+(['\"])(.*?)\1\s*$", original, flags=re.IGNORECASE | re.DOTALL)
    comment: str | None = None
    before_comment = original
    if m:
        comment = m.group(2)
        before_comment = original[: m.start()].strip()

    tokens = tokenize_sql(before_comment)
    if len(tokens) < 2:
        return Column(original, "", "", normalize_comment(comment), original)

    name = tokens[0].strip("`")
    dtype = normalize_dtype(tokens[1])
    attr_tokens = tokens[2:]
    attrs: list[str] = []
    i = 0
    while i < len(attr_tokens):
        token = attr_tokens[i]
        low = token.lower()
        if low == "null":
            i += 1
            continue
        if low == "not" and i + 1 < len(attr_tokens) and attr_tokens[i + 1].lower() == "null":
            attrs.append("not null")
            i += 2
            continue
        attrs.append(lower_outside_quotes(token))
        i += 1

    return Column(name, dtype, normalize_space(" ".join(attrs)), normalize_comment(comment), original)


def format_columns(column_items: list[str]) -> list[str]:
    columns: list[Column] = []
    entries: list[Column] = []
    for item in column_items:
        col = parse_column(item)
        if col is None:
            entries.append(Column("", "", "", "", lower_outside_quotes(normalize_space(item))))
        else:
            columns.append(col)
            entries.append(col)

    max_name = max((len(c.name) for c in columns), default=0)
    max_type = max((len(c.dtype) for c in columns), default=0)
    max_attrs = max((len(c.attrs) for c in columns), default=0)
    lines: list[str] = []
    for idx, col in enumerate(entries):
        prefix = "     " if idx == 0 else "    ,"
        if col.name:
            body = f"{col.name.ljust(max_name + 1)}{col.dtype.ljust(max_type + 1)}"
            if max_attrs:
                body += col.attrs.ljust(max_attrs + 1)
            elif col.attrs:
                body += col.attrs + " "
            body += col.comment
            lines.append(prefix + body.rstrip())
        else:
            lines.append(prefix + col.raw)
    return lines


def extract_clause(pattern: str, text: str) -> tuple[str, str]:
    m = re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL)
    if not m:
        return "", text
    clause = m.group(0).strip()
    remainder = (text[: m.start()] + "\n" + text[m.end() :]).strip()
    return clause, remainder


def extract_parenthesized_clause(keyword_pattern: str, text: str) -> tuple[str, str]:
    m = re.search(keyword_pattern, text, flags=re.IGNORECASE)
    if not m:
        return "", text
    open_idx = text.find("(", m.end())
    if open_idx == -1:
        return "", text
    close_idx = find_matching_paren(text, open_idx)
    clause = text[m.start() : close_idx + 1].strip()
    remainder = (text[: m.start()] + "\n" + text[close_idx + 1 :]).strip()
    return clause, remainder


def format_properties(clause: str) -> str:
    if not clause:
        return ""
    open_idx = clause.find("(")
    close_idx = find_matching_paren(clause, open_idx)
    body = clause[open_idx + 1 : close_idx]
    props = [normalize_space(p) for p in split_top_level(body) if p.strip()]
    lines = ["properties ("]
    for idx, prop in enumerate(props):
        suffix = "," if idx < len(props) - 1 else ""
        lines.append(f"    {prop}{suffix}")
    lines.append(")")
    return "\n".join(lines)


def parse_properties(clause: str) -> dict[str, str]:
    if not clause:
        return {}
    open_idx = clause.find("(")
    if open_idx == -1:
        return {}
    close_idx = find_matching_paren(clause, open_idx)
    body = clause[open_idx + 1 : close_idx]
    props: dict[str, str] = {}
    for prop in split_top_level(body):
        m = re.match(r'\s*["\']([^"\']+)["\']\s*=\s*["\'](.*?)["\']\s*$', prop, flags=re.DOTALL)
        if m:
            props[m.group(1).lower()] = m.group(2)
    return props


def parse_base_date(args: argparse.Namespace) -> _dt.date:
    if args.date:
        return _dt.date.fromisoformat(args.date[:10])
    return _dt.date.today()


def next_month_start(date_value: _dt.date) -> _dt.date:
    year = date_value.year + (1 if date_value.month == 12 else 0)
    month = 1 if date_value.month == 12 else date_value.month + 1
    return _dt.date(year, month, 1)


def normalize_range_values(clause: str) -> str:
    clause = lower_outside_quotes(normalize_space(clause))
    return re.sub(
        r"values\s*\[\s*\(([^)]*)\)\s*,\s*\(([^)]*)\)\s*\)",
        r"values less than (\2)",
        clause,
        flags=re.IGNORECASE,
    )


def normalize_partition(clause: str, properties_clause: str, args: argparse.Namespace) -> str:
    if not clause:
        return ""
    clause = lower_outside_quotes(normalize_space(clause))
    if re.search(r"\bpartition\s+by\s+date_trunc\s*\(", clause, flags=re.IGNORECASE):
        return clause

    m = re.match(r"\bpartition\s+by\s+range\s*\(([^)]*)\)", clause, flags=re.IGNORECASE)
    if not m:
        return normalize_range_values(clause)

    props = parse_properties(properties_clause)
    time_unit = props.get("dynamic_partition.time_unit", "").lower()
    base_date = parse_base_date(args)
    if time_unit == "day":
        partition_name = "p" + base_date.strftime("%Y%m%d")
        upper_bound = (base_date + _dt.timedelta(days=1)).isoformat()
    elif time_unit == "month":
        partition_name = "p" + base_date.strftime("%Y%m")
        upper_bound = next_month_start(base_date).isoformat()
    else:
        return normalize_range_values(clause)

    range_expr = normalize_space(m.group(1))
    clause = f"partition by range({range_expr})\n(partition {partition_name} values less than (\"{upper_bound}\"))"
    return clause


def format_table_clauses(remainder: str, args: argparse.Namespace) -> list[str]:
    text = remainder.strip().rstrip(";").strip()
    text = re.sub(r"\bengine\s*=\s*\w+\s*", " ", text, flags=re.IGNORECASE)

    properties, text = extract_parenthesized_clause(r"\bproperties\b", text)
    distributed, text = extract_clause(r"\bdistributed\s+by\s+hash\s*\([^)]*\)(?:\s+buckets\s+\d+)?", text)
    comment, text = extract_clause(r"\bcomment\s+(['\"])(.*?)\1", text)
    key, text = extract_clause(r"\b(?:primary|duplicate|aggregate|unique)\s+key\s*\([^)]*\)", text)

    partition = ""
    m = re.search(r"\bpartition\s+by\b", text, flags=re.IGNORECASE)
    if m:
        partition = text[m.start() :].strip()
        text = text[: m.start()].strip()

    clauses: list[str] = []
    if key:
        clauses.append(lower_outside_quotes(normalize_space(key)))
    if comment:
        clauses.append(lower_outside_quotes(normalize_space(comment)))
    if partition:
        clauses.append(normalize_partition(partition, properties, args))
    if distributed:
        clauses.append(lower_outside_quotes(normalize_space(distributed)))
    if properties:
        clauses.append(format_properties(properties))
    extra = normalize_space(text)
    if extra:
        clauses.append(lower_outside_quotes(extra))
    return clauses


def remove_preceding_drop(before: str) -> str:
    pattern = r"(?is)(?:^|\n)\s*drop\s+table\s+if\s+exists\s+[`\".\w]+\s*;\s*$"
    return re.sub(pattern, "\n", before).rstrip()


def format_create_table(sql: str, path: Path, args: argparse.Namespace) -> str:
    sql = sql.replace("`", "")
    m = re.search(r"\bcreate\s+table\b(?:\s+if\s+not\s+exists)?\s+([^\s(]+)", sql, flags=re.IGNORECASE)
    if not m:
        raise ValueError("no CREATE TABLE statement found")

    open_idx = sql.find("(", m.end())
    if open_idx == -1:
        raise ValueError("CREATE TABLE statement has no column block")
    close_idx = find_matching_paren(sql, open_idx)
    stmt_end = find_statement_end(sql, close_idx)

    before = remove_preceding_drop(sql[: m.start()])
    after = sql[stmt_end:].strip()
    column_body = sql[open_idx + 1 : close_idx]
    remainder = sql[close_idx + 1 : stmt_end].strip()

    layer_name = path.parent.parent.name.lower()
    db_name = path.name[:3].lower()
    table_name = path.stem
    qualified = f"{db_name}.{table_name}"

    lines: list[str] = []
    if before.strip():
        lines.append(before.strip())
        lines.append("")

    if layer_name in ("ods", "ods_log"):
        missing = [
            name
            for name, value in (
                ("--source-instance", args.source_instance),
                ("--source-table", args.source_table),
                ("--source-owner", args.source_owner),
            )
            if not value
        ]
        if missing:
            raise ValueError("ods files require " + ", ".join(missing))
        developer = args.developer or ""
        today = args.date or _dt.date.today().isoformat()
        lines.extend(
            [
                "----------------------------------------------------------------",
                f"-- 目标表：{table_name}",
                f"-- 来源实例：{args.source_instance}",
                f"-- 来源表：{args.source_table}",
                f"-- 来源负责人：{args.source_owner}",
                f"-- 开发人：{developer}",
                f"-- 开发日期：{today}",
                "----------------------------------------------------------------",
                "",
            ]
        )

    lines.append(f"create table if not exists {qualified} (")
    lines.extend(format_columns(split_top_level(column_body)))
    lines.append(")")
    lines.extend(format_table_clauses(remainder, args))
    lines.append(";")

    if after:
        lines.append("")
        lines.append(after)
    return "\n".join(lines).rstrip() + "\n"


def validate_trigger(path: Path, sql: str) -> None:
    if path.suffix.lower() != ".sql":
        raise ValueError("target must be a .sql file")
    if path.parent.name.lower() != "ddl":
        raise ValueError("target file parent directory must be named ddl")
    if "view" in path.name.lower():
        raise ValueError("refusing to format files whose name contains view")
    if not re.search(r"\bcreate\s+table\b", sql, flags=re.IGNORECASE):
        raise ValueError("target file does not contain CREATE TABLE")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path, help="SQL file to format")
    parser.add_argument("--write", action="store_true", help="rewrite the file in place")
    parser.add_argument("--check", action="store_true", help="exit non-zero if formatting would change the file")
    parser.add_argument("--source-instance", help="ODS source instance for the standard header")
    parser.add_argument("--source-table", help="ODS source table for the standard header")
    parser.add_argument("--source-owner", help="ODS source owner for the standard header")
    parser.add_argument("--developer", help="developer id for ODS headers")
    parser.add_argument("--date", help="development date for ODS headers, defaults to today")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    args = parse_args(argv)
    path = args.path
    sql = path.read_text(encoding="utf-8")
    validate_trigger(path, sql)
    formatted = format_create_table(sql, path, args)

    if args.check:
        if formatted != sql:
            print(f"{path}: needs formatting", file=sys.stderr)
            return 1
        return 0
    if args.write:
        path.write_text(formatted, encoding="utf-8", newline="\n")
    else:
        sys.stdout.write(formatted)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(2)
