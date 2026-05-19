#!/usr/bin/env python3
"""Format StarRocks INSERT SELECT DML files.

Conservative but thorough formatting: normalizes keywords, aligns clauses,
formats subqueries, case-when, join blocks, and select lists.
"""

from __future__ import annotations

import argparse
import re
import sys
from datetime import date
from pathlib import Path
from typing import Optional

SQL_KEYWORDS = (
    "insert overwrite", "insert into",
    "union all",
    "group by", "order by",
    "left join", "right join", "full join", "cross join", "inner join",
    "case when", "when", "then", "else",
    "select", "with", "from", "join", "where", "having",
    "on", "and", "or", "as",
    "case", "end",
    "between",
    "is not null", "is null", "not null", "null",
    "distinct",
    "over", "partition by",
)

FUNCTION_NAMES = (
    "abs", "avg", "bitmap_count", "cast", "coalesce", "concat",
    "count", "date", "date_add", "date_sub", "datediff",
    "hours_add", "if", "ifnull", "max", "min", "round", "sum", "variance",
)

TYPE_KEYWORDS = (
    "date", "int", "bigint", "varchar", "decimal", "string",
    "boolean", "double", "float", "tinyint", "smallint",
    "char", "text", "datetime", "timestamp",
)

CLAUSE_KEYWORDS = {
    "select", "from", "where", "group", "having", "order",
    "on", "left", "right", "full", "cross", "inner", "join",
    "union", "insert", "with",
}


class Token:
    __slots__ = ("kind", "value", "pos")
    def __init__(self, kind: str, value: str, pos: int):
        self.kind = kind
        self.value = value
        self.pos = pos
    def __repr__(self):
        return f"Token({self.kind!r}, {self.value!r})"


def tokenize(sql: str) -> list[Token]:
    tokens: list[Token] = []
    i, n = 0, len(sql)
    while i < n:
        ch = sql[i]
        if ch in " \t\r\n":
            j = i
            while j < n and sql[j] in " \t\r\n":
                j += 1
            tokens.append(Token("whitespace", sql[i:j], i))
            i = j
            continue
        if ch == "-" and i + 1 < n and sql[i + 1] == "-":
            j = sql.find("\n", i)
            if j == -1: j = n
            tokens.append(Token("comment", sql[i:j], i))
            i = j
            continue
        if ch == "/" and i + 1 < n and sql[i + 1] == "*":
            j = sql.find("*/", i + 2)
            if j == -1: j = n
            else: j += 2
            tokens.append(Token("comment", sql[i:j], i))
            i = j
            continue
        if ch in ("'", '"'):
            quote = ch
            j = i + 1
            while j < n:
                if sql[j] == quote:
                    if j + 1 < n and sql[j + 1] == quote:
                        j += 2
                        continue
                    j += 1
                    break
                j += 1
            tokens.append(Token("string", sql[i:j], i))
            i = j
            continue
        if ch == "`":
            j = i + 1
            while j < n and sql[j] != "`":
                j += 1
            if j < n: j += 1
            tokens.append(Token("backtick", sql[i:j], i))
            i = j
            continue
        if ch == "$" and i + 1 < n and sql[i + 1] == "{":
            j = sql.find("}", i)
            if j == -1: j = n
            else: j += 1
            tokens.append(Token("variable", sql[i:j], i))
            i = j
            continue
        if ch.isdigit() or (ch == "." and i + 1 < n and sql[i + 1].isdigit()):
            j = i
            if ch == ".": j += 1
            while j < n and sql[j].isdigit(): j += 1
            if j < n and sql[j] == "." and j + 1 < n and sql[j + 1].isdigit():
                j += 1
                while j < n and sql[j].isdigit(): j += 1
            tokens.append(Token("number", sql[i:j], i))
            i = j
            continue
        if ch == ",":
            tokens.append(Token("comma", ",", i))
            i += 1
            continue
        if ch == ";":
            tokens.append(Token("semicolon", ";", i))
            i += 1
            continue
        if ch == "(":
            tokens.append(Token("lparen", "(", i))
            i += 1
            continue
        if ch == ")":
            tokens.append(Token("rparen", ")", i))
            i += 1
            continue
        if ch in "<>!=|&^~+-*/%":
            j = i
            while j < n and sql[j] in "<>!=|&^~+-*/%":
                j += 1
            tokens.append(Token("operator", sql[i:j], i))
            i = j
            continue
        if ch == ".":
            tokens.append(Token("dot", ".", i))
            i += 1
            continue
        if ch.isalpha() or ch == "_":
            j = i
            while j < n and (sql[j].isalnum() or sql[j] == "_"):
                j += 1
            tokens.append(Token("identifier", sql[i:j], i))
            i = j
            continue
        tokens.append(Token("other", ch, i))
        i += 1
    return tokens


