----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_koc_star_result_data
-- workflow_version : 1
-- create_user      : hufengju
-- task_name        : ads_srsv_bi_koc_star_result_data
-- task_version     : 1
-- update_time      : 2025-02-22 11:40:51
-- sql_path         : \starrocks\tbl_ads_srsv_bi_koc_star_result_data\ads_srsv_bi_koc_star_result_data
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_srsv_bi_koc_star_result_data` where dt>='${bf_1_dt}';

-- SQL语句
insert into ads.`ads_srsv_bi_koc_star_result_data`
select dt,business_mode,institution_id,country_type,count(star_id) as new_star_num,now() as etl_tm
from (
	select date(a.CreateTime) as dt,a.CreateTime ,a.Id as star_id,a.InstitutionId as institution_id,
		case when b.country_type in(1,2) then country_type
			when b.country_type =0 and b.ip_country not  in('LAN','CN') and b.ip_country is not  null then 2
			else 1 end as country_type,
			if(a.InstitutionId=48,'ToC','ToB') as business_mode
	from dim.dim_koc_starinfo_view a
	left join dim.dim_koc_b_userinfo_tb_view b on a.UserId = b.user_id
	where date(a.CreateTime)>='${bf_1_dt}'
) a
group by 1,2,3,4;
