----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_trade_user_subpay_type_da
-- workflow_version : 12
-- create_user      : hufengju
-- task_name        : ads_trade_user_subpay_type_da
-- task_version     : 7
-- update_time      : 2025-02-11 11:52:59
-- sql_path         : \starrocks\sch_ads_trade_user_subpay_type_da\ads_trade_user_subpay_type_da
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_trade_user_subpay_type_da  where product_id>0;

-- SQL语句
---==============调度================
insert into ads.ads_trade_user_subpay_type_da
select product_id,user_id,subpay_type ,now() as etl_time
from (
	select product_id,
			user_id,
			subpay_type,
			count(1) as num,
			rank() OVER (PARTITION BY product_id,user_id ORDER BY count(1) DESC, subpay_type  ) AS rank_desc
	from (
		select
			ProductId as product_id,
			UserId as user_id,
			case when SubPayType in ('paypal','PayPal','PayPalV2') then 'paypal'
			 	when SubPayType in ('Stripe') then 'stripe'
			 	end as subpay_type
		from dwd.dwd_trade_user_payorder
		where SubPayType in ('Stripe','paypal','PayPal','PayPalV2')

		union all

		select
			product_id,
			user_id,
			case when subpay_type in ('PayPal','PayPalV2') then 'paypal'
			 	when subpay_type in ('Stripe') then 'stripe'
			 	end as subpay_type
		from dwd.dwd_trade_short_video_payorder
		where subpay_type in ('Stripe','PayPal','PayPalV2')
		and test_flag = 0
		and status =0 -- 正常订单
	) a
	group by product_id,user_id,subpay_type
) a
where rank_desc = 1;
