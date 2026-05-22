----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_group_tmp
-- task_version     : 5
-- update_time      : 2024-10-16 16:00:43
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_group_tmp
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_sv_AB_experiment_mul_group_tmp;

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul_group_tmp
select 6833 as product_id, ifnull(replace(account,'"',''),-99) as user_id,array_distinct(array_agg(group_id)) as group_ids,now() as etl_time
from dim.dim_user_short_video_group_user_view
where end_ts>unix_timestamp('${dt}')
group by 1, 2;
