----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ods_sensors_production_anrTrace_external
-- workflow_version : 12
-- create_user      : yanxh
-- task_name        : ods_sensors_production_anrTrace_external
-- task_version     : 12
-- update_time      : 2025-07-31 19:06:17
-- sql_path         : \starrocks\tbl_ods_sensors_production_anrTrace_external\ods_sensors_production_anrTrace_external
----------------------------------------------------------------
-- SQL语句
------------------- 20241030 新调度：新增interface_language 新字段处理逻辑 ---------------------------------
  ------------------- 20241217 新调度：stack、content 新字段处理逻辑 ---------------------------------
insert into  ods_log.`ods_sensors_production_anrTrace_external`
select
	dt,
	id,
	track_id,
	rid,
	event_tm,
    event_push_time,
	device_id,
	login_id,
	identity_login_id,
	device_lang,
	event,
	distinct_id,
	identity_user_id,
	app_product_id,
	send_id,
	app_core_ver,
	app_channel,
	app_product_x,
	case left(app_product_id,3)
		when 775 then 1
		when 333 then 2
		when 336 then 3
		when 338 then 4
		when 332 then 5
		when 331 then 6
		when 337 then 7
		when 339 then 9
		when 350 then 11
		when 351 then 12
	end as 	app_lang_id,
	lib_version,
	app_version,
	type,
	os,
	lib,
	app_name,
	model,
	brand,
	appinfo,
	adpage,
	subtype,
	status,
	isReaderPage,
	duration,
	isOneMsg,
	cpuTime,
	msgTimeout,
	project_id,
	os_version,
	network_type,
	ip,
	manufacturer,
	null as country,
	null as region,
	null as city,
	etl_tm,
	app_lang_id as interface_language,
	stack,
	content
from  ods_log.`ods_sensors_production_anrTrace`
where dt>='${bf_1_dt}' and dt<='${dt}'
and project_id = 5;
