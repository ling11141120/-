----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_video_short_video_watch_wz5_ed_mid
-- workflow_version : 5
-- create_user      : zhengtt
-- task_name        : dwm_video_short_video_watch_wz5_ed_mid
-- task_version     : 4
-- update_time      : 2024-11-08 17:24:27
-- sql_path         : \starrocks\tbl_dwm_video_short_video_watch_wz5_ed_mid\dwm_video_short_video_watch_wz5_ed_mid
----------------------------------------------------------------
-- SQL语句
insert into dwm.dwm_video_short_video_watch_wz5_ed_mid
select '${dt}' as dt,6833 as product_id ,series_id,bitmap_union(to_bitmap(account_id)) as watch_user_90,now() as etl_time
from dwd.dwd_video_short_video_epis_history
-- 改为实时，小于改为小于等于
where date(hours_add(create_time,-13)) <= '${dt}' and date(hours_add(create_time,-13)) >= date_sub('${dt}',interval 90 day) and length(series_id) >= 8
group by 1,2,3;
