----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_ab_exp_strategy_hit_user_di
-- workflow_version : 16
-- create_user      : xixg
-- task_name        : dwm_ab_exp_strategy_hit_user_di
-- task_version     : 16
-- update_time      : 2025-03-21 17:01:47
-- sql_path         : \starrocks\tbl_dwm_ab_exp_strategy_hit_user_di\dwm_ab_exp_strategy_hit_user_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwm.dwm_ab_exp_strategy_hit_user_di
SELECT
     c.dt,
     d.exp_id,
     d.exp_grp_id,
     d.exp_grp_ver_id,
     b.strategy_id,
     c.login_id as user_id,
     d.exp_start_time,
	 d.exp_end_time,
     d.start_time,
     d.end_time,
     min(c.event_tm) as event_tm,
     now()
from ods.ods_ab_hj_related b
INNER JOIN dwd.dwd_ab_exp_version_detail d  ON b.ab_id = d.exp_id  AND b.version_id = d.exp_grp_id
INNER JOIN ods_log.ods_sensors_realStrategyHit c  ON b.strategy_id = c.event_strategy_id   and c.event_tm >=d.start_time and c.event_tm <d.end_time  and c.event_tm >=d.exp_start_time and c.event_tm <d.exp_end_time
WHERE c.dt = '${dt}'
group by 1,2,3,4,5,6,7,8,9,10
;
