----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_market_statistics_order_info_di
-- workflow_version : 12
-- create_user      : hufengju
-- task_name        : ads_sv_bi_market_statistics_order_info_di
-- task_version     : 4
-- update_time      : 2025-01-24 16:44:39
-- sql_path         : \starrocks\tbl_ads_sv_bi_market_statistics_order_info_di\ads_sv_bi_market_statistics_order_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_bi_market_statistics_order_info_di where dt>='2025-01-01';

-- SQL语句
--=====充值明细(排除繁体)========
insert into ads.`ads_sv_bi_market_statistics_order_info_di`
with t1 as(
	select *
	from
	(
		select
			dt ,
			order_id,
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
			else '其他' end app_name,
			`mt`,
			`user_id`,
			`create_time`,
			`amount`,
			`sub_pay_type`,
			`shop_item`,
			`is_refund`,
			now() as etl_tm
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
					t1.user_id as user_id,
					order_serial_id as order_id,
					create_time as create_time,
					amount  /100 as amount,
					sub_pay_type as sub_pay_type,
					case
					when shop_item_id =0 then '普通充值'
					when shop_item_id IN (800,810,850) then 'svip'
					when shop_item_id IN (830,840) then '订阅'
					else shop_item_id end `shop_item`,
					case
					when coo_ext_status=-1 then '退款'
					else '非退款'  end `is_refund`
				from
					(
						select
							dt,
							product_id,
							user_id,
							shop_item_id,
							order_serial_id,
							create_time,
							core corever,
							mt,
							amount,
							sub_pay_type,
							coo_ext_status
						from ads.ads_report_trade_hkpayorder_detail_view
						where dt>='2025-01-01' and dt<'2025-02-01'
						and product_id not in (6883) --and product_id<>3333
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
)

select *
from t1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_market_statistics_order_info_di
-- workflow_version : 12
-- create_user      : hufengju
-- task_name        : ads_sv_bi_market_statistics_order_info_di_3333
-- task_version     : 4
-- update_time      : 2025-01-24 16:44:39
-- sql_path         : \starrocks\tbl_ads_sv_bi_market_statistics_order_info_di\ads_sv_bi_market_statistics_order_info_di_3333
----------------------------------------------------------------
-- SQL语句
--=====充值明细（繁体）========
insert into ads.`ads_sv_bi_market_statistics_order_info_di`
with t1 as(
select *from
(
	select
		dt ,
		order_id,
		case
		when dic_product.remarks ='繁体' and corever=1 then '暢讀書城'
		else '其他' end app_name,
		`mt`,
		`user_id`,
		`create_time`,
		`amount`,
		`sub_pay_type`,
		`shop_item`,
		`is_refund`,
		now() as etl_tm
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
				t1.user_id as user_id,
				order_serial_id as order_id,
				create_time,
				amount  /100 as amount,
				sub_pay_type,
				case
				when shop_item_id =0 then '普通充值'
				when shop_item_id IN (810,850) then 'svip'
				when shop_item_id IN (800,830,840) then '订阅'
				else shop_item_id end as shop_item,
				case
				when coo_ext_status=-1 then '退款'
				else '非退款'  end as  is_refund
			from
				(
					select
						dt,
						product_id,
						user_id,
						shop_item_id,
						order_serial_id,
						create_time,
						core corever,
						mt,
						amount,
						sub_pay_type,
						coo_ext_status
					from ads.ads_report_trade_hkpayorder_detail_view
					where dt>='2025-01-01' and dt<'2025-02-01'
					and product_id =3333
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

)
select *
from t1;
