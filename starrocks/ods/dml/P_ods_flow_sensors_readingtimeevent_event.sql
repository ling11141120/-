----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sensors_exposure_bulu
-- workflow_version : 1
-- create_user      : admin
-- task_name        : ods_flow_sensors_readingtimeevent_event
-- task_version     : 1
-- update_time      : 2023-10-18 13:34:11
-- sql_path         : \starrocks\sensors_exposure_bulu\ods_flow_sensors_readingtimeevent_event
----------------------------------------------------------------
-- SQL语句
insert  into ods.ods_flow_sensors_readingtimeevent_event
select dt,COALESCE (rid,track_id),track_id,rid,from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,userid,mt,corever,prodid,appver,event,
from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') createtime,
detail,productid,now() etl_time
from ods.ods_flow_sensors_readingtimeevent_event_hive where dt = '${bf_1_dt}';