def tokens_text(tokens: list[Token]) -> str:
    return "".join(t.value for t in tokens)


def normalize_keywords_in_tokens(tokens: list[Token]) -> list[Token]:
    result: list[Token] = []
    i = 0
    while i < len(tokens):
        t = tokens[i]
        if t.kind == "identifier":
            matched = False
            for kw in sorted(SQL_KEYWORDS, key=len, reverse=True):
                parts = kw.split()
                if len(parts) > 1:
                    if i + len(parts) <= len(tokens):
                        all_id = all(
                            tokens[i + k].kind == "identifier"
                            and tokens[i + k].value.lower() == parts[k]
                            for k in range(len(parts))
                        )
                        if all_id:
                            val = kw
                            if kw == "inner join": val = "join"
                            result.append(Token("keyword", val, t.pos))
                            i += len(parts)
                            matched = True
                            break
            if matched: continue
            lower = t.value.lower()
            if lower in ("inner",):
                result.append(t)
                i += 1
                continue
            if any(lower == kw for kw in SQL_KEYWORDS if " " not in kw):
                result.append(Token("keyword", lower, t.pos))
                i += 1
                continue
            if lower in FUNCTION_NAMES:
                result.append(Token("function", lower, t.pos))
                i += 1
                continue
            if lower in TYPE_KEYWORDS:
                result.append(Token("keyword", lower, t.pos))
                i += 1
                continue
            result.append(t)
            i += 1
            continue
        result.append(t)
        i += 1
    return result


def has_chinese(s: str) -> bool:
    return bool(re.search(r'[一-鿿]', s))


def remove_backticks(tokens: list[Token]) -> list[Token]:
    result: list[Token] = []
    for t in tokens:
        if t.kind == "backtick":
            inner = t.value[1:-1]
            if has_chinese(inner):
                result.append(t)
            else:
                result.append(Token("identifier", inner, t.pos))
        else:
            result.append(t)
    return result


class Clause: pass

class SelectClause(Clause):
    def __init__(self):
        self.expressions: list[list[Token]] = []
        self.has_case_when = False

class CaseWhenBlock(Clause):
    def __init__(self):
        self.case_tokens: list[Token] = []
        self.when_clauses: list[tuple[list[Token], list[Token]]] = []
        self.else_value: list[Token] | None = None
        self.end_tokens: list[Token] = []

class FromJoinBlock(Clause):
    def __init__(self):
        self.items: list[FromJoinItem] = []

class FromJoinItem(Clause):
    def __init__(self):
        self.join_type: str = ""
        self.source_tokens: list[Token] = []
        self.alias: str = ""
        self.subquery: SelectStatement | None = None
        self.on_conditions: list[list[Token]] = []

class SelectStatement(Clause):
    def __init__(self):
        self.ctes: list[tuple[str, SelectStatement]] = []
        self.select_list: list[list[Token]] = []
        self.from_join: FromJoinBlock | None = None
        self.where_conditions: list[list[Token]] = []
        self.group_by_tokens: list[Token] = []
        self.order_by_tokens: list[Token] = []
        self.having_tokens: list[Token] = []
        self.unions: list[SelectStatement] = []


