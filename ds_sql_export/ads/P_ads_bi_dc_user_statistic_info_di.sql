----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_dc_user_statistic_info_di_reset
-- workflow_version : 7
-- create_user      : hufengju
-- task_name        : ads_bi_dc_user_statistic_info_di
-- task_version     : 6
-- update_time      : 2025-01-09 10:01:00
-- sql_path         : \starrocks\tbl_ads_bi_dc_user_statistic_info_di_reset\ads_bi_dc_user_statistic_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_bi_dc_user_statistic_info_di` where dt>'2024-01-01';

-- SQL语句
insert into  ads.`ads_bi_dc_user_statistic_info_di`
with install_user as (
	select a.dt,a.product_id,a.user_id,a.install_date,a.next_attribute_time,a.is_delete,a.ad_id,a.book_id ,a.mt,a.core,b.inst_id,b.dc_acct
	from (
		select dt,Product_Id,User_Id,Install_Date,
		 next_attribute_time,
		IsDelete as is_delete, ad_id ,Book_Id,mt,core
		from dwd.dwd_user_install_info_ed_view
		where Product_Id =6833
		and IsDelete=0
	) a
	inner join (
		select product_id, ad_id,book_id,inst_id,dc_acct
		from dwd.dwd_advertisement_adext_view
		where product_id =6833
		and inst_id>0
	) b on a.Ad_Id = b.ad_id
) ,
install_user_count as (
	select dt,product_id,ad_id,mt,core,inst_id,dc_acct,count(distinct user_id) as dev_unt
	from install_user
	group by 1,2,3,4,5,6,7
)
select
	a.dt,
	md5(concat_ws('_',a.dt,a.product_id,a.user_type,a.dc_code,a.dc_account,a.core,a.mt))  as md5_key,
	a.product_id,
	a.dc_code as dc_code,
	a.dc_account as dc_account,
	a.core as core,
	a.mt as mt,
	a.user_type,
	ifnull(sum(new_user_count),0) as new_user_count,
	ifnull(sum(pay_user_count),0) as pay_user_count,
	ifnull(sum(pay_order_count),0) as pay_order_count,
	ifnull(sum(pay_order_amount),0) as pay_order_amount,
	now()  as etl_tm
from (
	select
		dt,
		product_id,
		user_type,
		 dc_code,
		 dc_account,
		 core,
		 mt,
		null as new_user_count,
		count(distinct user_id) as pay_user_count,
		count(order_id) as pay_order_count,
		ifnull(sum(amount),0) as pay_order_amount
	from (
		select
			b.order_id,
			b.dt,
			6833 as product_id,
			b.user_type,
			b.dc as dc_code,
			b.dc_account as dc_account,
			b.core as core,
			b.mt as mt,
			b.user_id,
			b.amount
		from
		(
			select
			dt,UserId as user_id,OrderSerialId as order_id,Amount/100 as amount,BaseAmount/100 as base_amount,RateAmount/100 as rate_amount,
			OrderCreateTime as create_time,dc,DcAccount as dc_account,OsType as mt,core,PaySource as book_id,AccountCreateTime as user_install_time,
			if(date(AccountCreateTime)=date(OrderCreateTime),1,0) as user_type
			from dwd.dwd_pay_order_for_dc_view
		) b
	) a
	group by 1,2,3,4,5,6,7

	union all

	select dt,6833 as product_id,1 as user_type,inst_id as dc_code ,dc_acct as dc_account, core, mt,dev_unt as new_user_count,0 as pay_user_count,0 as pay_order_count,0 as pay_order_amount
	from install_user_count
) a
group by 1,2,3,4,5,6,7,8;
