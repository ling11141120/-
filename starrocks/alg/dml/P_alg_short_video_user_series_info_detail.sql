----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_short_video_user_series_info_
-- workflow_version : 12
-- create_user      : admin
-- task_name        : alg_short_video_user_series_info_detail
-- task_version     : 6
-- update_time      : 2025-03-31 18:26:18
-- sql_path         : \starrocks\tbl_alg_short_video_user_series_info_\alg_short_video_user_series_info_detail
----------------------------------------------------------------
-- SQL语句
insert into alg.alg_short_video_user_series_info_detail
select
 a.dt
,a.user_id
,a.series_id
,a.epis_id
,a.epis_num
,case when b.series_id is not null then true else false end is_unlock
,case when count(case when a.end_last_time is not null then 1 end)>0 then true else false end is_complete
,case when sum(a.is_like_num)>0 then true else false end is_like
,sum(a.epis_coin_consume_amount) coin_amt
,sum(a.epis_cert_consume_amount) cert_amt
,CURRENT_TIMESTAMP() etl_tm
from dwm.dwm_video_short_video_watch_consume_ed a
left join dwd.dwd_short_video_series_unlock_view b on a.user_id =b.account_id and a.series_id=b.series_id and a.epis_id =b.epis_id
where dt >='${bf_3_dt}'
group by 1,2,3,4,5,6
;
