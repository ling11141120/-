----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_video_short_video_epis_history_est
-- workflow_version : 13
-- create_user      : zhengtt
-- task_name        : dwd_video_short_video_epis_history_est
-- task_version     : 2
-- update_time      : 2025-03-11 01:33:06
-- sql_path         : \starrocks\tbl_dwd_video_short_video_epis_history_est\dwd_video_short_video_epis_history_est
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_video_short_video_epis_history_est
select
	date(hours_add(CreateTime,-13)) as dt,
	Id,
	AccountId,
	SeriesId,
	EpisId,
	-- if(a.WatchOver = 1,	ifnull(b.duration, a.WatchStamp),	a.WatchStamp) as WatchStamp,
	case when a.WatchOver = 1 then ifnull(b.duration, a.WatchStamp) else a.WatchStamp END AS WatchStamp,
	hours_add(CreateTime,
	-13) as create_time,
	EpisNum,
	regionId,
	WatchOver,
	now() as etl_time
from ods.ods_tidb_short_video_log_ext_epis_history_part2 a
left join dim.dim_short_video_epis_view b
on	a.EpisId = b.epis_id
	-- 改为实时，等于改为大于等于
where dt >= '${bf_3_dt}'
AND date(hours_add(CreateTime,-13)) >= '${bf_1_dt}';
