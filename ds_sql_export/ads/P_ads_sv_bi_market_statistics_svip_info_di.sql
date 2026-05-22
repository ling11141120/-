----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_market_statistics_svip_info_di
-- workflow_version : 13
-- create_user      : hufengju
-- task_name        : ads_sv_bi_market_statistics_svip_info_di
-- task_version     : 8
-- update_time      : 2025-02-05 16:01:05
-- sql_path         : \starrocks\tbl_ads_sv_bi_market_statistics_svip_info_di\ads_sv_bi_market_statistics_svip_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_bi_market_statistics_svip_info_di where dt>='2025-01-01';

-- SQL语句
--=====svip（非繁体）========
 insert into ads.`ads_sv_bi_market_statistics_svip_info_di`
with  t1 as(
	select *from
	(
		select
			case
			when dic_product.remarks ='海外短剧' and corever=1 then 'MoboReels'
			when dic_product.remarks ='海外短剧' and corever=2 then 'MoboShort'
			when dic_product.remarks ='俄语' and corever=1  then 'Litrad'
			when dic_product.remarks ='俄语' and corever=2  then 'Chitets'
			when dic_product.remarks ='俄语' and corever=3  then 'Knigorad'
			when dic_product.remarks ='西语' and corever=1 then 'Manobook'
			when dic_product.remarks ='西语' and corever=2 then 'Novella'
			when dic_product.remarks ='西语' and corever=3 then 'Leera'
			when dic_product.remarks ='葡语' and corever=1 then 'Lera'
			when dic_product.remarks ='葡语' and corever=2 then 'Amolivro'
			when dic_product.remarks ='葡语' and corever=3 then 'Lelivro'
			when dic_product.remarks ='印尼语' and corever=1 then 'Bakisah'
			when dic_product.remarks ='印尼语' and corever=2 then 'Ceriaca'
			when dic_product.remarks ='印尼语' and corever=3 then 'Pobaca'
			when dic_product.remarks ='法语' and corever=1 then 'Kiffire'
			when dic_product.remarks ='法语' and corever=2 then 'Onlit'
			when dic_product.remarks ='法语' and corever=3 then 'Mobilis'
			when dic_product.remarks ='英语' and corever=1 then 'MoboReader'
			when dic_product.remarks ='英语' and corever=2 then 'Readnow'
			when dic_product.remarks ='英语' and corever=3 then 'WeRead'
			when dic_product.remarks ='泰语' and corever=2 then 'Romanread'
			when dic_product.remarks ='泰语' and corever=3 then 'Pinknovel'
			when dic_product.remarks ='繁体' and corever=1 then '暢讀書城'
			when dic_product.remarks ='繁体' and corever=2 then '暖暖小説'
			else '其他' end app_name,*
		from
			(
			select
				dt,
				t1.product_id,
				corever,
				case
				when mt in(1,7) then 'IOS'
				when mt =4 then '安卓'
				else '其他' end mt,
				t1.user_id ,
				create_time ,
				order_serial_id,
				amount  /100 amount,
				shop_item_id ,
				case when shop_item_id = 800 then '订阅-旧svip'
				when shop_item_id in (810,850) then '订阅-svip'
				when shop_item_id in (830,840) then '订阅-普通订阅'
				when shop_item_id =0 then '普通充值'
				else shop_item_id end shop_item_type
			from
				(
				select
				dt,
				product_id,
				user_id,
				order_serial_id,
				shop_item_id,
				create_time,
				core corever,
				mt,
				amount,
				sub_pay_type,
				coo_ext_status
				from ads.ads_report_trade_hkpayorder_detail_view
				where dt>='2025-01-01' and dt<'2025-02-01'
				and product_id not in (6883)
				and shop_item_id in (800,810,850)
				and sub_pay_type in ('GooglePlay','AppStore','AppGallery')
				and test_flag=0
				and order_status=1
				) t1
			) tt1
			left join
			dim.dim_dic dic_product  -- 产品名称
			on tt1.product_id = dic_product.enum_id
			where  dic_product.table_name = 'dwd_consume_user_consume_di'
			and dic_product.dic_column = 'product_id'
	) tt2
	where
		(app_name ='MoboReels' and mt ='IOS') or
		(app_name ='MoboShort' and mt ='安卓')  or
		(app_name ='Amolivro' and mt ='安卓') or
		(app_name ='Bakisah' and mt ='IOS') or
		(app_name ='Ceriaca' and mt ='安卓') or
		(app_name ='Chitets' and mt ='安卓') or
		(app_name ='Kiffire' and mt ='IOS') or
		(app_name ='Knigorad' and mt ='') or
		(app_name ='Leera' and mt ='安卓') or
		(app_name ='Lelivro' and mt ='安卓') or
		(app_name ='Lera' and mt ='IOS') or
		(app_name ='Litrad' and mt ='IOS') or
		(app_name ='Manobook' and mt ='IOS') or
		(app_name ='Mobilis' and mt ='安卓') or
		(app_name ='MoboReader' and mt ='IOS') or
		(app_name ='Novella' and mt ='安卓') or
		(app_name ='Onlit' and mt ='安卓') or
		(app_name ='Pinknovel' and mt ='安卓') or
		(app_name ='Pobaca' and mt ='安卓') or
		(app_name ='Readnow' and mt ='安卓') or
		(app_name ='Romanread' and mt ='安卓') or
		(app_name ='WeRead' and mt ='安卓') or
		(app_name ='アイドク' and mt ='安卓') or
		(app_name ='暖暖小説' and mt ='安卓')
),

