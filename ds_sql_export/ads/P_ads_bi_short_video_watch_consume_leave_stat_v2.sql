----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_watch_consume_leave_stat_v2
-- workflow_version : 27
-- create_user      : zhengtt
-- task_name        : ads_bi_short_video_watch_consume_leave_stat_v2
-- task_version     : 18
-- update_time      : 2025-09-23 17:49:52
-- sql_path         : \starrocks\tbl_ads_bi_short_video_watch_consume_leave_stat_v2\ads_bi_short_video_watch_consume_leave_stat_v2
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_watch_consume_leave_stat_v2 where dt >= '${bf_31_dt}' and dt <= '${dt}';

-- SQL语句
insert into ads.ads_bi_short_video_watch_consume_leave_stat_v2
select
    dt,
    md5(concat(product_id,series_id,epis_num,user_tp,source_user_tp,
            if(corever is null,-99,corever),
            if(mt is null,-99,mt),
            if(Source is null,-99,Source),
            if(ad_set_id is null,-99,ad_set_id))) as md5_key,
    product_id,
    series_id,epis_num,user_tp,source_user_tp,series_name,language,series_code,corever,
    mt,Source,ad_set_id, epis_length,preceding_current_duration,
    bitmap_agg(if(type = 2 and date(create_time) = date(create_times),user_id,null)) as watch_user_bitmap,
    bitmap_agg(if(type = 1 and date(create_time) = date(create_times),user_id,null)) as consume_user_bitmap,
    bitmap_agg(if(type = 1 and consume_type = 0 and date(create_time) = date(create_times),user_id,null)) as consume_coin_user_bitmap,
    sum(if(type = 1 and date(create_time) = date(create_times),consume_value,0)) as video_consume_amt,
    bitmap_agg(if(type = 2 and create_time >= create_times and create_time <= h12_time,user_id,null)) as watch_user_bitmap_12h,
    bitmap_agg(if(type = 1 and create_time >= create_times and create_time <= h12_time,user_id,null)) as consume_user_bitmap_12h,
    bitmap_agg(if(type = 1 and consume_type = 0 and  create_time >= create_times and create_time <= h12_time,user_id,null)) as consume_coin_user_bitmap_12h,
    sum(if(type = 1  and create_time >= create_times and create_time <= h12_time,consume_value,0)) as video_consume_amt_12h,
    bitmap_agg(if(type = 2 and create_time >= create_times and create_time <= h24_time,user_id,null)) as watch_user_bitmap_24h,
    bitmap_agg(if(type = 1 and create_time >= create_times and create_time <= h24_time,user_id,null)) as consume_user_bitmap_24h,
    bitmap_agg(if(type = 1 and consume_type = 0 and  create_time >= create_times and create_time <= h24_time,user_id,null)) as consume_coin_user_bitmap_24h,
    sum(if(type = 1  and create_time >= create_times and create_time <= h24_time,consume_value,0)) as video_consume_amt_24h,
    bitmap_agg(if(type = 2 and create_time >= create_times and create_time <= d7_time,user_id,null)) as watch_user_bitmap_7d,
    bitmap_agg(if(type = 1 and create_time >= create_times and create_time <= d7_time,user_id,null)) as consume_user_bitmap_7d,
    bitmap_agg(if(type = 1 and consume_type = 0 and  create_time >= create_times and create_time <= d7_time,user_id,null)) as consume_coin_user_bitmap_7d,
    sum(if(type = 1  and create_time >= create_times and create_time <= d7_time,consume_value,0)) as video_consume_amt_7d,
    bitmap_agg(if(type = 2 and create_time >= create_times and create_time <= d30_time,user_id,null)) as watch_user_bitmap_30d,
    bitmap_agg(if(type = 1 and create_time >= create_times and create_time <= d30_time,user_id,null)) as consume_user_bitmap_30d,
    bitmap_agg(if(type = 1 and consume_type = 0 and  create_time >= create_times and create_time <= d30_time,user_id,null))  as consume_coin_user_bitmap_30d,
    sum(if(type = 1  and create_time >= create_times and create_time <= d30_time,consume_value,0)) as video_consume_amt_30d,
    now() as etl_time
from (
    select
        a.dt,
        a.product_id,
        a.series_id,
        a.epis_num,
        a.user_id,
        a.create_time as create_times,
        a.create_time,
        a.h12_time, a.h24_time,
        a.d7_time, a.d30_time,
        a.consume_type, a.consume_value, a.type,
        a.source_user_tp, a.user_tp,
        a.source,
        c.series_name, c.language, c.series_code,
        a.mt, a.corever,
        e.ad_set_id,
        d.epis_length, d.preceding_current_duration
    from (
        select
            a.dt,
            6833 as product_id,
            a.series_id,
            b.epis_num,
            a.user_id,
            a.create_time as create_times,
            b.create_time,
            a.h12_time, a.h24_time,
            a.d7_time, a.d30_time,
            b.consume_type, b.consume_value, b.type,
            a.source_user_tp, a.user_tp,
            a.source, a.ad_id,
            a.mt, a.corever
        from (
            select
                *
            from dws.dws_video_short_video_user_fist_time_watch_mid
            where dt >= '${bf_31_dt}' and dt <= '${dt}' and date_add(create_time, interval 13 hour) < date_format(now(), '%Y-%m-%d %H:00:00')
        ) a
        left join (
            select user_id, series_id, epis_num, create_time, consume_type, consume_value, 1 as type
            from dwm.dwm_consume_short_video_user_consume_est
            where dt >= '${bf_31_dt}' and dt <= '${dt}'
            union all
            select account_id, series_id, epis_num, create_time, null as consume_type, null as consume_value, 2 as type
            from dwd.dwd_video_short_video_epis_history_est
            where dt >= '${bf_31_dt}' and dt <= '${dt}'
        ) b on a.series_id = b.series_id and a.user_id = b.user_id
    ) a
    left join dim.dim_short_video_series_view c
    on a.series_id = c.series_id
    left join (
        select
            series_id, epis_num, duration as epis_length, preceding_current_duration
        from dim.dim_short_video_epis_view
        where is_delete = 0
    ) d on a.series_id = d.series_id and a.epis_num = d.epis_num
    left join (
        select
            ad_id, ad_set_id
        from ads.ads_advertisement_adext_view
        where product_id = 6833 and ad_id is not null
    ) e on a.ad_id = e.ad_id
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
) a
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16;
