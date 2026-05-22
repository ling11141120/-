----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ods_tidb_SurgeAdData_log
-- workflow_version : 1
-- create_user      : hufengju
-- task_name        : ods_tidb_SurgeAdData_log
-- task_version     : 1
-- update_time      : 2025-05-16 10:53:26
-- sql_path         : \starrocks\sch_ods_tidb_SurgeAdData_log\ods_tidb_SurgeAdData_log
----------------------------------------------------------------
-- SQL语句
insert into ods.`ods_tidb_SurgeAdData_log`
select
	sr_createtime,
	Id,
	Date,
	Sessions,
	Clicks,
	RevenueNet,
	Ctr,
	Cpm,
	Cpc,
	UrlNo,
	UrlName,
	PartnerNo,
	PartnerName,
	sr_updatetime
from ods.`ods_tidb_SurgeAdData`;
