----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_bi_market_statistics_consume_info_di
-- workflow_version : 12
-- create_user      : hufengju
-- task_name        : ads_sv_bi_market_statistics_consume_info_di
-- task_version     : 9
-- update_time      : 2025-02-05 17:23:02
-- sql_path         : \starrocks\tbl_ads_sv_bi_market_statistics_consume_info_di\ads_sv_bi_market_statistics_consume_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_bi_market_statistics_consume_info_di where dt>='2025-01-01';

-- SQL语句
--=====消费明细(排除繁体)========
insert into ads.`ads_sv_bi_market_statistics_consume_info_di`
with r1 as
(
	select
	*,
	sum(amount) over(partition by app_name,mt,user_id order by create_time,row_1) total_consume_amt
	from(
	select
	*,
	concat(create_time,amount) row_1
	from
		(
		-- 海剧观看币消耗
		select
			case
			when corever=1 then 'MoboReels'
			when corever = 2 then 'MoboShort'
			else '其他' end app_name,
			case
			when mt in(1,7) then 'IOS'
			when mt =4 then '安卓'
			else '其他' end mt,
			a.consume_value amount,
			a.account_id user_id,
			a.create_time
			from ads.ads_consume_short_video_consume_view a
		left join dim.dim_short_video_user_accountinfo c on a.account_id=c.user_id
		where  a.dt>='2025-01-01' and a.dt<'2025-02-01'
		and consume_type=0
		and ((corever=1 and  mt in(1,7)) or (corever=2 and  mt =4) )
		union all
		-- 海阅阅币消耗
		select
		*
		from
			(
			select
				case
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
				case
				when mt in(1,7) then 'IOS'
				when mt =4 then '安卓'
				else '其他' end mt,
				amount,
				user_id,
				create_time
			from
				(
					select
						a.product_id,
						a.mt,
						b.corever,
						a.amount,
						user_id,
						createtime create_time
					from ads.ads_consume_user_consume_view a
					left join dim.dim_user_account_info_view b
					on a.user_id=b.id and a.product_id=b.product_id
					where
						a.dt>='2025-01-01' and a.dt<'2025-02-01'
						and a.product_id<>3333
						and a.pay_type<>1103
						and a.types=1
				) tt1
			left join
			dim.dim_dic dic_product  -- 产品名称
			on tt1.product_id = dic_product.enum_id
			where  dic_product.table_name = 'dwd_consume_user_consume_di'
			and dic_product.dic_column = 'product_id'
		) a2
		where
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
		) a3
	) a4
),
r2 as(
	-- 海剧三方充值（普通充值+福利包）
	select
		app_name,
		mt,
		user_id,
		sum(amount) recharge_amt
	from
		(
		select
			case
			when core=1 then 'MoboReels'
			when core = 2 then 'MoboShort'
			else '其他' end app_name,
			case
			when mt in(1,7) then 'IOS'
			when mt =4 then '安卓'
			else '其他' end mt,
			user_id ,
			amount
		from ads.ads_report_trade_hkpayorder_detail_view
		where dt>='2025-01-01' and dt<'2025-02-01'
		and product_id=6833
		and test_flag=0
		and order_status=1
		and sub_pay_type not in ('GooglePlay','AppStore','AppGallery')
		and coo_ext_status !=-1
		and ((core=1 and  mt in(1,7)) or (core=2 and  mt =4) )
		and shop_item_id in (0,830,840)
		) t2
	group by 1,2,3
	union all
	-- 海阅三方充值（普通充值+福利包）
	select
		app_name,
		mt,
		user_id,
		sum(amount) recharge_amt
	from
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
			else '其他' end app_name,
			case
			when mt in(1,7) then 'IOS'
			when mt =4 then '安卓'
			else '其他' end mt,
			user_id,
			amount
		from(
			select
				t1.product_id,
				corever,
				if(t1.mt = 0 ,t2.mt, t1.mt) mt,
				t1.user_id,
				t1.amount
			from
				(
					select
						product_id,
						user_id,
						core corever,
						mt,
						amount,
						sub_pay_type,
						coo_ext_status
					from ads.ads_report_trade_hkpayorder_detail_view
					where dt>='2025-01-01' and dt<'2025-02-01'
					and product_id not in (6833,6883,3333)
					and test_flag=0
					and order_status=1
					and sub_pay_type not in ('GooglePlay','AppStore','AppGallery')
					and coo_ext_status !=-1
					and shop_item_id in (0,830,840)
				) t1
			left join
				(
					select
					  product_id,
					  id user_id,
					  mt
					  from dim.dim_user_account_info_view
					  group by 1,2,3
				) t2
				on t1.user_id=t2.user_id and t1.product_id=t2.product_id
		) tt1
		left join
		dim.dim_dic dic_product  -- 产品名称
		on tt1.product_id = dic_product.enum_id
		where  dic_product.table_name = 'dwd_consume_user_consume_di'
		and dic_product.dic_column = 'product_id'
		) a2
	where
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
	group by 1,2,3
),
-- 数据处理
r3 as(
	select
	*,
	if(row_2=1 and recharge_amt!=0,amount-(total_consume_amt-recharge_amt),amount) amount1,
	row_number() over(order by create_time) row_3
	from(
		select
		*,
		row_number() over(partition by app_name,user_id order by row_1) row_2
		from(
			select
			r1.*,
			ifnull(r2.recharge_amt,0) recharge_amt
			from r1
			left join r2
			on r1.app_name = r2.app_name and r1.user_id = r2.user_id
		) a1
		where total_consume_amt>recharge_amt
	) a2
)

