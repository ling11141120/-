----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_interaction_short_video_epis_a
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dws_video_interaction_short_video_epis_a
-- task_version     : 1
-- update_time      : 2024-01-26 15:20:19
-- sql_path         : \starrocks\tbl_dws_video_interaction_short_video_epis_a\dws_video_interaction_short_video_epis_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_video_interaction_short_video_epis_a
select  '${bf_1_dt}' as dt,series_id,epis_num,
        bitmap_union(watch_user_bitmap) as watch_user_bitmap,
        sum(watch_cnt) as watch_cnt,
        bitmap_union(is_like_user_bitmap) as is_like_user_bitmap,
        now() as etl_time

from
(   select  coalesce(a.series_id,b.series_id) as series_id,
            coalesce(a.epis_num,b.epis_num) as epis_num,a.watch_user_bitmap,
            a.watch_cnt,b.is_like_user_bitmap
    from
        (   select  a.series_id,a.epis_num,
                    bitmap_union(to_bitmap(a.account_id)) as watch_user_bitmap,
                    count(1) as watch_cnt
            from  dwd.dwd_video_short_video_epis_history a
                      left join dim.dim_short_video_series_view b
                                on a.series_id = b.series_id
            where date(create_time) = '${bf_1_dt}' and b.series_id is not null
            group by 1,2
        ) a
        full join
        (   select  a.series_id,a.epis_num,
                    bitmap_union(to_bitmap(a.user_id)) as is_like_user_bitmap
            from
            (   select  a.user_id,a.series_id,b.epis_num,
                        row_number() over (partition by a.series_id,b.epis_num order by create_time) as rn
                from
                (	select  user_id,epis_id,series_id,create_time
                    from dwd.dwd_video_short_video_account_like_view
                    where dt = '${bf_1_dt}' and series_id is not null
                    ) a
                left join
                (	select	epis_id,epis_num
                    from dim.dim_short_video_epis_view
                    ) b
                on a.epis_id = b.epis_id
                where b.epis_id is not null
                ) a
            where a.rn = 1
            group by 1,2
            ) b
    on  a.series_id = b.series_id and a.epis_num = b.epis_num
    union all
    select  series_id, epis_num, watch_user_bitmap, watch_cnt, is_like_user_bitmap
    from dws.dws_video_interaction_short_video_epis_a
    where dt = '${bf_2_dt}'
    ) a
group by 1,2,3;
