----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_trade_user_subscribe_di
-- workflow_version : 27
-- create_user      : hufengju
-- task_name        : ads_bi_trade_user_subscribe_di
-- task_version     : 26
-- update_time      : 2025-12-24 15:01:30
-- sql_path         : \starrocks\tbl_ads_bi_trade_user_subscribe_di\ads_bi_trade_user_subscribe_di
----------------------------------------------------------------
-- SQL语句
-- ads_bi_trade_user_subscribe_di
-- 海阅
-- -===================调度======================
insert into ads.ads_bi_trade_user_subscribe_di
with t as (
	select a.dt,a.ProductId as product_id,a.UserId as user_id,CoreVer as core,mt,a.ShopItem as shop_item,ItemCount as item_count,OrderId as order_id,
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'readerfr.',-1),'minireaderfr.',-1),
				'cdycnovelfr.',-1),'tcreader.',-1),'minireaderft.',-1),'minireaderen.',-1),'ereader.',-1),'readerpt.',-1),'novelpt.',-1) ,'spainreader.',-1),'noveltw.',-1),
				'novelen.',-1),'readerru.',-1),'minireaderes.',-1),'minireaderth.',-1),'readerid.',-1),'thai.',-1),
				'noveles.',-1),'novelru.',-1),'reader4.',-1),'novelth.',-1),'novelid.',-1),'readerja.',-1),'novelja.',-1)
				as item_id,
          ExtInfo as ext_info,
          CreateTime,
          AutoId as auto_id,
		  SubPayType as sub_pay_type,
		  a.userid as charge_cnt ,
		  str_to_date(VipExpireTime,'%Y-%m-%d %H:%i:%s') as vip_expire_time,
		  a.BaseAmount as base_amount,
		  CasE WHEN a.dt < '2021-02-01' AND a.systemtype IN ( 336617, 336651 ) AND a.itemcount > 0 THEN a.itemcount * 0.014
				  WHEN a.dt < '2021-02-01' THEN a.itemcount ELSE a.baseamount/100 END  as after_charge,
		  SUBSTRING_INDEX(SUBSTRING_INDEX(CooOrderExtInfo,'"AutoRenewTimes":',-1),',"SubscribeStatus":',1) as autorenew_times,
		  SUBSTRING_INDEX(SUBSTRING_INDEX(CooOrderExtInfo,'"SubscribeStatus":',-1),'}',1) as subscribe_status
		  ,	case get_json_string(SensorsData,'$.subscription_period')
					when 1 then '周卡' when 2 then '月卡' when 3 then '季卡' when 4 then '年卡' when 5 then '天卡'
					end as item_type
		from dwd.dwd_trade_user_payorder  a   -- -----------交易域用户充值事实表
		 where a.dt ='${bf_1_dt}'
		 and a.ShopItem in (810,830,840,850,800,860)
),roll as (
    select
       product_id,
       user_id,
       shop_item,
       item_id,
       recharge_cnt,
       etl_time
from dws.dws_trade_user_item_subscribe_roll_a
where dt = '${bf_2_dt}'
), t1 as (
    select dt, t0.product_id, t0.user_id, t0.core, t0.mt, t0.shop_item, t0.item_count,t0.order_id,
    t0.item_id, t0.ext_info, (recharge_cnt_day + ifnull(recharge_cnt, 0) -1) as subscribe_cnt, sub_pay_type, charge_cnt ,auto_id,
     vip_expire_time, base_amount, after_charge, autorenew_times, subscribe_status, CreateTime,item_type
     from
     (
		select *,count() over(partition by dt, product_id, user_id, shop_item, item_id order by CreateTime, auto_id) as recharge_cnt_day from t
      )t0
    left join roll
    on t0.product_id = roll.product_id and t0.user_id = roll.user_id and t0.shop_item = roll.shop_item and t0.item_id = roll.item_id
    -- where vip_expire_time = '' or vip_expire_time is null
)
select
	dt,
	order_id,
	core,
	mt,
	current_language2,
	country,
	user_id,
	shop_item,
	item_id,
	vip_type,
	sub_pay_type,
	charge_type,
	price,
	first_price,
	first_validity,
	after_charge,
	vip_expire_time,
	subscribe_status,
	autoRenew_times,
	product_id,
	auto_id,
	item_count,
	cancel_subscription_date,
	GREATEST(DATEDIFF(LEAST(date(date_sub(vip_expire_time,interval 1 day)), LAST_DAY(dt)), dt) + 1, 0) AS m0,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 2 month)))), date_trunc('month',date_add(dt,interval 1 month))) , 0) AS m1,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 3 month)))), date_trunc('month',date_add(dt,interval 2 month))) , 0) AS m2,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 4 month)))), date_trunc('month',date_add(dt,interval 3 month))) , 0) AS m3,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 5 month)))), date_trunc('month',date_add(dt,interval 4 month))) , 0) AS m4,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 6 month)))), date_trunc('month',date_add(dt,interval 5 month))) , 0) AS m5,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 7 month)))), date_trunc('month',date_add(dt,interval 6 month))) , 0) AS m6,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 8 month)))), date_trunc('month',date_add(dt,interval 7 month))) , 0) AS m7,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 9 month)))), date_trunc('month',date_add(dt,interval 8 month))) , 0) AS m8,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 10 month)))), date_trunc('month',date_add(dt,interval 9 month))) , 0) AS m9,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 11 month)))), date_trunc('month',date_add(dt,interval 10 month))) , 0) AS m10,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 12 month)))), date_trunc('month',date_add(dt,interval 11 month))) , 0) AS m11,
	GREATEST(DATEDIFF(LEAST(date(vip_expire_time), date(date_trunc('month',date_add(dt,interval 13 month)))), date_trunc('month',date_add(dt,interval 12 month))) , 0) AS m12,
	now() as etl_time