t2 as
(
	-- 海剧订单
	SELECT
		order_id,
		case
		when vip_expire_time ='' and replace(replace(replace(extinfo,'com.changdu.mobovideo',''),'|.','') ,'|','')
		in ('checkin26_1m','iap.tipcard3026' ,'iap.tipcard3050','iap.tipcard308050','vip_yue_50' )
		then substring(date_add(dt, INTERVAL 1 MONTH),1,10)
		when vip_expire_time ='' and replace(replace(replace(extinfo,'com.changdu.mobovideo',''),'|.','') ,'|','')
		in ('checkin15_1w','iap.tipcard0715','iap.tipcard71050','iap.tipcard72050','iap.tipcard73050','iap.tipcard74050','vip_zhou_10_50','vip_zhou_20_50','vip_zhou_30_50','vip_zhou_40_50')
		then  substring(date_add(dt, INTERVAL 7 DAY),1,10)
		when vip_expire_time is null or vip_expire_time ='' and item_count<50 then  substring(date_add(dt, INTERVAL 7 DAY),1,10)      --没有过期日期的数据处理
		when vip_expire_time is null or vip_expire_time ='' and item_count>=50 then  substring(date_add(dt, INTERVAL 1 MONTH),1,10)   --没有过期日期的数据处理
		else substring(vip_expire_time,1,10)  end vip_expire_time1 --vip过期时间清洗
	from ads.ads_short_video_payorder_view
	where dt>='2025-01-01' and dt<'2025-02-01'
	and test_flag=0
	and shop_item in (800, 810,850)
	and subpay_type  in ('GooglePlay','AppStore','AppGallery')
	union all
	-- 海阅订单
	SELECT
		order_id
		,substring(vipexpire_time,1,10)  vip_expire_time1
	FROM ads.ads_trade_user_payorder_view
	where dt>='2025-01-01' and dt<'2025-02-01'
	AND shop_item in (800, 810,850)
	and subpay_type  in ('GooglePlay','AppStore','AppGallery')
	AND test_flag = 0
)
select
	t1.dt,t1.app_name,t1.mt,t1.order_serial_id as order_id,t1.amount,t1.user_id,t1.create_time,t1.shop_item_id,t1.shop_item_type,
	t2.vip_expire_time1,
	if(vip_expire_time1<=dt, 1, date_diff('day', vip_expire_time1, dt)) as  subscription_days,
	(amount) / if(vip_expire_time1<=dt, 1, date_diff('day', vip_expire_time1, dt))  per_value,
	null as month10_day,
	null as month10_value,
	null as month11_day,
	null as month11_value,
	null as month12_day,
	null as month12_value,
	now() as etl_tm
from t1
left join t2 on t1.order_serial_id=t2.order_id
;

