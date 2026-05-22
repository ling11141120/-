----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_koc_star_attribution_result_data
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads_srsv_koc_star_attribution_result_data
-- task_version     : 1
-- update_time      : 2025-03-24 20:10:20
-- sql_path         : \starrocks\tbl_ads_srsv_koc_star_attribution_result_data\ads_srsv_koc_star_attribution_result_data
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_srsv_koc_star_attribution_result_data`
select *
from (
	select
		a.dt,a.product_id,c.InstitutionId as institution_id,c.StarId as star_id,a.koc_code ,
		if(minutes_diff(a.create_time,b.create_time)<1440,1,0) as user_type	,
		a.user_id,b.reg_country,b.ip,a.create_time,now() as etl_tm
	from (
		select dt,product_id,product_tp,koc_code,user_id,create_time
		from (
			select date(create_time) as dt,product_id ,if(product_id=6833,2,1) as product_tp,koc_text as koc_code,user_id,create_time,
			 		row_number() over(partition by if(product_id=6833,2,1),user_id order by create_time ) rn
			from dwd.dwd_srsv_advertisement_koc_attribution_record_view
		) a
		where rn=1
		and dt>='${bf_3_dt}'
	) a
	left join (
		select product_id,1 as product_tp,id as user_id,create_time,reg_country ,reg_ip  as ip
		from dim.dim_user_account_info_view
		where dt>='${bf_3_dt}'
		union all
		select product_id,2 as product_tp,user_id,create_time,reg_country ,ip
		from dim.dim_short_video_user_accountinfo
		where dt>='${bf_3_dt}'
	) b on a.product_tp=b.product_tp and a.user_id=b.user_id
	left join ods.ods_tidb_koc_codeinfo c on a.koc_code = c.KocCode
) a
where a.user_type=1
and a.dt>='${bf_1_dt}';
