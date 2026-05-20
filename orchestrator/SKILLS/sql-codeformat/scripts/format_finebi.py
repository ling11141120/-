#!/usr/bin/env python3
"""Format FineBI SQL files.

Reuses core tokenizer/normalizer/parser/formatter from format_starrocks_insert_select.
Adds FineBI-specific: CTE comment preservation, comment normalization,
FineBI header, no-INSERT entry point, implicit alias 'as' insertion,
between...and merging.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# Import core modules from DML formatter (same directory)
sys.path.insert(0, str(Path(__file__).parent))
from format_starrocks_insert_select import (  # noqa: E402
    SelectBodyParser,
    SelectStatement,
    Token,
    clean_expr,
    compact_ws_tokens,
    fmt_case_when_multiline,
    fmt_join_item,
    fmt_select_list,
    is_case_expr,
    normalize_keywords_in_tokens,
    normalize_spacing,
    remove_backticks,
    split_statements,
    strip_ws_tokens,
    tokenize,
    tokens_text,
)

# Reserved words that should NOT be treated as implicit aliases
_RESERVED = frozenset({
    "select", "from", "where", "and", "or", "on", "group", "order",
    "having", "union", "join", "left", "right", "inner", "cross",
    "full", "limit", "offset", "between", "case", "when", "then",
    "else", "end", "as", "not", "null", "in", "is", "like", "regexp",
    "by", "all", "distinct", "with", "over", "partition",
})

# Condition termination keywords (same as parent + "where")
_CONDITION_TERMINATORS = frozenset({
    "group", "having", "order", "union", "limit",
    "left", "right", "full", "cross", "inner", "join",
    "from", "select", "offset", "where",
})


# ============================================================
# FineBI body parser
# ============================================================


# ============================================================
# FineBI ${...} template expression handling
# ============================================================

_FINEBI_VAR_RE = re.compile(r'\$\{', re.MULTILINE)
_FINEBI_PLACEHOLDER = "__FINEBI_VAR_{}__"
_FINEBI_PLACEHOLDER_RE = re.compile(r'__FINEBI_VAR_(\d+)__')


def extract_finebi_vars(sql: str) -> tuple[str, dict[int, str]]:
    var_dict: dict[int, str] = {}
    result_parts: list[str] = []
    idx = 0
    pos = 0
    while pos < len(sql):
        m = _FINEBI_VAR_RE.search(sql, pos)
        if not m:
            result_parts.append(sql[pos:])
            break
        result_parts.append(sql[pos:m.start()])
        brace_start = m.end() - 1
        depth = 1
        i = m.end()
        while i < len(sql) and depth > 0:
            if sql[i] == '{':
                depth += 1
            elif sql[i] == '}':
                depth -= 1
            i += 1
        original = sql[m.start():i]
        var_dict[idx] = original
        result_parts.append(_FINEBI_PLACEHOLDER.format(idx))
        idx += 1
        pos = i
    return ''.join(result_parts), var_dict


def restore_finebi_vars(text: str, var_dict: dict[int, str]) -> str:
    def _replace(m: re.Match[str]) -> str:
        idx = int(m.group(1))
        original = var_dict.get(idx, m.group(0))
        return original.replace('\n', ' ').replace('\r', '')
    return _FINEBI_PLACEHOLDER_RE.sub(_replace, text)


# ============================================================
# Cast expression protection
# ============================================================

_CAST_PLACEHOLDER = "__CAST_EXPR_{}__"
_CAST_PLACEHOLDER_RE = re.compile(r'__CAST_EXPR_(\d+)__')
_CAST_RE = re.compile(r'\bcast\s*\(', re.IGNORECASE)


def extract_cast_exprs(sql: str) -> tuple[str, dict[int, str]]:
    cast_dict: dict[int, str] = {}
    result_parts: list[str] = []
    idx = 0
    pos = 0
    while pos < len(sql):
        m = _CAST_RE.search(sql, pos)
        if not m:
            result_parts.append(sql[pos:])
            break
        result_parts.append(sql[pos:m.start()])
        paren_start = m.end() - 1
        depth = 1
        i = m.end()
        while i < len(sql) and depth > 0:
            if sql[i] == '(':
                depth += 1
            elif sql[i] == ')':
                depth -= 1
            i += 1
        original = sql[m.start():i]
        cast_dict[idx] = original
        result_parts.append(_CAST_PLACEHOLDER.format(idx))
        idx += 1
        pos = i
    return ''.join(result_parts), cast_dict


def restore_cast_exprs(text: str, cast_dict: dict[int, str]) -> str:
    def _replace(m: re.Match[str]) -> str:
        idx = int(m.group(1))
        return cast_dict.get(idx, m.group(0))
    return _CAST_PLACEHOLDER_RE.sub(_replace, text)

class FineBIBodyParser(SelectBodyParser):
    """SelectBodyParser with fixes for FineBI SQL:

    1. Fixed comma detection in parse_ctes (kw_val doesn't match commas)
    2. Added 'where' to parse_conditions termination list so ON clauses
       don't consume the WHERE keyword
    """

    def parse_ctes(self, stmt: SelectStatement):
        self.expect_and_consume("with")
        while True:
            cte_name = self.peek().value
            self.pos += 1
            self.skip_ws_and_comments()
            if self.kw_val() == "as":
                self.pos += 1
                self.skip_ws_and_comments()
            self.expect_and_consume("(")
            start = self.pos
            depth = 1
            while depth > 0 and self.pos < len(self.tokens):
                t = self.tokens[self.pos]
                if t.kind == "lparen":
                    depth += 1
                elif t.kind == "rparen":
                    depth -= 1
                    if depth == 0:
                        break
                self.pos += 1
            inner_tokens = self.tokens[start:self.pos]
            self.pos += 1

            inner_parser = FineBIBodyParser(inner_tokens)
            inner_parser.pos = 0
            inner_stmt = inner_parser.parse_select_statement()
            stmt.ctes.append((cte_name, inner_stmt))

            self.skip_ws_and_comments()
            t = self.peek()
            if not t or t.kind != "comma":
                break
            self.pos += 1
            self.skip_ws_and_comments()

    def parse_conditions(self) -> list[list[Token]]:
        """Override to add 'where' to termination keywords."""
        conditions: list[list[Token]] = []
        current: list[Token] = []
        paren_depth = 0
        while self.pos < len(self.tokens):
            t = self.peek()
            if t is None:
                break
            if t.kind == "lparen":
                paren_depth += 1
                current.append(self.next())
                continue
            if t.kind == "rparen":
                paren_depth -= 1
                current.append(self.next())
                continue
            if paren_depth == 0 and t.kind in ("keyword", "identifier"):
                v = t.value.lower()
                if v in ("and", "or"):
                    if current:
                        conditions.append(current)
                    current = [self.next()]
                    continue
                if v in _CONDITION_TERMINATORS:
                    if current:
                        conditions.append(current)
                    return conditions
            current.append(self.next())
        if current:
            conditions.append(current)
        return conditions


# ============================================================
# Implicit alias 'as' insertion
# ============================================================

# ============================================================
# Implicit alias 'as' insertion (with single-quote alias support)
# ============================================================

def _insert_implicit_as_in_expr(tokens: list[Token]) -> list[Token]:
    """Insert 'as' keyword before an implicit column alias.

    Also handles single-quote aliases: detects 'as ''alias''' and
    converts to 'as `alias`', and detects implicit single-quote
    aliases (no 'as' keyword) and adds 'as' + backtick wrapper.
    """
    if not tokens:
        return tokens

    end = len(tokens)
    while end > 0 and tokens[end - 1].kind == "whitespace":
        end -= 1
    if end == 0:
        return tokens

    last = tokens[end - 1]

    # Handle single-quote string as alias
    if last.kind == "string":
        before_end = end - 1
        while before_end > 0 and tokens[before_end - 1].kind == "whitespace":
            before_end -= 1
        has_as = (
            before_end >= 2
            and tokens[before_end - 1].kind == "keyword"
            and tokens[before_end - 1].value == "as"
        )
        if has_as:
            alias_val = last.value
            if alias_val.count("'" ) == 2 and alias_val.startswith("'") and alias_val.endswith("'"):
                inner = alias_val[1:-1]
                result = list(tokens[:end - 1])
                result.append(Token("backtick", "`" + inner + "`", 0))
                return result
        else:
            before_end = end - 1
            while before_end > 0 and tokens[before_end - 1].kind == "whitespace":
                before_end -= 1
            if before_end > 0:
                prev = tokens[before_end - 1]
                if prev.kind == "dot":
                    return tokens
            alias_val = last.value
            if alias_val.count("'" ) == 2 and alias_val.startswith("'") and alias_val.endswith("'"):
                inner = alias_val[1:-1]
                result = list(tokens[:end - 1])
                result.append(Token("whitespace", " ", 0))
                result.append(Token("keyword", "as", 0))
                result.append(Token("whitespace", " ", 0))
                result.append(Token("backtick", "`" + inner + "`", 0))
                return result
        return tokens

    if last.kind not in ("identifier", "backtick"):
        return tokens

    alias_lower = last.value.lower().replace("`", "")
    if alias_lower in _RESERVED:
        return tokens

    before_end = end - 1
    while before_end > 0 and tokens[before_end - 1].kind == "whitespace":
        before_end -= 1
    if before_end == 0:
        return tokens

    prev = tokens[before_end - 1]
    if prev.kind == "keyword" and prev.value == "as":
        return tokens
    if prev.kind == "dot":
        return tokens

    result = list(tokens[:before_end])
    result.append(Token("whitespace", " ", 0))
    result.append(Token("keyword", "as", 0))
    result.append(Token("whitespace", " ", 0))
    result.extend(tokens[before_end:])
    return result
def normalize_select_aliases_in_stmt(stmt: SelectStatement) -> None:
    """Recursively insert 'as' for implicit aliases in all select lists."""
    stmt.select_list = [_insert_implicit_as_in_expr(e) for e in stmt.select_list]
    for _, cte_body in stmt.ctes:
        normalize_select_aliases_in_stmt(cte_body)
    for union_stmt in stmt.unions:
        normalize_select_aliases_in_stmt(union_stmt)
    if stmt.from_join:
        for item in stmt.from_join.items:
            if item.subquery:
                normalize_select_aliases_in_stmt(item.subquery)


# ============================================================
# Between...and merging
# ============================================================

def _has_between(tokens: list[Token]) -> bool:
    for t in tokens:
        if t.kind == "keyword" and t.value == "between":
            return True
    return False


def merge_between_conditions(conditions: list[list[Token]]) -> list[list[Token]]:
    """Merge 'between X' and 'and Y' conditions."""
    if not conditions:
        return conditions
    result: list[list[Token]] = []
    i = 0
    while i < len(conditions):
        cond = strip_ws_tokens(conditions[i])
        if _has_between(cond) and i + 1 < len(conditions):
            next_cond = strip_ws_tokens(conditions[i + 1])
            if next_cond and next_cond[0].kind == "keyword" and next_cond[0].value == "and":
                merged = list(cond)
                merged.append(Token("whitespace", " ", 0))
                merged.extend(next_cond)
                result.append(merged)
                i += 2
                continue
        result.append(cond)
        i += 1
    return result


# ============================================================
# Comment normalization
# ============================================================

def normalize_comment(line: str) -> str:
    stripped = line.strip()
    if not stripped.startswith("--"):
        return "-- " + stripped.lstrip("-").strip()
    dashes = 0
    for ch in stripped:
        if ch == "-":
            dashes += 1
        else:
            break
    content = stripped[dashes:].strip()
    if dashes > 2:
        return "-- " + content
    elif dashes == 2:
        if content:
            return "-- " + content
        return "--"
    return stripped


# ============================================================
# CTE comment extraction
# ============================================================

def extract_cte_comments(sql: str) -> dict[str, str]:
    cte_pattern = re.compile(r"([a-zA-Z_]\w*)\s+as\s*\(", re.IGNORECASE)
    comment_pattern = re.compile(r"^\s*(--+)", re.IGNORECASE)
    lines = sql.split("\n")

    cte_entries: list[tuple[int, str]] = []
    for i, line in enumerate(lines):
        m = cte_pattern.search(line)
        if m:
            cte_entries.append((i, m.group(1).lower()))

    if not cte_entries:
        return {}

    cte_comments: dict[str, str] = {}

    # First CTE comment
    first_line_no, first_cte_name = cte_entries[0]
    first_comment_lines: list[str] = []
    j = first_line_no - 1
    while j >= 0:
        stripped = lines[j].strip()
        if comment_pattern.match(stripped):
            first_comment_lines.insert(0, normalize_comment(stripped))
        elif stripped == "":
            pass
        else:
            break
        j -= 1
    if first_comment_lines:
        cte_comments[first_cte_name] = "\n".join(first_comment_lines)

    # Inter-CTE comments
    for idx in range(1, len(cte_entries)):
        curr_line_no, cte_name = cte_entries[idx]
        prev_line_no = cte_entries[idx - 1][0]
        comment_lines: list[str] = []
        j = curr_line_no - 1
        while j > prev_line_no:
            stripped = lines[j].strip()
            if comment_pattern.match(stripped):
                comment_lines.insert(0, normalize_comment(stripped))
            elif stripped in ("", ",", "),"):
                pass
            elif stripped == ")" or stripped.rstrip(",").rstrip() == ")":
                break
            else:
                break
            j -= 1
        if comment_lines:
            cte_comments[cte_name] = "\n".join(comment_lines)

    return cte_comments


# ============================================================
# FineBI header
# ============================================================

HEADER_PATTERN = re.compile(r"^\s*--\s*应用报表", re.MULTILINE)


def has_finebi_header(sql: str) -> bool:
    return bool(HEADER_PATTERN.search(sql[:2000]))


def generate_finebi_header(report_path: str, report_name: str) -> str:
    sep = "-" * 49
    if report_name:
        full = f"{report_path}/{report_name}" if report_path else report_name
    else:
        full = report_path
    return f"""{sep}
-- 应用报表：{full}
{sep}

"""


# ============================================================
# FineBI statement formatter
# ============================================================

def fmt_finebi_body(
    stmt: SelectStatement,
    select_indent: int = 0,
    cte_comments: dict[str, str] | None = None,
) -> list[str]:
    """Format the body of a FineBI SELECT/WITH statement."""
    if cte_comments is None:
        cte_comments = {}

    lines: list[str] = []

    # --- CTEs ---
    for idx, (cte_name, cte_body) in enumerate(stmt.ctes):
        comment = cte_comments.get(cte_name)
        if comment:
            lines.append(comment)

        if idx == 0:
            lines.append(f"{' ' * select_indent}with {cte_name} as (")
        else:
            lines.append(f"{' ' * select_indent}, {cte_name} as (")

        body_indent = select_indent + 4
        inner = fmt_finebi_body(
            cte_body, select_indent=body_indent, cte_comments=cte_comments
        )
        if inner:
            inner[0] = " " * body_indent + inner[0]
        lines.extend(inner)
        lines.append(f"{' ' * select_indent})")

    # --- Main SELECT ---
    if stmt.select_list:
        select_lines = fmt_select_list(
            stmt.select_list, select_indent, is_subquery=bool(stmt.ctes)
        )
        lines.extend(select_lines)

    if stmt.from_join:
        for item in stmt.from_join.items:
            join_lines = fmt_join_item(item, select_indent)
            lines.extend(join_lines)

    if stmt.where_conditions:
        where_indent = select_indent + 1
        merged = merge_between_conditions(stmt.where_conditions)
        for ci, cond in enumerate(merged):
            if ci == 0:
                cond_text = "where " + tokens_text(cond)
                lines.append(" " * where_indent + cond_text)
            else:
                lines.append(" " * (where_indent + 2) + tokens_text(cond))

    if stmt.group_by_tokens:
        gb_clean = strip_ws_tokens(stmt.group_by_tokens)
        gb_text = "group by " + tokens_text(gb_clean)
        lines.append(f"{' ' * (select_indent + 1)}{gb_text}")

    if stmt.having_tokens:
        hv_clean = strip_ws_tokens(stmt.having_tokens)
        lines.append(f"{' ' * (select_indent + 1)}having {tokens_text(hv_clean)}")

    if stmt.order_by_tokens:
        ob_clean = strip_ws_tokens(stmt.order_by_tokens)
        lines.append(f"{' ' * (select_indent + 1)}order by {tokens_text(ob_clean)}")

    for union_stmt in stmt.unions:
        lines.append("")
        lines.append("union all")
        lines.append("")
        union_lines = fmt_finebi_body(union_stmt, select_indent, {})
        lines.extend(union_lines)

    return lines


# ============================================================
# Main formatter entry point
# ============================================================

def format_finebi(
    sql: str,
    file_path: Path | None = None,
    report_path: str = "",
    report_name: str = "",
) -> str:
    """Format a complete FineBI SQL file.

    Processing pipeline:
    1. Pre-extract ${...} template expressions -> placeholders
    2. Pre-extract cast(... as ...) expressions -> placeholders
    3. Tokenize -> normalize -> parse -> format (core pipeline)
    4. Restore cast placeholders
    5. Restore ${...} placeholders (with flattening)
    """
    body = sql.replace("\r\n", "\n").replace("\r", "\n").strip()
    if not body:
        return ""

    # --- Phase 1: Pre-extract ${...} template expressions ---
    body, finebi_vars = extract_finebi_vars(body)

    # --- Phase 2: Pre-extract cast(... as ...) expressions ---
    body, cast_exprs = extract_cast_exprs(body)

    # --- Phase 3: Core formatting ---
    cte_comments = extract_cte_comments(body)

    header = ""
    body_without_header = body
    if has_finebi_header(body):
        lines_b = body.split("\n")
        in_sep = 0
        header_end = 0
        for i, line in enumerate(lines_b):
            stripped = line.strip()
            if (stripped.startswith("-") and len(stripped) >= 40
                    and all(c == "-" for c in stripped)):
                in_sep += 1
                header_end = i + 1
                if in_sep >= 2:
                    break
        header = "\n".join(lines_b[:header_end]) + "\n\n"
        body_without_header = "\n".join(lines_b[header_end:]).strip()
    elif report_path:
        header = generate_finebi_header(report_path, report_name)

    statements = split_statements(body_without_header)

    formatted_stmts: list[str] = []
    for stmt_raw in statements:
        stmt = stmt_raw.strip()
        if not stmt:
            continue

        tokens = tokenize(stmt)
        tokens = remove_backticks(tokens)
        tokens = normalize_keywords_in_tokens(tokens)
        tokens = normalize_spacing(tokens)

        while tokens and tokens[0].kind in ("whitespace", "comment"):
            tokens = tokens[1:]

        parser = FineBIBodyParser(tokens)
        parser.pos = 0
        try:
            parsed = parser.parse_select_statement()
        except Exception:
            text = tokens_text(tokens)
            text = re.sub(r"[ \t]+", " ", text).strip()
            formatted_stmts.append(f"{text}\n;")
            continue

        normalize_select_aliases_in_stmt(parsed)

        select_lines = fmt_finebi_body(
            parsed, select_indent=0, cte_comments=cte_comments
        )
        result_lines = list(select_lines)
        result_lines.append(";")
        formatted_stmts.append("\n".join(result_lines))

    result = header + "\n\n".join(formatted_stmts)
    if not result.endswith("\n"):
        result += "\n"

    # --- Phase 4: Restore cast expressions ---
    result = restore_cast_exprs(result, cast_exprs)

    # --- Phase 5: Restore FineBI ${...} expressions (with flattening) ---
    result = restore_finebi_vars(result, finebi_vars)

    return result
def validate_trigger(path: Path, sql: str) -> None:
    if path.suffix.lower() != ".sql":
        raise ValueError("target must be a .sql file")

    path_str = str(path.resolve()).replace("\\", "/")
    if ("Application/FineBI" not in path_str
            and "application/finebi" not in path_str.lower()):
        raise ValueError("target file must be under Application/FineBI directory")

    if not re.search(r"\b(select|with)\b", sql, flags=re.IGNORECASE):
        raise ValueError("target file does not contain SELECT or WITH")


# ============================================================
# CLI
# ============================================================

def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path, help="FineBI SQL file to format")
    parser.add_argument("--write", action="store_true", help="rewrite the file in place")
    parser.add_argument("--check", action="store_true", help="exit non-zero if changes needed")
    parser.add_argument("--report-path", type=str, default="")
    parser.add_argument("--report-name", type=str, default="")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")

    args = parse_args(argv)
    path = args.path
    sql = path.read_text(encoding="utf-8")

    validate_trigger(path, sql)

    formatted = format_finebi(
        sql,
        file_path=path,
        report_path=args.report_path,
        report_name=args.report_name,
    )

    if args.check:
        original = sql.replace("\r\n", "\n").replace("\r", "\n")
        if formatted.rstrip("\n") != original.rstrip("\n"):
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
