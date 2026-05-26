----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_app_load_cdtiming_ed
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : dws_flow_app_load_cdtiming_ed
-- task_version     : 3
-- update_time      : 2024-02-28 14:41:06
-- sql_path         : \starrocks\tbl_dws_flow_app_load_cdtiming_ed\dws_flow_app_load_cdtiming_ed
----------------------------------------------------------------
-- SQL语句
delete from dws.dws_flow_app_load_cdtiming_ed where dt>='${bf_4_dt}';

-- SQL语句
insert into dws.dws_flow_app_load_cdtiming_ed
select dt,product_id,corever,mt,app_ver,position ,type,channel_id,sum(serial)/1000 as cd_tms,count(1) as cd_cnt,now() as etl_tm
from  dwd.dwd_flow_app_cdtiming_view
where dt>='${bf_4_dt}'
and position in (20060010,20000010,20000011,60000000,60000010,60000013,60000014,60000015,60000016,50000000,50000010,30000017,30000018,
  40000010,40000011,40000012,40000013,40000014,40000015,40000016,40000018,40000017,30000021,30000022,20000012,30000019,30030002)
 and type in (7,8)
 and corever is not null
 and serial<5000
 and serial>=0
group by 1,2,3,4,5,6,7,8;
