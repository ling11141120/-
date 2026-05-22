----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_sv_strategy_info
-- workflow_version : 4
-- create_user      : hufengju
-- task_name        : dim_sv_strategy_info
-- task_version     : 1
-- update_time      : 2025-04-18 20:26:07
-- sql_path         : \starrocks\tbl_dim_sv_strategy_info\dim_sv_strategy_info
----------------------------------------------------------------
-- SQL语句
insert into dim.`dim_sv_strategy_info`
select *,now() as etl_tm
from (
	select
	Id id, Name name,
	max(StrategyCode) strategy_code,
	max(null) sort,
	max(case when action_type = 3 then sort end ) sort_popup,
	max(case when action_type =9 then sort end ) sort_return
	from ods.ods_tidb_short_video_center_activity t1
	left join
	ads.ads_tidb_short_video_center_activity_position_view t2
	on t1.Id=t2.center_activity_id
	group by 1,2
	union all
	select id,name,strategy_code,sort,null sort_popup, null sort_return
	from ads.ads_sv_goods_strategy_view
) a;