def strip_ws_tokens(tokens: list[Token]) -> list[Token]:
    while tokens and tokens[0].kind == "whitespace":
        tokens = tokens[1:]
    while tokens and tokens[-1].kind == "whitespace":
        tokens = tokens[:-1]
    return tokens


def compact_ws_tokens(tokens: list[Token]) -> list[Token]:
    result: list[Token] = []
    for t in tokens:
        if t.kind == "whitespace":
            if result and result[-1].kind != "whitespace":
                result.append(Token("whitespace", " ", t.pos))
        else:
            result.append(t)
    return result


def normalize_spacing(tokens: list[Token]) -> list[Token]:
    COMPARISON_OPS = frozenset({">=", "<=", "<>", "!=", "=", "<", ">"})
    result: list[Token] = []
    func_paren_depth = 0
    for i, t in enumerate(tokens):
        if t.kind == "lparen":
            # Only count as function parens if preceded by a function token
            if result and (
                (result[-1].kind == "function") or
                (result[-1].kind == "whitespace" and len(result) >= 2 and result[-2].kind == "function")
            ):
                func_paren_depth += 1
        elif t.kind == "rparen":
            if func_paren_depth > 0:
                func_paren_depth -= 1

        if t.kind == "operator" and t.value in COMPARISON_OPS:
            if result and result[-1].kind not in ("whitespace", "lparen", "comma"):
                result.append(Token("whitespace", " ", t.pos))
            result.append(t)
            next_is_ws = (i + 1 < len(tokens) and tokens[i + 1].kind == "whitespace")
            if not next_is_ws:
                result.append(Token("whitespace", " ", t.pos))
        elif t.kind == "comma":
            result.append(t)
            # Skip space after comma inside function call parens (e.g. round(x, 4))
            if func_paren_depth == 0:
                next_is_ws = (i + 1 < len(tokens) and tokens[i + 1].kind == "whitespace")
                if not next_is_ws:
                    result.append(Token("whitespace", " ", t.pos))
        else:
            result.append(t)
    return result


def clean_expr(expr: list[Token]) -> list[Token]:
    return strip_ws_tokens(compact_ws_tokens(expr))


def is_case_expr(tokens: list[Token]) -> bool:
    for t in tokens:
        if t.kind == "whitespace": continue
        return t.kind == "keyword" and t.value == "case"
    return False


def fmt_case_when_multiline(
    expr: list[Token], comma_indent: int, as_col: int, is_first: bool = False,
) -> list[str]:
    cleaned = clean_expr(expr)
    before_as, as_part = split_as_expr(cleaned)
    segments: list[list[Token]] = []
    current: list[Token] = []
    for t in before_as:
        if t.kind == "keyword" and t.value in ("when", "then", "else", "end"):
            if current: segments.append(current)
            current = [t]
        else:
            current.append(t)
    if current: segments.append(current)

    lines: list[str] = []
    prefix = " " * comma_indent
    if not is_first: prefix += ", "

    case_seg = segments[0] if segments else []
    case_text = tokens_text(case_seg).rstrip()
    case_align = len(prefix) + len(case_text) + 1

    i, first_when = 1, True
    while i < len(segments):
        seg = segments[i]
        seg_text = tokens_text(seg).rstrip()
        seg_kw = seg[0].value if seg else ""
        if seg_kw == "when":
            if first_when:
                line = prefix + case_text + " " + seg_text
                first_when = False
            else:
                line = " " * case_align + seg_text
            if i + 1 < len(segments) and segments[i + 1] and segments[i + 1][0].value == "then":
                then_val = tokens_text(segments[i + 1]).rstrip()
                line += " " + then_val
                i += 1
            lines.append(line)
        elif seg_kw == "then":
            lines[-1] += " " + seg_text
        elif seg_kw == "else":
            line = " " * case_align + seg_text
            if i + 1 < len(segments) and segments[i + 1] and segments[i + 1][0].value not in ("end", "when"):
                else_val = tokens_text(segments[i + 1]).rstrip()
                line += " " + else_val
                i += 1
            lines.append(line)
        elif seg_kw == "end":
            end_indent = comma_indent + 3
            end_line = " " * end_indent + seg_text
            if as_part:
                pad = as_col - end_indent - len(seg_text)
                if pad > 0:
                    end_line += " " * pad
                end_line += tokens_text(as_part)
            lines.append(end_line)
        i += 1
    return lines


