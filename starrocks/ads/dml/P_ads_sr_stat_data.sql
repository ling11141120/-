----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_stat_data
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_sr_stat_data
-- task_version     : 3
-- update_time      : 2025-02-20 18:38:39
-- sql_path         : \starrocks\tbl_ads_sr_stat_data\ads_sr_stat_data
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_stat_data
select
    a.productid as product_id,
    a.AutoId as auto_id,
    a.BookId as book_id,
    ifnull(if(a.productid = 8858 or a.productid = 7757, 1, if(a.productid = 3333, 2, b.language_id)), -99) as language_id,
    a.StatField as stat_field,
    a.RankClass as rank_class,
    a.Code as code,
    max(ifnull(a.Value, 0)) as value,
    now() as etl_time
from (
    select
        productid,
        AutoId,
        BookId,
        StatField,
        RankClass,
        Code,
        Value
    from ods.ods_tidb_readernovel_tidb_xx_stat_data
    where StatField='ClickNum' and Rankclass = 'Total'
) a
left join dim.dim_novel_book_info_view b
on a.productid = b.product_id and a.BookId = b.book_id
group by 1, 2, 3, 4, 5, 6, 7;
