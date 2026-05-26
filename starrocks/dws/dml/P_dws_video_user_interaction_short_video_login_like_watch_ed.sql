----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_interaction_short_video_login_like_watch_ed
-- workflow_version : 4
-- create_user      : zhengtt
-- task_name        : dws_video_user_interaction_short_video_login_like_watch_ed
-- task_version     : 4
-- update_time      : 2025-02-06 01:23:33
-- sql_path         : \starrocks\tbl_dws_video_user_interaction_short_video_login_like_watch_ed\dws_video_user_interaction_short_video_login_like_watch_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_video_user_interaction_short_video_login_like_watch_ed
select  coalesce(a.dt,b.dt) as dt,coalesce(a.product_id,b.product_id) as user_id,
        coalesce(a.user_id,b.user_id) as user_id,a.login_cnt,a.watch_epis_bitmap,
        a.epis_watch_cnt,b.is_like_cnt,b.is_like_epis_bitmap,
        now() as etl_time
from
    (   select  coalesce(a.dt,b.dt) as dt,coalesce(a.product_id,b.product_id) as product_id,
                coalesce(a.user_id,b.user_id) as user_id,a.login_cnt,b.epis_watch_cnt,b.watch_epis_bitmap
        from
            (   select  dt,product_id,user_id,
                        count(user_id) as login_cnt
                from dwd.dwd_user_short_video_user_login_view
                where dt = '${bf_1_dt}' and user_id is not null
                group by 1,2,3
            ) a
            full join
        (   select  date(create_time) as dt,6833 as product_id,account_id as user_id,count(1) as epis_watch_cnt,
                    bitmap_union(to_bitmap(concat(series_id,epis_num))) as watch_epis_bitmap
            from  dwd.dwd_video_short_video_epis_history
            where date(create_time) = '${bf_1_dt}'
            group by 1,2,3
            ) b
        on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id
    ) a
    full join
(   select  a.dt,6833 as product_id,a.user_id,count(a.user_id) as is_like_cnt,
            bitmap_union(to_bitmap(concat(a.series_id,a.epis_num))) as is_like_epis_bitmap
    from
    (   select  a.dt,a.user_id,a.series_id,b.epis_num,
                row_number() over (partition by a.user_id,a.series_id,b.epis_num order by create_time) as rn
        from
        (	select  dt,user_id,epis_id,series_id,create_time
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
    group by 1,2,3
    ) b
on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id;