from (
	select t1.dt,t1.order_id,t3.core,t3.mt,t3.current_language2,t3.country,t1.user_id,t1.shop_item,t1.item_id,
	if(t1.item_type='天卡' and t4.subscription_days>0,concat(SUBSTRING_INDEX(subscription_days,'.',1),'天卡'),coalesce(t1.item_type,t2.vip_type,'周卡')) as vip_type,
	t1.sub_pay_type,t2.charge_type,
	t2.price,t2.first_price,t2.first_validity,t1.after_charge,
	case 	when t1.vip_expire_time is not null then  t1.vip_expire_time
			when t1.vip_expire_time is null and subscription_days is not null then date_add(t1.CreateTime, interval subscription_days day)
			when t1.vip_expire_time is null and subscription_days is null and  t1.item_type ='月卡' then date_add(t1.CreateTime, interval 1 month) -- 1, '月卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='季卡' then date_add(t1.CreateTime, interval 3 month) -- 2,'季卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='年卡' then date_add(t1.CreateTime, interval 1 year) -- 3,'年卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='周卡' then date_add(t1.CreateTime, interval 7 day) -- 4,'周卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='天卡' then date_add(t1.CreateTime, interval validity day) -- 5,'天卡'
		  end
	 as vip_expire_time
	,if(subscribe_cnt =0, 1, 2) as subscribe_status,subscribe_cnt as autoRenew_times, t1.product_id, auto_id,item_count,null as cancel_subscription_date, now() as etl_time
	from t1
	left join (
		select * from (
		select  item_id ,
		        validity - 100 as validity,
				case when validity=1 then '月卡'
					 when validity=3 then '季卡'
					 when validity=12 then '年卡'
					 when validity=107 then '周卡'
				     when validity - 100 > 0 then concat(validity - 100, '天卡')
					 else '非会员卡' end as vip_type,
				first_charge_type as charge_type,first_price,first_validity, price,
		  row_number() over(partition by item_id order by  validity desc ,price desc) rn
				from dim.dim_trade_pay_item_info_view
				where merchandise_type in  (800,810,830,840,850,860)
					and status=1 and is_delete=0
					and product_id <> 3399   -- 商品库表存在日语存在测试数据，单独清洗
		) a
		where rn=1
	) t2 on t1.item_id = t2.item_id
	-- -- 新增core、mt、current_language2、country字段
	left join (
		select product_id,id as user_id,corever as core ,mt,current_language2,reg_country as country
		from dim.dim_user_account_info_view
	) t3 on t1.product_id = t3.product_id and t1.user_id = t3.user_id
	--left join ads.ads_srsv_cancel_subscription_order_di_new t4 on t1.order_id = t4.order_id
	left join  (
		select dt,app_product_id as product_id,identity_login_id as user_id,recharge_type,cast(real_recharge as decimal(10,2)) as real_recharge,SUBSTRING_INDEX(subscription_days,'.',1) as subscription_days
		from ads.ads_sensors_production_ordersuccess_view
		where dt>='${bf_1_dt}' and dt<='${dt}'
		and recharge_type>0
		group by 1,2,3,4,5,6
	) t4 on t1.dt=t4.dt and  t1.product_id=t4.product_id and t1.user_id=t4.user_id and t4.recharge_type = t1.shop_item and t4.real_recharge  = t1.item_count
	where t1.product_id <> 3399
	-- and t2.item_id  is not null

	union all

	select t1.dt,t1.order_id,t3.core,t3.mt,t3.current_language2,t3.country,t1.user_id,t1.shop_item,
	t1.item_id,
	if(t1.item_type='天卡' and t4.subscription_days>0,concat(SUBSTRING_INDEX(subscription_days,'.',1),'天卡'),coalesce(t1.item_type,t2.vip_type)) as vip_type,
	t1.sub_pay_type,t2.charge_type
	,t2.price,t2.first_price,t2.first_validity,t1.after_charge,
	case 	when t1.vip_expire_time is not null then t1.vip_expire_time
			when t1.vip_expire_time is null and subscription_days is not null then date_add(t1.CreateTime, interval subscription_days day)
			when t1.vip_expire_time is null and subscription_days is null and  t1.item_type ='月卡' then date_add(t1.CreateTime, interval 1 month) -- 1, '月卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='季卡' then date_add(t1.CreateTime, interval 3 month) -- 2,'季卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='年卡' then date_add(t1.CreateTime, interval 1 year) -- 3,'年卡'
			when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='周卡' then date_add(t1.CreateTime, interval 7 day) -- 4,'周卡'
	        when t1.vip_expire_time is null and subscription_days is null and t1.item_type ='天卡' then date_add(t1.CreateTime, interval validity day) -- 5,'天卡'
		  end
	 as vip_expire_time
	,if(subscribe_cnt =0, 1, 2) as subscribe_status, subscribe_cnt as autoRenew_times, t1.product_id, auto_id,item_count ,null as cancel_subscription_date, now() as etl_time
	from t1
	left join (
		select * from (
		select  item_id ,
		        validity - 100 as validity,
				case when validity=1 then '月卡'
					 when validity=3 then '季卡'
					 when validity=12 then '年卡'
					 when validity=107 then '周卡'
				     when validity - 100 > 0 then concat(validity - 100, '天卡')
					 else '非会员卡' end as vip_type,
				first_charge_type as charge_type,first_price,first_validity, price,
		  row_number() over(partition by item_id order by  validity desc ,price desc) rn
				from dim.dim_trade_pay_item_info_view
				where merchandise_type in  (800,810,830,840,850,860)
					and status=1 and is_delete=0
					and product_id <> 3399   -- 商品库表存在日语存在测试数据，单独清洗
		) a
		where rn=1
	) t2 on t1.item_id = t2.item_id
	-- -- 新增core、mt、current_language2、country字段
	left join (
		select product_id,id as user_id,corever as core ,mt,current_language2,reg_country as country
		from dim.dim_user_account_info_view
	) t3 on t1.product_id = t3.product_id and t1.user_id = t3.user_id
	-- left join ads.ads_srsv_cancel_subscription_order_di_new t4 on t1.order_id = t4.order_id
	left join  (
		select dt,app_product_id as product_id,identity_login_id as user_id,recharge_type,cast(real_recharge as decimal(10,2)) as real_recharge,SUBSTRING_INDEX(subscription_days,'.',1) as subscription_days
		from ads.ads_sensors_production_ordersuccess_view
		where dt>='${bf_1_dt}' and dt<='${dt}'
		and recharge_type>0
		group by 1,2,3,4,5,6
	) t4 on t1.dt=t4.dt and  t1.product_id=t4.product_id and t1.user_id=t4.user_id and t4.recharge_type = t1.shop_item and t4.real_recharge  = t1.item_count
	where t1.product_id = 3399
	-- and t2.item_id  is not null
) a
 ;

-- SQL语句
---=================更新t-1取消订阅订单日期===================================
 insert into ads.ads_bi_trade_user_subscribe_di
select
	b.dt,
	b.order_id,
	b.core,
	b.mt,
	b.current_language2,
	b.country,
	b.user_id,
	b.shop_item,
	b.item_id,
	b.vip_type,
	b.sub_pay_type,
	b.charge_type,
	b.price,
	b.first_price,
	b.first_validity,
	b.after_charge,
	b.vip_expire_time,
	b.subscribe_status,
	b.autoRenew_times,
	b.product_id,
	b.auto_id,
	b.item_count,
	a.cancel_subscription_date,
	b.m0,
	b.m1,
	b.m2,
	b.m3,
	b.m4,
	b.m5,
	b.m6,
	b.m7,
	b.m8,
	b.m9,
	b.m10,
	b.m11,
	b.m12,
	now() as etl_time
from (
	select order_id,min(dt) as cancel_subscription_date
	from dwd.dwd_pay_order_notify
	group by order_id
) a
inner join ads.ads_bi_trade_user_subscribe_di b on a.order_id = b.order_id
where b.cancel_subscription_date is null
and dt='${bf_1_dt}'
;
