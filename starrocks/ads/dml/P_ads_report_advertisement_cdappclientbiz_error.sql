----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_advertisement_cdappclientbiz_error
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : tbl_ads_report_advertisement_cdappclientbiz_error
-- task_version     : 6
-- update_time      : 2023-11-23 15:04:16
-- sql_path         : \starrocks\tbl_ads_report_advertisement_cdappclientbiz_error\tbl_ads_report_advertisement_cdappclientbiz_error
----------------------------------------------------------------
-- 前置SQL语句
REFRESH EXTERNAL TABLE ods.ods_sensors_cdappclientbiz_info;

-- 前置SQL语句
delete  from ads.ads_report_advertisement_cdappclientbiz_error  where  dt = '${bf_1_dt}';

-- SQL语句
insert into  ads.ads_report_advertisement_cdappclientbiz_error
   select  dt, product_id,create_time,count_type,mt,corever,adid,ad_position,error_type,error_code,ad_inter_mediary,place_ment_id,nums,times,now() as etl_time
   from (
 -- --------------------------count_type=2 -------------------------

	 select dt, product_id,date(create_time) as create_time,2 as count_type,mt,corever,adid,
	 (case when corever in (1,2) then ad_position_c1_c2 when corever=3 then ad_position_c3 end) as ad_position,
	 (case when mt= 'iOS' then regexp_extract(error_type_1, '\"[^\"]+\"', 0)
	 when mt ='Android' then error_type_4 end) as error_type,
	  (case when mt= 'iOS' then error_code_1
	 when mt ='Android' then error_code_4 end) as error_code,ad_inter_mediary,place_ment_id,count(distinct user_id) as nums,count(1) as times
	 from dwd.dwd_advertisement_sensors_cdappclientbiz_view
	 where
	  dt >= '${bf_1_dt}' and dt < '${dt}'
   and product_id !=-1
	and ads_typs='AdMobAdError'
group by  1,2,3,4,5,6,7,8,9,10,11,12
union all
 -- --------------------------count_type=1 -------------------------
	 select dt, product_id,DATE_FORMAT(create_time,'%Y-%m-%d %H') as create_time,1 as count_type,mt,corever,adid,
	 (case when corever in (1,2) then ad_position_c1_c2 when corever=3 then ad_position_c3 end) as ad_position,
	 (case when mt= 'iOS' then regexp_extract(error_type_1, '\"[^\"]+\"', 0)
	 when mt ='Android' then error_type_4 end) as error_type,
	  (case when mt= 'iOS' then error_code_1
	 when mt ='Android' then error_code_4 end) as error_code,ad_inter_mediary,place_ment_id,count(distinct user_id) as nums,count(1) as times
	 from dwd.dwd_advertisement_sensors_cdappclientbiz_view
	 where
	  dt >= '${bf_1_dt}' and dt < '${dt}'
   and product_id !=-1
	and ads_typs='AdMobAdError'
group by  1,2,3,4,5,6,7,8,9,10,11,12
) x where  length(adid)<=40 and length(error_type)<=150;
