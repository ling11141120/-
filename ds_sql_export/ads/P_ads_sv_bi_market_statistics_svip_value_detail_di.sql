----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_market_statistics_svip_info_di
-- workflow_version : 13
-- create_user      : hufengju
-- task_name        : tbl_ads_sv_bi_market_statistics_svip_value_detail_di
-- task_version     : 3
-- update_time      : 2025-01-24 16:57:05
-- sql_path         : \starrocks\tbl_ads_sv_bi_market_statistics_svip_info_di\tbl_ads_sv_bi_market_statistics_svip_value_detail_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sv_bi_market_statistics_svip_value_detail_di` where dt>='2025-01-01';

-- SQL语句
insert into ads.`ads_sv_bi_market_statistics_svip_value_detail_di`
select
	dt,
	app_name,
	mt,
	order_id,
	amount,
	user_id,
	create_time,
	shop_item_id,
	shop_item_type,
	vip_expire_time1,
	subscription_days,
	per_value,
	ifnull(b.datestr,a.dt) as value_dt,
	now() as etl_time
from ads.ads_sv_bi_market_statistics_svip_info_di a
left join dim.dim_date b on a.dt<=b.datestr and date(a.vip_expire_time1) > b.datestr
;