def fmt_tokens(toks: list[Token], col: int) -> str:
    return " " * col + tokens_text(toks)


def expr_text_width(tokens: list[Token]) -> int:
    while tokens and tokens[-1].kind == "whitespace":
        tokens = tokens[:-1]
    return sum(len(t.value) for t in tokens)


def split_as_expr(tokens: list[Token]) -> tuple[list[Token], list[Token]]:
    for i, t in enumerate(tokens):
        if t.kind == "keyword" and t.value == "as":
            return tokens[:i], tokens[i:]
    return tokens, []


def fmt_select_list(
    expressions: list[list[Token]], select_indent: int, is_subquery: bool = False,
) -> list[str]:
    lines: list[str] = []
    if not expressions: return lines
    cleaned_exprs = [clean_expr(e) for e in expressions]
    split_exprs = [split_as_expr(e) for e in cleaned_exprs]

    max_before_as = 0
    for before, after in split_exprs:
        if not is_case_expr(before):
            w = expr_text_width(before)
            if w > max_before_as: max_before_as = w

    as_col = select_indent + len("select ") + max_before_as + 1
    comma_indent = select_indent + 5

    # First expression
    first_before, first_after = split_exprs[0]
    if is_case_expr(first_before):
        case_lines = fmt_case_when_multiline(expressions[0], comma_indent, as_col, is_first=True)
        lines.extend(case_lines)
    else:
        first_text = tokens_text(first_before).rstrip()
        first_as = tokens_text(first_after) if first_after else ""
        first_line = "select " + first_text
        if first_as:
            pad = as_col - select_indent - len("select ") - expr_text_width(first_before)
            if pad > 0: first_line += " " * pad
            first_line += first_as
        lines.append(first_line)

    if len(expressions) == 1: return lines

    for idx, (expr_orig, (before, after)) in enumerate(zip(expressions[1:], split_exprs[1:]), start=1):
        if is_case_expr(before):
            case_lines = fmt_case_when_multiline(expressions[idx], comma_indent, as_col, is_first=False)
            lines.extend(case_lines)
        else:
            before_text = tokens_text(before).rstrip()
            after_text = tokens_text(after) if after else ""
            line = " " * comma_indent + ", " + before_text
            if after_text:
                pad = as_col - comma_indent - 2 - expr_text_width(before)
                if pad > 0: line += " " * pad
                line += after_text
            lines.append(line)
    return lines


def fmt_join_item(item: FromJoinItem, select_indent: int) -> list[str]:
    lines: list[str] = []
    join_indent = select_indent + 2
    join_kw = item.join_type
    if item.subquery:
        inner_select_indent = join_indent + len(join_kw) + 2
        inner = fmt_statement_lines(item.subquery, inner_select_indent)
        open_paren_line = f"{' ' * join_indent}{join_kw} ({inner[0].lstrip()}"
        lines.append(open_paren_line)
        for iline in inner[1:]:
            lines.append(iline)
        paren_pos = join_indent + len(join_kw) + 1
        alias_str = f" {item.alias}" if item.alias else ""
        lines.append(f"{' ' * paren_pos}){alias_str}")
    else:
        src_str = tokens_text(item.source_tokens).strip()
        alias_str = f" as {item.alias}" if item.alias else ""
        line = f"{' ' * join_indent}{join_kw} {src_str}{alias_str}"
        lines.append(line)
    if item.on_conditions:
        on_indent = join_indent + 2
        and_indent = join_indent + 1
        for ci, cond_raw in enumerate(item.on_conditions):
            cond = strip_ws_tokens(cond_raw)
            if ci == 0:
                cond_text = "on " + tokens_text(cond)
                lines.append(" " * on_indent + cond_text)
            else:
                lines.append(fmt_tokens(cond, and_indent))
    return lines


