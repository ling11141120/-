# Create Table Format Rules

## 语句结构

若数据库是 `ods`，语句结构如下：

```sql
----------------------------------------------------------------
-- 目标表：表名
-- 来源实例：通过用户回答获取到的 source instance
-- 来源表：通过用户回答获取到的 source table
-- 来源负责人：通过用户回答获取到的 source-owner
-- 开发人：用户工号
-- 开发日期：当前日期
----------------------------------------------------------------

drop table if exists ods.table_name;
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

若数据库不是 `ods`，语句结构如下：

```sql
drop table if exists db_name.table_name;
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
- 行内注释以 `comment "..."` 形式保留在列行末尾。
- 除第一个列定义不需要逗号，其他每个列或约束前都使用前置逗号。
- 第一个列定义的列名首字符缩进 5 个空格，其他列定义的前置逗号缩进 4 个空格。
- 数据类型对齐：在缩进基础上，以最长列名为纵向对齐标准，额外空 1 格，使数据类型首字符纵向对齐。
- 可空性、默认值、生成属性对齐：在数据类型对齐基础上，以最长数据类型为纵向对齐标准，额外空 1 格，使这些片段的首字符纵向对齐。
- 注释对齐：在可空性、默认值、生成属性对齐基础上，以最长的可空性/默认值/生成属性组合为纵向对齐标准，额外空 1 格，使 `comment` 首字符纵向对齐。

正确示例如下：

```sql
     dt             date          not null                   comment "日期"
    ,Id             bigint        not null                   comment "主键ID"
    ,AccountId      bigint        not null                   comment "账号ID"
    ,CollectEmail   string                                   comment "收集邮箱"
    ,sr_createtime  datetime      default current_timestamp  comment "starrocks数据注入时间"
    ,IsDl           tinyint       not null                   comment "是否DL用户,0-否，1-是"
    ,dlUpdateTime   datetime                                 comment "DL用户修改时间"
    ,currencyCode   varchar(60)                              comment "网赚用户首次货币码"
    ,coin_amt       decimal(38,6)                            comment "coin收入"
```

## 表选项

以 StarRocks 方言顺序为准：

1. 键/模型子句：单独一行，保留键定义中列的原始顺序。
2. 表注释：以 `comment "..."` 保存。
3. 分区子句：如果分区为 `partition by date_trunc(...)`，则保持不变；若是 `partition by range(...)\n(partition p... values [("..."), ("...")), ...)` 形式，则改为 `partition by range(...)\n(partition p... values less than ("...")`。
4. 分桶子句：关键字小写，列名保持不变。
5. `properties` 属性：每个属性缩进 4 个空格；除最后一个属性之外，其他属性后都带后置逗号。
