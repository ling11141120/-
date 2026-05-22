----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_short_video_epis_a
-- workflow_version : 13
-- create_user      : zhengtt
-- task_name        : ads_wide_short_video_epis_a
-- task_version     : 13
-- update_time      : 2025-04-10 15:38:08
-- sql_path         : \starrocks\tbl_ads_wide_short_video_epis_a\ads_wide_short_video_epis_a
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_wide_short_video_epis_a
with tmp_epis_consume AS (
    select
        dt,
        series_id,
        epis_num,
        consume_user_bitmap,
        consume_amt,
        consume_cnt,
        consume_money_user_bitmap,
        consume_money_amt,
        consume_money_cnt,
        consume_cert_user_bitmap,
        consume_cert_amt,
        consume_cert_cnt
    from dws.dws_consume_short_video_epis_consume_a
    where dt = '${bf_1_dt}'
),
tmp_epis AS (
    select
        dt,
        series_id,
        epis_num,
        watch_user_bitmap,
        watch_cnt,
        is_like_user_bitmap
    from dws.dws_video_interaction_short_video_epis_a
    where dt = '${bf_1_dt}'
),

tmp_a  as (
    select  coalesce(a.dt,b.dt) as dt,
            coalesce(a.series_id,b.series_id) as series_id,
            coalesce(a.epis_num,b.epis_num) as epis_num,
            a.consume_user_bitmap,
            a.consume_amt,
            a.consume_cnt,
            a.consume_money_user_bitmap,
            a.consume_money_amt,
            a.consume_money_cnt,
            a.consume_cert_user_bitmap,
            a.consume_cert_amt,
            a.consume_cert_cnt,
            b.watch_user_bitmap,
            b.watch_cnt,
            b.is_like_user_bitmap
    from  tmp_epis_consume a
    full join tmp_epis  b
      on a.dt = b.dt
          and a.series_id = b.series_id
          and a.epis_num = b.epis_num
),

tmp_d as (
 select  a.series_id,
         array_join(array_sort(array_distinct(array_agg(b.name))),'_') as series_tp
 from dim.dim_short_video_series_ref_type_view a
left join dim.dim_short_video_series_type_view b
        on a.series_type_id = b.id
 group by 1
),

tmp_b as (
 select  a.series_id,
         a.epis_num,
         a.epis_id,
         b.series_name,
         b.language as series_language,
         c.series_code,
         d.series_tp,
         c.cooperate_type,
         CASE WHEN a.epis_num >= b.pay_epis_from THEN 0 ELSE 1 END as is_free,
         a.duration as epis_length,
         a.price as epis_amount
 from dim.dim_short_video_epis_view a
          left join dim.dim_short_video_series_view b
                    on a.series_id = b.series_id
          left join dim.dim_short_video_source_series_view c
                    on b.source_series_id = c.series_id
          left join  tmp_d d
                     on a.series_id = d.series_id
 where a.is_delete = 0
   and b.series_id is not null
   and c.series_id is not null
)
select  a.dt,
        a.series_id,
        a.epis_num,
        b.epis_id,
        b.series_name,
        b.series_language,
        b.series_tp,
        b.cooperate_type,
        b.series_code,
        b.is_free,
        b.epis_length,
        b.epis_amount,
        a.consume_user_bitmap,
        a.consume_amt,
        a.consume_cnt,
        a.consume_money_user_bitmap,
        a.consume_money_amt,
        a.consume_money_cnt,
        a.consume_cert_user_bitmap,
        a.consume_cert_amt,
        a.consume_cert_cnt,
        a.watch_user_bitmap,
        a.watch_cnt,
        a.is_like_user_bitmap,
        now() as etl_time
from tmp_a a
left join tmp_b b
    on a.series_id = b.series_id
    and a.epis_num = b.epis_num;
