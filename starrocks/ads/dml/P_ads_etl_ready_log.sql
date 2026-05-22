----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_etl_ready_log
-- task_version     : 4
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_etl_ready_log
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_etl_ready_log
select dt as create_time,count(1) as total_num
from ads.ads_offline_label_stat
where dt = '${bf_1_dt}'
group by 1;
