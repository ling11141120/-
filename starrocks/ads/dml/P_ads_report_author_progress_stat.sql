----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_author_progress_stat
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : ads_report_author_progress_stat
-- task_version     : 1
-- update_time      : 2023-10-10 17:44:40
-- sql_path         : \starrocks\tbl_ads_report_author_progress_stat\ads_report_author_progress_stat
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_author_progress_stat
select 	'${dt}' as dt,site_id,role_type,count(author_id) as author_num,
		sum(cur_target) as cur_target_total,
		sum(font_curmonth_reach) as curmonth_reach_total,
		sum(font_curmonth_reach)/sum(cur_target) as total_reach_rate,
		sum(if(cur_reach_rate < 1,1,0)) as unreach_author_num,
		sum(if(cur_reach_rate < 1,1,0))/count(author_id) as unreach_num_rate ,now() as etl_time
from ads.ads_report_author_target_progress
where dt = '${bf_1_dt}'
group by 1,2,3;
