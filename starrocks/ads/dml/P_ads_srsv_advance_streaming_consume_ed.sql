----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_advance_streaming_consume_ed
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : ads_srsv_advance_streaming_consume_ed
-- task_version     : 4
-- update_time      : 2025-02-18 15:39:57
-- sql_path         : \starrocks\tbl_ads_srsv_advance_streaming_consume_ed\ads_srsv_advance_streaming_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_srsv_advance_streaming_consume_ed where dt >= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_srsv_advance_streaming_consume_ed
select
    a.dt,
    a.ProductId,
    b.book_id,
    sum(a.ConvertSpend) as spend,
    now() as etl_time
from (
    select
        date_start as dt, ProductId, AdId, ConvertSpend
    from dim.dim_FbAdDailyInsight_view
    where date_start >= '${bf_1_dt}'
    union all
    select
        date_start as dt, ProductId, AdId, ConvertSpend
    from dim.dim_LtvDailyInsight_view
    where date_start >= '${bf_1_dt}'
) a
left join ads.ads_advertisement_adbase_view as b on a.AdId = b.ad_id and a.ProductId = b.product_id
where b.book_id is not null
group by a.dt, a.ProductId, b.book_id;
