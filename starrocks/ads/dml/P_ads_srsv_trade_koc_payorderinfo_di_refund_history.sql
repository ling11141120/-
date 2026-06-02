----------------------------------------------------------------
-- 程序功能： KOC订单信息-历史
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di_refund_history
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
----------------------------------------------------------------

--------------调度：KOC退款订单信息清洗------------------
-----------------20241104 新增字段core、current_language-----------------------------------
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select
      c.ref_order_id as ref_order_id,
	  a.status as status,
	  date(a.create_time) as dt ,
      c.code as code  ,
      c.story_id as story_id,
      c.story_name as story_name,
      c.amount as amount,
	  c.base_amount,
      c.project_type as project_type, -- 1:海阅 2：海剧
      c.institution_user_id as institution_user_id,
      c.star_user_id as star_user_id,
      a.create_time as create_time,
      now() as etl_tm,
	  c.core as core,
	  c.current_language as current_language
from
(
	-- 海阅的退款订单---
	select ProductId as product_id ,UserId as user_id,OrderId as order_id,1 as status,1 as project_type,
	null as book_id,
	refund_time as create_time,  -- 取退款时间
	sum(ItemCount) item_count,
	sum(BaseAmount)/100 as base_amount
	from dwd.dwd_sr_trade_user_refund_order_di
	where dt>='${bf_30_dt}' and dt<='${dt}'
	--and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
	group by 1 ,2 ,3 ,4 ,5,6,7

	union all
	-- 海剧的退款订单---
	select product_id ,user_id ,order_id,status,2 as project_type,
	cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id,
	dt as create_time ,
	sum(item_count) as item_count ,
	sum(base_amount)/100 as base_amount
	from  dwd.dwd_trade_short_video_payorder_view
	where dt >= '${bf_30_dt}' and dt<='${dt}'
	and product_id = 6833
	--and  package_id like  '%Ps_Half%'
	and test_flag = 0
	and status = 1 -- 退款订单
	group by 1 ,2 ,3 ,4 ,5,6,7
) a
inner join  ------退款订单关联koc订单
	ads.ads_srsv_trade_koc_payorderinfo_di c  on a.order_id = c.ref_order_id and c.status=0
where date(a.create_time)>='${bf_3_dt}'
;