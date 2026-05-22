----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_consume_hi
-- workflow_version : 5
-- create_user      : linq
-- task_name        : ads_sv_series_consume_hi
-- task_version     : 3
-- update_time      : 2024-10-16 15:48:51
-- sql_path         : \starrocks\tbl_ads_sv_series_consume_hi\ads_sv_series_consume_hi
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_series_consume_hi where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into ads.ads_sv_series_consume_hi
select dt,
       md5(concat_ws('_',dt,product_id,hours,series_id,language)) as md5_key,
       product_id,
       hours,
       series_id,
       language,
       consume_coin,
       consume_bonus,
       now() as etl_time
from(
    select a.dt,
           6833 as product_id,
           hour(a.create_time) as hours,
           a.series_id,
           c.language,
           round(sum(if(a.consume_type = 0, a.consume_value, 0))) as consume_coin,
           round(sum(if(a.consume_type = 1, a.consume_value, 0))) as consume_bonus
    from dwd.dwd_sv_consume_user_consume_bill_pdi a
             left join dim.dim_short_video_series_view c on a.series_id = c.series_id
    where dt>='${bf_1_dt}' and dt<='${dt}'
    group by 1, 2, 3, 4,5
)t1
where series_id is not null;
