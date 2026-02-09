insert into dws.dws_video_user_watch_a_agg_mid1
select 6833 as product_id,account_id as user_id,series_id,epis_num,now()
from dwd.dwd_video_short_video_epis_history
where create_time='${bf_1_dt}';