def fmt_statement_lines(stmt: SelectStatement, select_indent: int) -> list[str]:
    lines: list[str] = []
    for cte_name, cte_body in stmt.ctes:
        lines.append(f"{' ' * select_indent}with {cte_name} as (")
        inner = fmt_statement_lines(cte_body, select_indent + 5)
        lines.extend(inner)
        lines.append(f"{' ' * select_indent})")
    select_lines = fmt_select_list(stmt.select_list, select_indent)
    lines.extend(select_lines)
    if stmt.from_join:
        for item in stmt.from_join.items:
            join_lines = fmt_join_item(item, select_indent)
            lines.extend(join_lines)
    if stmt.where_conditions:
        where_indent = select_indent + 1
        for ci, cond_raw in enumerate(stmt.where_conditions):
            cond = strip_ws_tokens(cond_raw)
            if ci == 0:
                cond_text = "where " + tokens_text(cond)
                lines.append(" " * where_indent + cond_text)
            else:
                lines.append(fmt_tokens(cond, where_indent + 2))
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
        union_lines = fmt_statement_lines(union_stmt, select_indent)
        lines.extend(union_lines)
    return lines


class StreamParser:
    def __init__(self, tokens: list[Token]):
        self.tokens = tokens
        self.pos = 0
    def peek(self) -> Token | None:
        if self.pos < len(self.tokens): return self.tokens[self.pos]
        return None
    def next(self) -> Token | None:
        t = self.peek()
        if t: self.pos += 1
        return t
    def skip_ws(self):
        while self.peek() and self.peek().kind == "whitespace": self.pos += 1
    def skip_ws_and_comments(self):
        while self.peek() and self.peek().kind in ("whitespace", "comment"): self.pos += 1
    def kw_val(self) -> str | None:
        t = self.peek()
        if t and t.kind in ("keyword", "identifier"): return t.value.lower()
        return None


