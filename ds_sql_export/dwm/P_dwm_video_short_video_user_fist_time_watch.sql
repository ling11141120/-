----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_video_short_video_user_fist_time_watch
-- workflow_version : 5
-- create_user      : zhengtt
-- task_name        : dwm_video_short_video_user_fist_time_watch
-- task_version     : 4
-- update_time      : 2025-03-27 21:21:18
-- sql_path         : \starrocks\tbl_dwm_video_short_video_user_fist_time_watch\dwm_video_short_video_user_fist_time_watch
----------------------------------------------------------------
-- SQL语句
insert into dwm.dwm_video_short_video_user_fist_time_watch
with tmp_data AS (
select  date(hours_add(create_time,-13)) as dt,
    account_id as user_id,
    series_id,
    epis_num,
    hours_add(create_time,-13) as create_time
from dwd.dwd_video_short_video_epis_history
-- 改为了实时，等于改为大于等于
where date(hours_add(create_time,-13))  >= '${bf_1_dt}' and length(series_id) >= 8
union all
select  dt,
        user_id,
        series_id,
        epis_num,
        create_time
from dwm.dwm_video_short_video_user_fist_time_watch
where dt < '${bf_1_dt}'
)

select  dt, user_id, series_id, epis_num, create_time,
        hours_add(create_time,12) as h12_time,
        hours_add(create_time,24) as h24_time,
        hours_add(create_time,168) as d7_time,
        hours_add(create_time,720) as d30_time,
        now() as etl_time
from
    (   select  dt, user_id, series_id, epis_num, create_time,
                row_number() over (partition by series_id,user_id order by create_time) as rn
        from tmp_data
    ) a
where rn = 1;
