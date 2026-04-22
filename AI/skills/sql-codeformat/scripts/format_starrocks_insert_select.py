#!/usr/bin/env python3
"""Conservatively format project StarRocks INSERT SELECT DML files."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


SQL_KEYWORDS = (
    "insert overwrite",
    "insert into",
    "union all",
    "group by",
    "order by",
    "left join",
    "right join",
    "full join",
    "cross join",
    "inner join",
    "case when",
    "select",
    "with",
    "from",
    "join",
    "where",
    "having",
    "on",
    "and",
    "or",
    "as",
    "case",
    "when",
    "then",
    "else",
    "end",
    "between",
    "is not null",
    "is null",
    "not null",
    "null",
    "distinct",
    "over",
    "partition by",
)

FUNCTION_NAMES = (
    "abs",
    "avg",
    "bitmap_count",
    "cast",
    "coalesce",
    "concat",
    "count",
    "date",
    "date_add",
    "date_sub",
    "datediff",
    "hours_add",
    "if",
    "ifnull",
    "max",
    "min",
    "round",
    "sum",
    "variance",
)

CLAUSE_INDENTS = (
    (re.compile(r"^\s*select\b", re.IGNORECASE), "select"),
    (re.compile(r"^\s*from\b", re.IGNORECASE), "  from"),
    (re.compile(r"^\s*where\b", re.IGNORECASE), " where"),
    (re.compile(r"^\s*group\s+by\b", re.IGNORECASE), " group by"),
    (re.compile(r"^\s*having\b", re.IGNORECASE), "having"),
    (re.compile(r"^\s*order\s+by\b", re.IGNORECASE), " order by"),
    (re.compile(r"^\s*union\s+all\b", re.IGNORECASE), "union all"),
    (re.compile(r"^\s*on\b", re.IGNORECASE), "    on"),
    (re.compile(r"^\s*and\b", re.IGNORECASE), "   and"),
    (re.compile(r"^\s*or\b", re.IGNORECASE), "    or"),
    (re.compile(r"^\s*left\s+join\b", re.IGNORECASE), "  left join"),
    (re.compile(r"^\s*right\s+join\b", re.IGNORECASE), " right join"),
    (re.compile(r"^\s*full\s+join\b", re.IGNORECASE), "  full join"),
    (re.compile(r"^\s*cross\s+join\b", re.IGNORECASE), " cross join"),
    (re.compile(r"^\s*inner\s+join\b", re.IGNORECASE), "  join"),
    (re.compile(r"^\s*join\b", re.IGNORECASE), "  join"),
)


def split_comment(line: str) -> tuple[str, str]:
    quote: str | None = None
    i = 0
    while i < len(line):
        ch = line[i]
        if quote:
            if ch == quote:
                if i + 1 < len(line) and line[i + 1] == quote:
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"', "`"):
            quote = ch
            i += 1
            continue
        if ch == "-" and i + 1 < len(line) and line[i + 1] == "-":
            return line[:i], line[i:]
        i += 1
    return line, ""


def transform_code_segments(text: str, transform) -> str:
    out: list[str] = []
    quote: str | None = None
    buf: list[str] = []
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
        if ch in ("'", '"', "`"):
            if buf:
                out.append(transform("".join(buf)))
                buf = []
            quote = ch
            out.append(ch)
        else:
            buf.append(ch)
        i += 1
    if buf:
        out.append(transform("".join(buf)))
    return "".join(out)


def normalize_keywords(code: str) -> str:
    def lower_code(part: str) -> str:
        result = part
        for keyword in sorted(SQL_KEYWORDS, key=len, reverse=True):
            pattern = r"\b" + r"\s+".join(map(re.escape, keyword.split())) + r"\b"
            result = re.sub(pattern, keyword, result, flags=re.IGNORECASE)
        for func in FUNCTION_NAMES:
            result = re.sub(rf"\b{re.escape(func)}\s*(?=\()", func, result, flags=re.IGNORECASE)
        result = re.sub(r"\binner\s+join\b", "join", result, flags=re.IGNORECASE)
        return result

    return transform_code_segments(code, lower_code)


def normalize_spaces(code: str) -> str:
    code = re.sub(r"[ \t]+", " ", code.rstrip())
    code = re.sub(r"\s*,\s*", ", ", code)
    code = re.sub(r"\s*(?<![<>!=])=(?!=)\s*", " = ", code)
    code = re.sub(r"\s+", " ", code)
    code = re.sub(r"\(\s+", "(", code)
    code = re.sub(r"\s+\)", ")", code)
    return code.strip()


def format_clause_line(line: str) -> str:
    raw = line.rstrip()
    code, comment = split_comment(raw)
    if not code.strip():
        return raw

    formatted_code = normalize_keywords(code)
    if formatted_code.strip() == ";":
        return ";"
    return formatted_code + comment


def split_statements(sql: str) -> list[str]:
    statements: list[str] = []
    start = 0
    quote: str | None = None
    i = 0
    while i < len(sql):
        ch = sql[i]
        if quote:
            if ch == quote:
                if i + 1 < len(sql) and sql[i + 1] == quote:
                    i += 2
                    continue
                quote = None
            i += 1
            continue
        if ch in ("'", '"', "`"):
            quote = ch
        elif ch == ";":
            statements.append(sql[start:i])
            start = i + 1
        i += 1
    tail = sql[start:]
    if tail.strip():
        statements.append(tail)
    return statements


def format_statement(statement: str) -> str:
    raw_lines = statement.replace("\r\n", "\n").replace("\r", "\n").split("\n")
    lines: list[str] = []
    blank_pending = False
    for raw in raw_lines:
        if not raw.strip():
            blank_pending = bool(lines)
            continue
        formatted = format_clause_line(raw)
        if blank_pending and lines and lines[-1] != "":
            lines.append("")
        lines.append(formatted.rstrip())
        blank_pending = False

    while lines and lines[0] == "":
        lines.pop(0)
    while lines and lines[-1] == "":
        lines.pop()
    if lines and lines[-1].endswith(";"):
        lines[-1] = lines[-1].rstrip(";").rstrip()
    lines.append(";")
    return "\n".join(lines)


def format_insert_select(sql: str) -> str:
    prefix = ""
    body = sql.replace("\r\n", "\n").replace("\r", "\n").strip()
    if not body:
        return ""

    statements = split_statements(body)
    formatted = [format_statement(stmt) for stmt in statements if stmt.strip()]
    return prefix + "\n\n".join(formatted).rstrip() + "\n"


def validate_trigger(path: Path, sql: str) -> None:
    if path.suffix.lower() != ".sql":
        raise ValueError("target must be a .sql file")
    if path.parent.name.lower() != "dml":
        raise ValueError("target file parent directory must be named dml")
    if not re.search(r"\binsert\s+(into|overwrite)\b", sql, flags=re.IGNORECASE):
        raise ValueError("target file does not contain INSERT INTO or INSERT OVERWRITE")
    if not re.search(r"\b(select|with)\b", sql, flags=re.IGNORECASE):
        raise ValueError("target file does not contain SELECT or WITH")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path, help="SQL file to format")
    parser.add_argument("--write", action="store_true", help="rewrite the file in place")
    parser.add_argument("--check", action="store_true", help="exit non-zero if formatting would change the file")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    args = parse_args(argv)
    path = args.path
    sql = path.read_text(encoding="utf-8")
    validate_trigger(path, sql)
    formatted = format_insert_select(sql)

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