class SelectBodyParser(StreamParser):
    def parse_select_statement(self, select_indent: int = 0) -> SelectStatement:
        stmt = SelectStatement()
        if self.kw_val() == "with": self.parse_ctes(stmt)
        self.expect_and_consume("select")
        stmt.select_list = self.parse_select_expressions()
        if self.kw_val() == "from": stmt.from_join = self.parse_from_join_chain()
        if self.kw_val() == "where":
            self.pos += 1
            self.skip_ws_and_comments()
            stmt.where_conditions = self.parse_conditions()
        if self.kw_val() == "group": stmt.group_by_tokens = self.parse_group_order("group")
        if self.kw_val() == "having": stmt.having_tokens = self.parse_group_order("having")
        if self.kw_val() == "order": stmt.order_by_tokens = self.parse_group_order("order")
        while self.kw_val() == "union":
            self.expect_and_consume("union", "all")
            union_body = SelectBodyParser(self.tokens)
            union_body.pos = self.pos
            union_stmt = union_body.parse_select_statement()
            stmt.unions.append(union_stmt)
            self.pos = union_body.pos
        return stmt

    def expect_and_consume(self, *vals: str):
        self.skip_ws_and_comments()
        for v in vals:
            t = self.next()
            if not t or t.value.lower() != v:
                raise ValueError(f"Expected {v!r} at position {self.pos}, got {t!r}")
            self.skip_ws_and_comments()

    def parse_ctes(self, stmt: SelectStatement):
        self.expect_and_consume("with")
        while True:
            name_t = self.next()
            if not name_t: break
            cte_name = name_t.value.lower()
            self.expect_and_consume("as", "(")
            depth, start = 1, self.pos
            while depth > 0 and self.pos < len(self.tokens):
                t = self.tokens[self.pos]
                if t.kind == "lparen": depth += 1
                elif t.kind == "rparen":
                    depth -= 1
                    if depth == 0: break
                self.pos += 1
            inner_tokens = self.tokens[start:self.pos]
            self.pos += 1
            inner_parser = SelectBodyParser(inner_tokens)
            inner_parser.pos = 0
            inner_stmt = inner_parser.parse_select_statement()
            stmt.ctes.append((cte_name, inner_stmt))
            self.skip_ws_and_comments()
            if self.kw_val() != ",": break
            self.pos += 1
            self.skip_ws_and_comments()

    def parse_select_expressions(self) -> list[list[Token]]:
        expressions: list[list[Token]] = []
        current: list[Token] = []
        paren_depth = 0
        while self.pos < len(self.tokens):
            t = self.peek()
            if t is None: break
            if paren_depth == 0 and t.kind in ("keyword", "identifier"):
                v = t.value.lower()
                if v in ("from", "where", "group", "having", "order", "union",
                         "left", "right", "full", "cross", "inner", "join",
                         "on", "limit", "offset"):
                    if current: expressions.append(current)
                    return expressions
            if t.kind == "lparen":
                paren_depth += 1
                current.append(self.next())
                continue
            if t.kind == "rparen":
                paren_depth -= 1
                current.append(self.next())
                continue
            if t.kind == "comma" and paren_depth == 0:
                if current: expressions.append(current)
                current = []
                self.pos += 1
                continue
            current.append(self.next())
        if current: expressions.append(current)
        return expressions

    def parse_from_join_chain(self) -> FromJoinBlock:
        block = FromJoinBlock()
        self.expect_and_consume("from")
        item = self.parse_join_source()
        item.join_type = "from"
        block.items.append(item)
        while True:
            self.skip_ws_and_comments()
            kw = self.kw_val()
            if kw is None: break
            if kw in ("left", "right", "full", "cross", "inner"):
                save = self.pos
                self.pos += 1
                self.skip_ws_and_comments()
                if self.kw_val() == "join":
                    self.pos = save
                    for p in (kw, "join"): self.expect_and_consume(p)
                    join_type = f"{kw} join"
                else:
                    self.pos = save
                    break
            elif kw == "join":
                self.expect_and_consume("join")
                join_type = "join"
            else:
                break
            item = self.parse_join_source()
            item.join_type = join_type
            block.items.append(item)
        return block

    def parse_join_source(self) -> FromJoinItem:
        item = FromJoinItem()
        self.skip_ws_and_comments()
        if self.peek() and self.peek().kind == "lparen":
            self.pos += 1
            start, depth = self.pos, 1
            while depth > 0 and self.pos < len(self.tokens):
                t = self.tokens[self.pos]
                if t.kind == "lparen": depth += 1
                elif t.kind == "rparen":
                    depth -= 1
                    if depth == 0: break
                self.pos += 1
            inner_tokens = self.tokens[start:self.pos]
            self.pos += 1
            inner_parser = SelectBodyParser(inner_tokens)
            inner_parser.pos = 0
            item.subquery = inner_parser.parse_select_statement()
            self.skip_ws_and_comments()
            if self.kw_val() == "as":
                self.pos += 1
                self.skip_ws_and_comments()
                alias_tok = self.peek()
                if alias_tok and alias_tok.kind in ("keyword", "identifier", "backtick"):
                    item.alias = alias_tok.value.lower().replace("`", "")
                    self.pos += 1
            else:
                alias_tok = self.peek()
                if alias_tok and alias_tok.kind in ("keyword", "identifier"):
                    alias_lower = alias_tok.value.lower()
                    if alias_lower not in ("on", "where", "left", "right", "full",
                                           "cross", "inner", "join", "group",
                                           "having", "order", "union", "limit", "and", "or", "as"):
                        item.alias = alias_lower
                        self.pos += 1
        else:
            source_tokens: list[Token] = []
            while self.peek() and self.peek().kind in ("identifier", "dot", "backtick", "keyword", "number"):
                t = self.peek()
                v = t.value.lower() if t.kind in ("keyword", "identifier") else t.value
                if t.kind in ("keyword", "identifier"):
                    if v in ("as", "on", "where", "left", "right", "full",
                             "cross", "inner", "join", "group", "having",
                             "order", "union", "limit", "and", "or"):
                        break
                source_tokens.append(self.next())
            item.source_tokens = source_tokens
            self.skip_ws_and_comments()
            if self.kw_val() == "as":
                self.pos += 1
                self.skip_ws_and_comments()
                alias_tok = self.peek()
                if alias_tok and alias_tok.kind in ("keyword", "identifier", "backtick"):
                    item.alias = alias_tok.value.lower().replace("`", "")
                    self.pos += 1
            else:
                alias_tok = self.peek()
                if alias_tok and alias_tok.kind in ("keyword", "identifier"):
                    alias_lower = alias_tok.value.lower()
                    if alias_lower not in ("on", "where", "left", "right", "full",
                                           "cross", "inner", "join", "group",
                                           "having", "order", "union", "limit", "and", "or", "as"):
                        item.alias = alias_lower
                        self.pos += 1
        self.skip_ws_and_comments()
        if self.kw_val() == "on":
            self.pos += 1
            self.skip_ws_and_comments()
            item.on_conditions = self.parse_conditions()
        return item

    def parse_conditions(self) -> list[list[Token]]:
        conditions: list[list[Token]] = []
        current: list[Token] = []
        paren_depth = 0
        while self.pos < len(self.tokens):
            t = self.peek()
            if t is None: break
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
                    if current: conditions.append(current)
                    current = [self.next()]
                    continue
                if v in ("group", "having", "order", "union", "limit",
                         "left", "right", "full", "cross", "inner", "join",
                         "from", "select", "offset"):
                    if current: conditions.append(current)
                    return conditions
            current.append(self.next())
        if current: conditions.append(current)
        return conditions

    def parse_group_order(self, clause_type: str) -> list[Token]:
        tokens: list[Token] = []
        if clause_type == "group": self.expect_and_consume("group", "by")
        elif clause_type == "order": self.expect_and_consume("order", "by")
        elif clause_type == "having": self.expect_and_consume("having")
        while self.pos < len(self.tokens):
            t = self.peek()
            if t is None: break
            if t.kind in ("keyword", "identifier"):
                v = t.value.lower()
                if v in ("union", "limit", "offset", "select", "from",
                         "where", "left", "right", "full", "cross", "inner",
                         "join", "on", "and", "or"):
                    break
            if t.kind == "semicolon": break
            tokens.append(self.next())
        return tokens


