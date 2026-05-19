# DML 格式化规则参考

本文档描述 `format_starrocks_insert_select.py` 的格式化行为，供 AI Agent 在格式化 DML 文件时参考。

---

## 1. 文件头

已有文件头（含 `-- 程序功能` 或 `-- 程序名` 语义注释块）的 DML 文件，格式化时**保留不变**。无文件头的文件，脚本自动生成如下格式：

```sql
----------------------------------------------------------------
-- 程序功能： {--function 参数值}
-- 程序名： {文件名（不含 .sql）}
-- 目标表： {层.表名（从路径推导）}
-- 负责人： {--owner 参数值}
-- 开发日期：{yyyy-MM-dd 系统日期}
----------------------------------------------------------------
```

分隔线长度 64 个 `-`，分隔线上下无空行，文件头后跟一个空行再开始 SQL。

---

## 2. 整体结构

```
insert into db_name.table_name
select expr1
     , expr2
  from source
 where cond
 group by 1, 2
;

[union all

select ...]
```

- `insert into` / `insert overwrite` 单独一行，关键字小写
- select 语句从 `select` 开始格式化
- 文件末尾单独一行 `;`
- 多段 insert（含 union all）段间空行分隔，不合并不拆分

---

## 3. select 列表

```sql
select a.dt                                          -- select 与首表达式同行，1 空格
     , a.hour                                        -- 前置逗号: select_indent + 5
     , round(a.product_id)               as product_id -- as 对齐: select_indent + 7 + max_before_as + 1
     , a.summary                                      -- 无 as 不参与对齐，不补 as
```

规则：
- `select` 关键词与第一个表达式同行，中间保留 1 个空格
- 前置逗号以本段 `select` 的缩进为基准，再缩进 5 个空格（即 `select_indent + 5`）
- `as` 垂直对齐，对齐列 = `select_indent + 7 + max_before_as + 1`，其中 `max_before_as` 取同段有别名表达式（不含 case when）的 `as` 前文本宽度最大值
- 无别名表达式不强制补充 `as`，也不参与 `as` 对齐列的计算
- 保留原始别名大小写、注释、函数、变量占位符如 `${dt}`
- case when 表达式的 `as` 前宽度不计入 `max_before_as`，但 `end` 行的 `as` 仍参与对齐

---

## 4. case when

```sql
     , case lower(os) when 'ios' then 1
                      when 'android' then 4               -- when 与第一个 when 对齐
                      else -99                            -- else 与 when 对齐
            end                               as os_id    -- end 的 'd' 与 case 的 'e' 对齐
```

规则：
- `when` 和 `else` 纵向对齐，对齐位置为 `case expr ` 之后（第一个 when 与 case 同行）
- `then` 跟在 `when condition` 后同一行，不对齐
- `end` 的 `d` 与 `case` 的 `e` 对齐（`end` 缩进 = `comma_indent + 3`，即前置逗号后再缩进 3）
- `end` 行的 `as` 参与同段 select 列表的 `as` 对齐

---

## 5. from / join 与子查询

```sql
select ...
  from source_table                         as alias1     -- from = select_indent + 2
  left join other_table                     as alias2     -- left join = select_indent + 2
    on alias1.key = alias2.key                            -- on = join_indent + 2
   and alias1.key2 = alias2.key2                          -- and = join_indent + 1
  right join (select inner_expr                            -- 子查询 ( 与 join 同行，1 空格
                   , inner_expr2               as inner_alias  -- 子查询内部 select = ( + 1
                from inner_table                            -- 子查询内部 from = inner_select + 2
               where inner_cond                             -- 子查询内部 where = inner_select + 1
               group by 1                                   -- 子查询内部 group by = inner_select + 1
             )                                   as alias3 -- ) 与 ( 垂直对齐，别名同行
    on alias1.key = alias3.key
```

规则：
- `from` / `join` / `left join` / `right join` / `full join` / `cross join` 均缩进 `select_indent + 2`
- `inner join` 自动缩写为 `join`
- `on` 缩进 = `join_indent + 2`
- `and` / `or` 缩进 = `join_indent + 1`（使 `on cond` 与 `and cond` 在视觉上对齐）
- 来源为子查询时，`(` 在 `from`/`join` 同行、保留 1 个空格
- 子查询内部 `select` 缩进 = `(` 位置 + 1
- 子查询内部 `from` 缩进 = 子查询内部 `select_indent + 2`
- 子查询内部 `where` / `group by` / `order by` 缩进 = 子查询内部 `select_indent + 1`
- 子查询 `)` 与 `(` 垂直对齐，表别名紧跟在同一行

---

## 6. where / group by / order by

```sql
 where app_product_id <> 6833
   and app_product_id is not null
   and (cond1
        or cond2
       )
 group by 1, 2, 3
 order by 1
```

规则：
- `where` 缩进 = `select_indent + 1`
- `group by` / `order by` 缩进 = `select_indent + 1`
- `and` / `or` 缩进 = `where_indent + 2`
- `group by` / `order by` 字段采用紧凑列表，不每行一个字段（保留原格式）

---

## 7. union all

```sql
 group by 1, 2

union all

select ...
```

规则：
- `union all` 不缩进（col 0）
- 前后各保留一个空行

---

## 8. 反引号

- 别名或列名含中文字符时保留反引号
- 不含中文的别名/列名/表名中的反引号自动删除

---

## 9. 关键字和函数

所有以下内容统一转为**小写**：

| 类别 | 内容 |
|------|------|
| SQL 关键字 | select, from, where, join, on, and, or, case, when, then, else, end, group by, order by, union all, insert into, insert overwrite, with, as, having, distinct, between, is null, is not null, not null, null, over, partition by, left join, right join, full join, cross join |
| 函数名 | count, sum, avg, max, min, coalesce, ifnull, round, cast, concat, date, date_add, datediff, if, abs 等 |
| 类型关键字 | date, int, bigint, varchar, decimal, double, float, string, boolean 等 |

特殊处理：`inner join` → `join`

---

## 10. 运算符空格

比较运算符 `>=`, `<=`, `<>`, `!=`, `=`, `<`, `>` 左右各加一个空格：

```sql
 where app_product_id <> 6833
   and a.dt >= '${bf_3_dt}'
```

逗号后加空格，但函数调用参数内的逗号不额外加空格（如 `round(x, 4)`）。

---

## 11. 多段 insert

- 逐段格式化，不合并、不拆分
- 段间空行分隔

---

## 12. 行结束处理

- 文件末尾单独一行 `;`
- 输出使用 `\n` 换行
- 文件末尾保留一个空行

---

## 13. 保守策略（不修改的内容）

- SQL 语义（字段顺序、别名、表达式逻辑）
- 字符串字面量
- SQL 注释（`--` 和 `/* */`）
- `${...}` 调度变量
- 复杂 SQL 保留原结构（解析失败时回退为仅做关键字小写 + 空格规范化）
