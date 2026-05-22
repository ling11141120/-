----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_group_tmp
-- task_version     : 5
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_group_tmp
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_AB_experiment_mul_group_tmp;

-- SQL语句
insert into ads.ads_report_AB_experiment_mul_group_tmp
select product_id, user_id,array_distinct(array_agg(group_id)) as group_ids,now() as etl_time
from dwd.dwd_market_userrealtimerecord_view
where end_time >= '${dt}'
group by 1, 2;
