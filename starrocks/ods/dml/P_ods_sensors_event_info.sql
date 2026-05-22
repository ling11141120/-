----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_ad_if_date_country_adlpdailylnsight_tz
-- workflow_version : 18
-- create_user      : chenmo
-- task_name        : delete_ods_sensors_event_info
-- task_version     : 4
-- update_time      : 2024-11-21 10:13:56
-- sql_path         : \starrocks\sch_ads_ad_if_date_country_adlpdailylnsight_tz\delete_ods_sensors_event_info
----------------------------------------------------------------
-- SQL语句
delete from ods_log.`ods_sensors_event_info` where dt <= '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_ad_if_date_country_adlpdailylnsight_tz
-- workflow_version : 18
-- create_user      : chenmo
-- task_name        : hive_to_sr_ods_sensors_event_info
-- task_version     : 8
-- update_time      : 2026-04-15 15:23:54
-- sql_path         : \starrocks\sch_ads_ad_if_date_country_adlpdailylnsight_tz\hive_to_sr_ods_sensors_event_info
----------------------------------------------------------------
-- 前置SQL语句
delete from ods_log.`ods_sensors_event_info` where dt >= '${bf_1_dt}' and dt < '${af_1_dt}';

-- 前置SQL语句
REFRESH EXTERNAL TABLE  ods_log.ods_sensors_event_info_hive;

-- SQL语句
insert into ods_log.`ods_sensors_event_info`
select dt,
productid,
event,
userid,
position,
extid,
isretry,
serial,
ip,
createtime,
now() as etl_tm from ods_log.`ods_sensors_event_info_hive` where dt >= '${bf_1_dt}' and dt < '${af_1_dt}';