HEADER_PATTERN = re.compile(r"^\s*--\s*程序功能", re.MULTILINE)


def has_header(sql: str) -> bool:
    return bool(HEADER_PATTERN.search(sql[:2000]))


def generate_header(file_path: Path, function_desc: str, owner: str) -> str:
    program_name = file_path.stem
    layer = file_path.parent.parent.name if file_path.parent.name == "dml" else ""
    if layer and program_name.startswith(f"P_{layer}_"):
        table_name = f"{layer}.{layer}_{program_name[len(f'P_{layer}_'):]}"
    else:
        table_name = f"unknown.{program_name[2:]}" if program_name.startswith("P_") else program_name
    today = date.today().isoformat()
    sep = "-" * 64
    return f"""{sep}
-- 程序功能： {function_desc}
-- 程序名： {program_name}
-- 目标表： {table_name}
-- 负责人： {owner}
-- 开发日期：{today}
{sep}

"""


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
                    i += 2; continue
                quote = None
            i += 1; continue
        if ch in ("'", '"', "`"): quote = ch
        elif ch == "-" and i + 1 < len(sql) and sql[i + 1] == "-":
            nl = sql.find("\n", i)
            i = nl + 1 if nl != -1 else len(sql); continue
        elif ch == "/" and i + 1 < len(sql) and sql[i + 1] == "*":
            end = sql.find("*/", i + 2)
            i = end + 2 if end != -1 else len(sql); continue
        elif ch == ";":
            statements.append(sql[start:i])
            start = i + 1
        i += 1
    tail = sql[start:].strip()
    if tail: statements.append(tail)
    return statements


