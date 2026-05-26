----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_dc_user_statistic_info_di
-- workflow_version : 19
-- create_user      : hufengju
-- task_name        : ads_bi_dc_user_statistic_info_di_log
-- task_version     : 7
-- update_time      : 2025-11-10 17:45:05
-- sql_path         : \starrocks\tbl_ads_bi_dc_user_statistic_info_di\ads_bi_dc_user_statistic_info_di_log
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_dc_user_statistic_info_di_log`
select
	current_date() as dt_log,
	dt,
	md5_key,
	product_id,
	dc_code,
	dc_account,
	core,
	mt,
	user_type,
	new_user_count,
	pay_user_count,
	pay_order_count,
	pay_order_amount,
	etl_tm,
	now() as etl_tm_log
from ads.`ads_bi_dc_user_statistic_info_di`;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_dc_user_statistic_info_di_reset
-- workflow_version : 7
-- create_user      : hufengju
-- task_name        : ads_bi_dc_user_statistic_info_di_log
-- task_version     : 1
-- update_time      : 2025-01-08 13:35:14
-- sql_path         : \starrocks\tbl_ads_bi_dc_user_statistic_info_di_reset\ads_bi_dc_user_statistic_info_di_log
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_dc_user_statistic_info_di_log`
select
	current_date() as dt_log,
	dt,
	md5_key,
	product_id,
	dc_code,
	dc_account,
	core,
	mt,
	user_type,
	new_user_count,
	pay_user_count,
	pay_order_count,
	pay_order_amount,
	etl_tm,
	now() as etl_tm_log
from ads.`ads_bi_dc_user_statistic_info_di`;
