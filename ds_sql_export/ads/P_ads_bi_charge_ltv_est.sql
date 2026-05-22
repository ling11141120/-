----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_charge_ltv_est
-- workflow_version : 13
-- create_user      : hufengju
-- task_name        : ads_bi_charge_ltv_est
-- task_version     : 8
-- update_time      : 2025-04-25 14:17:11
-- sql_path         : \starrocks\tbl_ads_bi_charge_ltv_est\ads_bi_charge_ltv_est
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_charge_ltv_est`
select
	md5(concat_ws('_',`dt`,`user_period`,`product_id`,`which_weeks`,`which_months`,`corever`,`mt`,`reg_country`,`country_level`,`current_language2`,`source`,`chl2`,`chl`,`source_chl`,`user_ad_source`)) as md5_key
	,*
	,now() as etl_tm
from ads.ads_bi_charge_ltv_est_view a
where dt>='${bf_31_dt}'
and product_id=6833
;
