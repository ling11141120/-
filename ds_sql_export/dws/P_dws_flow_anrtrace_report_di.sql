----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_anrtrace_report_di
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : dws_flow_anrtrace_report_di
-- task_version     : 3
-- update_time      : 2024-10-16 12:02:56
-- sql_path         : \starrocks\tbl_dws_flow_anrtrace_report_di\dws_flow_anrtrace_report_di
----------------------------------------------------------------
-- 前置SQL语句
delete  from dws.dws_flow_anrtrace_report_di where dt>='${bf_7_dt}';

-- SQL语句
insert into  dws.dws_flow_anrtrace_report_di
select dt,product_id,corever,mt,appver,sum(report_cnt) as report_cnt,sum(device_cnt) as device_cnt,now() as etl_tm
from (
select dt,user_id,app_product_id as product_id,app_core_ver as corever,lib as mt,app_version as appver,count(distinct event_tm) as report_cnt ,count(distinct device_id) as device_cnt
from   dwd.dwd_sr_sensrs_production_anrtrace_view
where dt>='2024-07-22' -- 开始数据的时间
and dt>='${bf_7_dt}'
and sub_type='checkAndFinishAd'
and is_reader_page=0  -- 是否在阅读页 否
group by 1,2,3,4,5,6
) v
group by 1,2,3,4,5;
