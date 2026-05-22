----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_short_video_epis_ed
-- workflow_version : 2
-- create_user      : zhengtt
-- task_name        : ads_wide_short_video_epis_ed
-- task_version     : 2
-- update_time      : 2024-01-20 11:40:30
-- sql_path         : \starrocks\tbl_ads_wide_short_video_epis_ed\ads_wide_short_video_epis_ed
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_wide_short_video_epis_ed
select  a.dt, a.series_id, a.epis_num,b.epis_id,b.series_name,b.series_language,
        b.series_tp,b.cooperate_type,b.series_code,b.is_free,b.epis_length,b.epis_amount,
        a.consume_user_bitmap, a.consume_amt, a.consume_cnt, a.consume_money_user_bitmap,
        a.consume_money_amt, a.consume_money_cnt, a.consume_cert_user_bitmap, a.consume_cert_amt,
        a.consume_cert_cnt, a.watch_user_bitmap,  a.watch_cnt,
        a.is_like_user_bitmap,now() as etl_time
from
    (   select  coalesce(a.dt,b.dt) as dt,coalesce(a.series_id,b.series_id) as series_id,
                coalesce(a.epis_num,b.epis_num) as epis_num,
                a.consume_user_bitmap,a.consume_amt,a.consume_cnt,
                a.consume_money_user_bitmap,
                a.consume_money_amt,a.consume_money_cnt,a.consume_cert_user_bitmap,
                a.consume_cert_amt,a.consume_cert_cnt,b.watch_user_bitmap,
                b.watch_cnt,b.is_like_user_bitmap
        from dws.dws_consume_short_video_epis_consume_ed a
                 full join dws.dws_video_interaction_short_video_epis_ed b
                           on a.dt = b.dt and a.series_id = b.series_id and a.epis_num = b.epis_num
        where coalesce(a.dt,b.dt) = '${bf_1_dt}'
    ) a
        left join
    (   select  a.series_id,a.epis_num,a.epis_id,
                b.series_name,b.language as series_language,c.series_code,d.series_tp,
                c.cooperate_type,
                if(a.epis_num >= b.pay_epis_from,0,1) as is_free,
                a.duration as epis_length,a.price as epis_amount
        from dim.dim_short_video_epis_view a
                 left join dim.dim_short_video_series_view b
                           on a.series_id = b.series_id
                 left join dim.dim_short_video_source_series_view c
                           on b.source_series_id = c.series_id
                 left join
             (   select  a.series_id,array_join(array_sort(array_distinct(array_agg(b.name))),'_') as series_tp
                 from dim.dim_short_video_series_ref_type_view a
                          left join dim.dim_short_video_series_type_view b
                                    on a.series_type_id = b.id
                 group by 1
             ) d
             on a.series_id = d.series_id
        where a.is_delete = 0 and b.series_id is not null and c.series_id is not null
    ) b
    on a.series_id = b.series_id and a.epis_num = b.epis_num;