select date(create_time) as dt,*,now() as etl_tm
from r3;

-- SQL语句
--=====消费明细（繁体）========
insert into ads.`ads_sv_bi_market_statistics_consume_info_di`
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
					where dt>='2024-10-01' and dt<'2025-02-01'
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

),
 r1 as
(
select
*,
sum(amount) over(partition by app_name,mt,user_id order by create_time,row_1) total_consume_amt
from(
select
*,
concat(create_time,amount) row_1
from
	(
	select
	*
	from
	(
	select
		case
		when dic_product.remarks ='繁体' and corever=1 then '暢讀書城'
		else '其他' end app_name,
		case
		when mt in(1,7) then 'IOS'
		when mt =4 then '安卓'
		else '其他' end mt,
		amount,
		user_id,
		create_time
	from
		(
		select
			a.product_id,
			a.mt,
			b.corever,
			a.amount,
			user_id,
			createtime create_time
		from ads.ads_consume_user_consume_view a
		left join dim.dim_user_account_info_view b
		on a.user_id=b.id and a.product_id=b.product_id
		where
			a.dt>='2025-01-01' and a.dt<'2025-02-01'
			and  a.product_id=3333
			and a.pay_type<>1103
			and a.types=1
		) tt1
	left join
	dim.dim_dic dic_product  -- 产品名称
	on tt1.product_id = dic_product.enum_id
	where  dic_product.table_name = 'dwd_consume_user_consume_di'
	and dic_product.dic_column = 'product_id'
	) a2
	where
	(app_name ='暢讀書城' and mt ='IOS')
	) a3
) a4
),

r2 as(
-- 海阅三方充值（普通充值+福利包）
select
	app_name,
	mt,
	user_id,
	sum(amount) recharge_amt
from
(
select
	case
	when dic_product.remarks ='繁体' and corever=1 then '暢讀書城'
	else '其他' end app_name,
	case
	when mt in(1,7) then 'IOS'
	when mt =4 then '安卓'
	else '其他' end mt,
	user_id,
	amount
from(
select
	t1.product_id,
	corever,
	if(t1.mt = 0 ,t2.mt, t1.mt) mt,
	t1.user_id,
	t1.amount
from
	(
	select
	product_id,
	user_id,
	core corever,
	mt,
	amount,
	sub_pay_type,
	coo_ext_status
	from ads.ads_report_trade_hkpayorder_detail_view
	where dt>='2025-01-01' and dt<'2025-02-01'
	and product_id =3333
	and test_flag=0
	and order_status=1
	and sub_pay_type not in ('GooglePlay','AppStore','AppGallery')
	and coo_ext_status !=-1
	and shop_item_id in (0,800,830,840)
	) t1
left join
	(
	select
	  product_id,
	  id user_id,
	  mt
	  from dim.dim_user_account_info_view
	  group by 1,2,3
	) t2
	on t1.user_id=t2.user_id and t1.product_id=t2.product_id

) tt1
left join
dim.dim_dic dic_product  -- 产品名称
on tt1.product_id = dic_product.enum_id
where  dic_product.table_name = 'dwd_consume_user_consume_di'
and dic_product.dic_column = 'product_id'
) a2
where
(app_name ='暢讀書城' and mt ='IOS')
group by 1,2,3

),

-- 数据处理
r3 as(
	select
	*,
	if(row_2=1 and recharge_amt!=0,amount-(total_consume_amt-recharge_amt),amount) amount1,
	row_number() over(order by create_time) row_3
		from(
		select
		*,
		row_number() over(partition by app_name,user_id order by row_1) row_2
		from(
			select
			r1.*,
			ifnull(r2.recharge_amt,0) recharge_amt
			from r1
			left join r2
			on r1.app_name = r2.app_name and r1.user_id = r2.user_id
		) a1
		where total_consume_amt>recharge_amt
	) a2
)

select date(r3.create_time) as dt,r3.*,now() as etl_tm
from r3
left join
(select distinct user_id from t1) r32
on r3.user_id = r32.user_id
where r32.user_id is not null   -- 暢讀書城 消耗明细，只有10月需要剔除没充值用户，11和12月不需要剔除
;

-- SQL语句
;