def format_insert_select(
    sql: str, file_path: Path | None = None,
    function_desc: str = "", owner: str = "",
) -> str:
    body = sql.replace("\r\n", "\n").replace("\r", "\n").strip()
    if not body: return ""
    header = ""
    body_without_header = body
    if has_header(body):
        lines = body.split("\n")
        header_end = 0
        in_header = False
        for i, line in enumerate(lines):
            if line.strip().startswith("-") and len(line.strip()) >= 60:
                in_header = not in_header
                header_end = i + 1
                if not in_header: break
            elif in_header: header_end = i + 1
        header = "\n".join(lines[:header_end]) + "\n\n"
        body_without_header = "\n".join(lines[header_end:]).strip()
    elif file_path and function_desc and owner:
        header = generate_header(file_path, function_desc, owner)
    statements = split_statements(body_without_header)
    formatted_stmts: list[str] = []
    for stmt_raw in statements:
        stmt = stmt_raw.strip()
        if not stmt: continue
        stmt_lower = stmt.lower().strip()
        insert_match = re.match(r"((?:insert\s+(?:into|overwrite))\s+\S+)", stmt_lower)
        if insert_match and re.search(r"\b(select|with)\b", stmt_lower):
            insert_line_raw = insert_match.group(1).strip()
            ins_tokens = tokenize(insert_line_raw)
            ins_tokens = remove_backticks(ins_tokens)
            insert_line = tokens_text(ins_tokens).strip()
            select_body = stmt[insert_match.end():].strip()
            tokens = tokenize(select_body)
            tokens = remove_backticks(tokens)
            tokens = normalize_keywords_in_tokens(tokens)
            tokens = normalize_spacing(tokens)
            parser = SelectBodyParser(tokens)
            parser.pos = 0
            try:
                parsed = parser.parse_select_statement()
            except Exception as e:
                text = tokens_text(tokens)
                text = re.sub(r"[ \t]+", " ", text).strip()
                formatted_stmts.append(f"{insert_line}\n{text}\n;")
                continue
            select_lines = fmt_statement_lines(parsed, select_indent=0)
            result_lines = [insert_line]
            result_lines.extend(select_lines)
            result_lines.append(";")
            formatted_stmts.append("\n".join(result_lines))
        else:
            tokens = tokenize(stmt)
            tokens = remove_backticks(tokens)
            tokens = normalize_keywords_in_tokens(tokens)
            text = tokens_text(tokens).strip()
            text = re.sub(r"[ \t]+", " ", text)
            formatted_stmts.append(text)
    result = header + "\n\n".join(formatted_stmts)
    if not result.endswith("\n"): result += "\n"
    return result


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
    parser.add_argument("--check", action="store_true", help="exit non-zero if changes needed")
    parser.add_argument("--function", type=str, default="", help="program function")
    parser.add_argument("--owner", type=str, default="", help="owner")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    args = parse_args(argv)
    path = args.path
    sql = path.read_text(encoding="utf-8")
    validate_trigger(path, sql)
    formatted = format_insert_select(sql, file_path=path,
                                     function_desc=args.function, owner=args.owner)
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
