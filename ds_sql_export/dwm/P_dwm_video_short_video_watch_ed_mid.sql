----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_video_short_video_watch_ed_mid
-- workflow_version : 3
-- create_user      : zhengtt
-- task_name        : dwm_video_short_video_watch_ed_mid
-- task_version     : 3
-- update_time      : 2024-01-04 19:00:50
-- sql_path         : \starrocks\tbl_dwm_video_short_video_watch_ed_mid\dwm_video_short_video_watch_ed_mid
----------------------------------------------------------------
-- SQL语句
insert into dwm.dwm_video_short_video_watch_ed_mid
select '${dt}' as dt,6833 as product_id ,series_id,epis_num,bitmap_union(to_bitmap(user_id)) as watch_user_90,now() as etl_time
from dwm.dwm_video_short_video_watch_consume_ed
where dt < '${dt}' and dt >= date_sub('${dt}',interval 90 day) and epis_watch_num_real is not null
group by 1,2,3,4;
