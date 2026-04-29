# 语句结构

以下是存在 CTE、子查询的标准语句结构示例：

- `insert into db.table` 或 `insert overwrite db.table` 单独一行。
- 若有 cte，`with` 在 `insert` 的下一行，`with`、cte 名称、`as (` 在同一行，闭合括号 `)` 单独一行且不缩进。
- 文件末尾统一以单独一行 `;` 结束。
- 关键词小写：insert into、insert overwrite、select、as、from、left join/join/right join/full join/cross join、on、and、or、where、group by、having、case when then end、order by、union all 及所有函数小写。
- 同一层级的关键词右对齐（子查询中的关键词不用和父查询的关键词对齐）：select、from、left、full、join、on、and、or、group、having。
- 子查询的一对括号在同一列对齐，where 条件或关联条件中的一对括号也在同一列对齐。

```sql
----------------------------------------------------------------
-- 程序功能：目标表中文注释
-- 程序名：文件名
-- 目标表：程序目标表（db_name.table_name）
-- 负责人：用户工号
-- 开发日期：当前日期
----------------------------------------------------------------

insert into db_name.target_table_name
with cte_name_1 as (
    select expression_1  as exp_alias1
         , expression_2  as exp_alias2
         , expression_10 as exp_alias10
      from db_name.table_1      as alias1
      left join db_name.table_2 as alias2
        on alias1.col_name = alias2.col_name
       and alias1.col_name = alias2.col_name
      left join (select expression_1
                      , expression_2
                   from db_name.table_3
                  where condition_1
                    and condition_2
                  group by 1, 2
                )               as alias3
        on alias1.col_name = alias3.col_name
       and alias1.col_name = alias3.col_name
     where condition_1
       and condition_2
       and (    condition_3
             or condition_4
           )
     group by 1, 2
)
, cte_name_2 as (
    select ...
)
select expression_1  as exp_alias1  -- target_table_column1_comment
     , expression_2  as exp_alias2  -- target_table_column2_comment
     , expression_10 as exp_alias10 -- target_table_column10_comment
  from cte_name_1      as alias1
  left join cte_name_2 as alias2
    on alias1.col_name = alias2.col_name
   and alias1.col_name = alias2.col_name
 where condition_1
   and condition_2
   and (    condition_3
         or condition_4
       )
 group by 1, 2
;
```

# select 列表

- `select` 关键词和第一个表达式在同一行，`select` 关键词和第一个表达式中间只留一个空格。
- 使用前置逗号，前置逗号以本段 `select` 关键词缩进为基准，再缩进 5 个空格，逗号与表达式之间留一个空格。
- 保留原始别名大小写、注释、函数、变量占位符如 `${dt}`。
- 不强制补 `as`，同一段 `select` 列表中的 `as` 以本行字符串长度最长的表达式为基础，缩进一个空格，并垂直对齐。
- `case when` 语句格式如下：

```sql
select expression_1  as exp_alias1
     , case when condition1 then value1
            when condition2 then value2
        end          as exp_alias2
```

# from、join 与子查询

- `from`/`join` 关键词和来源表在同一行；若来源是子查询，则 `from`/`join` 和子查询 `(` 在同一行，`from`/`join` 和 `(` 中间保留一个空格，子查询 `)` 与子查询别名在同一行，子查询的 `(` 和 `)` 垂直对齐。
- 原则上子查询的 `(`、`select` 关键词和第一个表达式在同一行，`(` 与 `select` 关键词之间没有空格。
- 若子查询 `select` 关键词上一行存在注释，则不改变注释内容前提下精简 `-` 的使用，只保留注释内容前的两个 `-`：

```sql
from (-- 注释内容
      select expression_1  as exp_alias1
        from db.table_name
       where condition
     )                     as source_alias1
```

- `inner join` 缩写成 `join`。
- `from`/`left`/`right`/`full`/`join`/`cross`/`on`/`and` 关键词右对齐，来源别名 `as` 垂直对齐：

```sql
select ...
  from ...      as source_alias1
  left join ... as source_alias2
    on ...
   and ...
  join ...      as source_alias3
    on ...
  full join ... as source_alias4
    on ...
 right join ... as source_alias5
    on ...
 cross join ... as source_alias6
```

# where / group

- `where` 后复杂条件按 `and/or` 换行，关键词右对齐，保持原有逻辑顺序。
- `group by`、`order by` 字段按每行一个字段或紧凑列表保守处理，不重排字段。

# 多段 insert

- 一个文件中存在多个 `insert` 语句时，逐段格式化。
- 每段之间保留一个空行。
- 不合并、不拆分语句。
