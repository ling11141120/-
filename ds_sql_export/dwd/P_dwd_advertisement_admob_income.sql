----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_admob_income
-- workflow_version : 10
-- create_user      : zhengtt
-- task_name        : dwd_advertisement_admob_income_1
-- task_version     : 10
-- update_time      : 2025-03-29 01:53:32
-- sql_path         : \starrocks\tbl_dwd_advertisement_admob_income\dwd_advertisement_admob_income_1
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_advertisement_admob_income
select 	date(DATE) as dt,a.Id,1 as time_types,AD_UNIT,PLATFORM,AD_SOURCE,IFNULL(b.name, 'AdMob Network') as name,
		APP,AD_REQUESTS,CLICKS,ESTIMATED_EARNINGS/1000000 as ad_amount,IMPRESSIONS,
		MATCHED_REQUESTS,MATCH_RATE,OBSERVED_ECPM,Account,a.CreatedTime,
		a.UpdatedTime,now() as etl_time,appver
from
(
	select dt,Id,DATE,AD_UNIT,app_version_name as appver,PLATFORM,AD_SOURCE,APP,AD_REQUESTS,CLICKS,ESTIMATED_EARNINGS,IMPRESSIONS,MATCHED_REQUESTS,MATCH_RATE,OBSERVED_ECPM,Account,CreatedTime,UpdatedTime
	from ods.ods_tidb_qadata_admobmediationreportbyappver a
	where date >= '${bf_4_dt}'
) a
left join ods.ods_tidb_sharpengine_ads_global_admobadsources b
on a.AD_SOURCE = b.AdSourceId;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_admob_income
-- workflow_version : 10
-- create_user      : zhengtt
-- task_name        : dwd_advertisement_admob_income_2
-- task_version     : 1
-- update_time      : 2025-03-29 01:53:32
-- sql_path         : \starrocks\tbl_dwd_advertisement_admob_income\dwd_advertisement_admob_income_2
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_advertisement_admob_income
select 	date(DATE) as dt,a.Id,2 as time_types,AD_UNIT,PLATFORM,AD_SOURCE,IFNULL(b.name, 'AdMob Network') as name,
		APP,AD_REQUESTS,CLICKS,ESTIMATED_EARNINGS/1000000 as ad_amount,IMPRESSIONS,
		MATCHED_REQUESTS,MATCH_RATE,OBSERVED_ECPM,Account,a.CreatedTime,
		a.UpdatedTime,now() as etl_time,appver
from
(	select dt,Id,DATE,AD_UNIT,COUNTRY as appver,PLATFORM,AD_SOURCE,APP,AD_REQUESTS,CLICKS,ESTIMATED_EARNINGS,IMPRESSIONS,MATCHED_REQUESTS,MATCH_RATE,OBSERVED_ECPM,Account,CreatedTime,UpdatedTime
	from ods.ods_tidb_sharpengine_ads_global_admobmediationreportest a
	where date >= '${bf_4_dt}'
) a
left join ods.ods_tidb_sharpengine_ads_global_admobadsources b
on a.AD_SOURCE = b.AdSourceId;
