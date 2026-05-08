# Create Table Format Rules

## 语句结构

若数据库是 `ods`或`ods_log`，语句结构如下：

```sql
----------------------------------------------------------------
-- 目标表：表名
-- 来源实例：通过用户回答获取到的 source instance
-- 来源表：通过用户回答获取到的 source table
-- 来源负责人：通过用户回答获取到的 source-owner
-- 开发人：用户工号
-- 开发日期：当前日期
----------------------------------------------------------------

create table ods.table_name (
     col1_name     col1_data_type [not null] comment "col1_comment"
    ,col2_name     col2_data_type [not null] comment "col2_comment"
    ,...
    ,sr_createtime datetime                  comment "sr入库时间"
)
primary|duplicate|aggregate key (key_col_list)
comment "table_comment"
[partition by ...]
distributed by hash(col_list) [buckets bucket_num]
properties (
    "key" = "value",
    "key2" = "value",
    "key3" = "value"
)
;
```

若数据库不是 `ods`或`ods_log`，语句结构如下：

```sql
create table db_name.table_name (
     col1_name     col1_data_type [not null] comment "col1_comment"
    ,col2_name     col2_data_type [not null] comment "col2_comment"
    ,...
    ,sr_createtime datetime                  comment "sr入库时间"
)
primary|duplicate|aggregate key (key_col_list)
comment "table_comment"
[partition by ...]
distributed by hash(col_list) [buckets bucket_num]
properties (
    "key" = "value",
    "key2" = "value",
    "key3" = "value"
)
;
```

## 列定义块

- 每行输出一个列定义。
- 每个列定义按以下顺序排列：列名、数据类型、可空性、默认值、生成属性、注释。
- 列名：删除 `` ` `` 符，保持列名原本的大小写。
- 数据类型：统一小写，删除 `bigint`、`int`、`tinyint` 的长度；若 `varchar` 长度是 `65533`，则改为 `string` 类型。
- 可空性：可为空时省略 `null`，不为空时写 `not null`。
- 默认值：统一小写，保留默认值。
- 行内注释以 `comment "..."` 形式保留在列行末尾；如果原始列定义包含空注释 `comment ""`，也必须保留。
- 除第一个列定义不需要逗号，其他每个列或约束前都使用前置逗号。
- 第一个列定义的列名首字符缩进 5 个空格，其他列定义的前置逗号缩进 4 个空格。
- 数据类型对齐：在缩进基础上，以最长列名为纵向对齐标准，额外空 1 格，使数据类型首字符纵向对齐。
- 可空性、默认值、生成属性对齐：在数据类型对齐基础上，以最长数据类型为纵向对齐标准，额外空 1 格，使这些片段的首字符纵向对齐。
- 注释对齐：在可空性、默认值、生成属性对齐基础上，以最长的可空性/默认值/生成属性组合为纵向对齐标准，额外空 1 格，使 `comment` 首字符纵向对齐。

## 表选项

以 StarRocks 方言顺序为准：

1. 键/模型子句：单独一行，保留键定义中列的原始顺序。
2. 表注释：以 `comment "..."` 保存。
3. 分区子句：如果分区为 `partition by date_trunc(...)`，则保持不变；若是 `partition by range(...)...` 形式，删除所有`partition by range(...)`到`distributed by ...`中间所有的内容，在`partition by range(...)...`下一行输入新内容，新内容规则要求如3.1、3.2
    3.1 若properties中`dynamic_partition.time_unit`的值是`day`，则输入`(patition pyyyyMMdd values less than ("yyyy-MM-dd+1"))`
    3.2 若properties中`dynamic_partition.time_unit`的值是`month`，则输入`(patition pyyyyMM values less than ("yyyy-(MM+1)-01"))`
4. 分桶子句：关键字小写，列名保持不变。
5. `properties` 属性：每个属性缩进 4 个空格；除最后一个属性之外，其他属性后都带后置逗号。
