----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_consume_ed
-- workflow_version : 8
-- create_user      : linq
-- task_name        : ads_sv_series_consume_ed
-- task_version     : 3
-- update_time      : 2024-05-11 02:12:46
-- sql_path         : \starrocks\tbl_ads_sv_series_consume_ed\ads_sv_series_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_series_consume_ed where dt>='${bf_1_dt}' and dt<'${dt}';

-- SQL语句
insert into ads.ads_sv_series_consume_ed
select t1.dt,
       md5(concat_ws('_',dt,t1.product_id,t1.series_id,t1.language,t2.id,t2.series_type_id)) as md5_key,
       t1.product_id,
       t1.series_id,
       t1.language,
       t2.id as series_ref_type_id,
       t2.series_type_id,
       t1.consume_coin,
       t1.consume_bonus,
       now() as etl_time
from(
    select a.dt,
           a.product_id,
           c.series_id,
           c.language,
           sum(if(types = 0, a.consume_amt, 0)) as consume_coin,
           sum(if(types = 1, a.consume_amt, 0)) as consume_bonus
    from dws.dws_consume_short_video_consume_ed a
             left join dim.dim_short_video_epis_view b on a.epis_id = b.epis_id
             left join dim.dim_short_video_series_view c on b.series_id = c.series_id
    where dt>='${bf_1_dt}' and dt<'${dt}'
    group by 1, 2, 3, 4
)t1
-- 1 对多关联
left join dim.dim_short_video_series_ref_type_view t2 on t1.series_id=t2.series_id;