-- SQL语句
--=====svip（繁体）========
insert into ads.`ads_sv_bi_market_statistics_svip_info_di`
with  t1 as(
	select *from
	(
		select
			case
			when dic_product.remarks ='海外短剧' and corever=1 then 'MoboReels'
			when dic_product.remarks ='海外短剧' and corever=2 then 'MoboShort'
			when dic_product.remarks ='俄语' and corever=1  then 'Litrad'
			when dic_product.remarks ='俄语' and corever=2  then 'Chitets'
			when dic_product.remarks ='俄语' and corever=3  then 'Knigorad'
			when dic_product.remarks ='西语' and corever=1 then 'Manobook'
			when dic_product.remarks ='西语' and corever=2 then 'Novella'
			when dic_product.remarks ='西语' and corever=3 then 'Leera'
			when dic_product.remarks ='葡语' and corever=1 then 'Lera'
			when dic_product.remarks ='葡语' and corever=2 then 'Amolivro'
			when dic_product.remarks ='葡语' and corever=3 then 'Lelivro'
			when dic_product.remarks ='印尼语' and corever=1 then 'Bakisah'
			when dic_product.remarks ='印尼语' and corever=2 then 'Ceriaca'
			when dic_product.remarks ='印尼语' and corever=3 then 'Pobaca'
			when dic_product.remarks ='法语' and corever=1 then 'Kiffire'
			when dic_product.remarks ='法语' and corever=2 then 'Onlit'
			when dic_product.remarks ='法语' and corever=3 then 'Mobilis'
			when dic_product.remarks ='英语' and corever=1 then 'MoboReader'
			when dic_product.remarks ='英语' and corever=2 then 'Readnow'
			when dic_product.remarks ='英语' and corever=3 then 'WeRead'
			when dic_product.remarks ='泰语' and corever=2 then 'Romanread'
			when dic_product.remarks ='泰语' and corever=3 then 'Pinknovel'
			when dic_product.remarks ='繁体' and corever=1 then '暢讀書城'
			when dic_product.remarks ='繁体' and corever=2 then '暖暖小説'
			else '其他' end app_name,*
		from
			(
			select
				dt,
				t1.product_id,
				corever,
				case
				when mt in(1,7) then 'IOS'
				when mt =4 then '安卓'
				else '其他' end mt,
				t1.user_id ,
				create_time ,
				order_serial_id,
				amount  /100 amount,
				shop_item_id ,
				case when shop_item_id in (810,850) then '订阅-svip'
				when shop_item_id in (800,830,840) then '订阅-普通订阅'
				when shop_item_id =0 then '普通充值'
				else shop_item_id end shop_item_type
			from
				(
				select
				dt,
				product_id,
				user_id,
				order_serial_id,
				shop_item_id,
				create_time,
				core corever,
				mt,
				amount,
				sub_pay_type,
				coo_ext_status
				from ads.ads_report_trade_hkpayorder_detail_view
				where dt>='2025-01-01' and dt<'2025-02-01'
				and product_id = 3333
				and shop_item_id in (810,850)
				and sub_pay_type in ('GooglePlay','AppStore','AppGallery')
				and test_flag=0
				and order_status=1
				) t1
			) tt1
			left join
			dim.dim_dic dic_product  -- 产品名称
			on tt1.product_id = dic_product.enum_id
			where  dic_product.table_name = 'dwd_consume_user_consume_di'
			and dic_product.dic_column = 'product_id'
	) tt2
	where
	(app_name ='暢讀書城' and mt ='IOS')
),

t2 as
(
	-- 海剧订单
	SELECT
		order_id,
		case
		when vip_expire_time ='' and replace(replace(replace(extinfo,'com.changdu.mobovideo',''),'|.','') ,'|','')
		in ('checkin26_1m','iap.tipcard3026' ,'iap.tipcard3050','iap.tipcard308050','vip_yue_50' )
		then substring(date_add(dt, INTERVAL 1 MONTH),1,10)
		when vip_expire_time ='' and replace(replace(replace(extinfo,'com.changdu.mobovideo',''),'|.','') ,'|','')
		in ('checkin15_1w','iap.tipcard0715','iap.tipcard71050','iap.tipcard72050','iap.tipcard73050','iap.tipcard74050','vip_zhou_10_50','vip_zhou_20_50','vip_zhou_30_50','vip_zhou_40_50')
		then  substring(date_add(dt, INTERVAL 7 DAY),1,10)
		when vip_expire_time is null or vip_expire_time ='' and item_count<50 then  substring(date_add(dt, INTERVAL 7 DAY),1,10)      --没有过期日期的数据处理
		when vip_expire_time is null or vip_expire_time ='' and item_count>=50 then  substring(date_add(dt, INTERVAL 1 MONTH),1,10)   --没有过期日期的数据处理
		else substring(vip_expire_time,1,10)  end vip_expire_time1 --vip过期时间清洗
	from ads.ads_short_video_payorder_view
	where dt>='2025-01-01' and dt<'2025-02-01'
	and test_flag=0
	and shop_item in (800, 810,850)
	and subpay_type  in ('GooglePlay','AppStore','AppGallery')
	union all
	-- 海阅订单
	SELECT
		order_id
		,substring(vipexpire_time,1,10)  vip_expire_time1
	FROM ads.ads_trade_user_payorder_view
	where dt>='2025-01-01' and dt<'2025-02-01'
	AND shop_item in (800, 810,850)
	and subpay_type  in ('GooglePlay','AppStore','AppGallery')
	AND test_flag = 0
)
select
	t1.dt,t1.app_name,t1.mt,t1.order_serial_id as order_id,t1.amount,t1.user_id,t1.create_time,t1.shop_item_id,t1.shop_item_type,
	t2.vip_expire_time1,
	if(vip_expire_time1<=dt, 1, date_diff('day', vip_expire_time1, dt)) as  subscription_days,
	(amount) / if(vip_expire_time1<=dt, 1, date_diff('day', vip_expire_time1, dt))  per_value,
	null as month10_day,
	null as month10_value,
	null as month11_day,
	null as month11_value,
	null as month12_day,
	null as month12_value,
	now() as etl_tm
from t1
left join t2 on t1.order_serial_id=t2.order_id
;
