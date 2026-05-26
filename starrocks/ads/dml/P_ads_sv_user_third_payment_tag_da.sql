----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_third_payment_tag_da
-- workflow_version : 17
-- create_user      : hufengju
-- task_name        : ads_sv_user_third_payment_tag_da
-- task_version     : 10
-- update_time      : 2024-12-24 15:42:30
-- sql_path         : \starrocks\tbl_ads_sv_user_third_payment_tag_da\ads_sv_user_third_payment_tag_da
----------------------------------------------------------------
-- SQL语句
-- ============调度：海剧人群包三方支付相关标签==============================
insert into ads.`ads_sv_user_third_payment_tag_da`
with user_order as (
	select dt,product_id,user_id,payment_code,history_payment,sum(order_num) as order_num
	from(
		select
			'${dt}' as  dt,product_id,user_id,payment_code,history_payment,order_num
		from dws.`dws_sv_user_third_payment_info_history_da`
		where dt='${bf_1_dt}'

		union all

		select dt,product_id,user_id,right(system_type,2) as payment_code,subpay_type as history_payment,count(1) as order_num
		from dwd.dwd_trade_short_video_payorder_view
		where dt='${dt}'
		and status=0 and test_flag=0
		group by 1,2,3,4,5
	) a
	group by 1,2,3,4,5
)
select a.dt,a.product_id,a.user_id,a.history_payment,a.third_payment_order,a.third_payment_proportion,now() as etl_tm
from (
	select
		'${dt}' as dt,
		product_id,
		user_id ,
		group_concat(payment_code order by payment_code) as history_payment,
		sum(if(b.channel_id is not null,order_num,0)) as third_payment_order,
		round(sum(if(b.channel_id is not null,order_num,0))/sum(order_num)*100,0) as third_payment_proportion
	from user_order a
	left join (
		select distinct channel_id
		from ods.ods_tidb_short_video_third_payment_rate
	) b on a.payment_code = b.channel_id
	group by 1,2,3
) a
left join
	(
		select  dt,product_id,user_id,history_payment,third_payment_order,third_payment_proportion
		from ads.`ads_sv_user_third_payment_tag_da`
		where dt='${bf_1_dt}'
	) b on  a.product_id and b.product_id and a.user_id = b.user_id
where (b.user_id is null or  a.history_payment<>b.history_payment or a.third_payment_order>b.third_payment_order or a.third_payment_proportion>b.third_payment_proportion)
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_third_payment_tag_da_yesterday
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : ads_sv_user_third_payment_tag_yesterday
-- task_version     : 3
-- update_time      : 2024-12-24 15:11:50
-- sql_path         : \starrocks\tbl_ads_sv_user_third_payment_tag_da_yesterday\ads_sv_user_third_payment_tag_yesterday
----------------------------------------------------------------
-- SQL语句
-- ============t-1全量清洗调度：海剧人群包三方支付相关标签==============================
insert into ads.`ads_sv_user_third_payment_tag_da`
with user_order as (
			select
			 dt,product_id,user_id,payment_code,history_payment,order_num
		from dws.`dws_sv_user_third_payment_info_history_da`
		where dt='${bf_1_dt}'
)
select a.dt,a.product_id,a.user_id,a.history_payment,a.third_payment_order,a.third_payment_proportion,now() as etl_tm
from (
	select
		dt,
		product_id,
		user_id ,
		group_concat(payment_code order by payment_code) as history_payment,
		sum(if(b.channel_id is not null,order_num,0)) as third_payment_order,
		round(sum(if(b.channel_id is not null,order_num,0))/sum(order_num)*100,0) as third_payment_proportion
	from user_order a
	left join (
		select distinct channel_id
		from ods.ods_tidb_short_video_third_payment_rate
	) b on a.payment_code = b.channel_id
	group by 1,2,3
) a
;
