----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_ab_exp_recharge_data_di
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : dwm_ab_exp_recharge_data_di
-- task_version     : 5
-- update_time      : 2025-05-07 15:49:47
-- sql_path         : \starrocks\tbl_dwm_ab_exp_recharge_data_di\dwm_ab_exp_recharge_data_di
----------------------------------------------------------------
-- SQL语句
insert into dwm.`dwm_ab_exp_recharge_data_di`
with
-- 充值数据与消费数据
t123 as(
	select t1.*
	from (
			select
				dt,
				user_id
			from dws.dws_user_short_video_wide_active_period_ed
			where dt='${dt}'
				and period_type= 'ctt'
				and product_id=6833
			group by 1,2
		) t1

) -- select * from t123 where exp_id=20 and exp_grp_id=439410

,
-- 订单表数据
t2 as(
	select a.* ,b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id
	from (
		select
			dt,create_time,user_id,
			case
				when item_count<10 then concat('00',cast(item_count as varchar))
				when item_count<100 then concat('0',cast(item_count as varchar))
				else cast(item_count as varchar) end item_count,
			base_amount/100 base_amount,shop_item,package_id,
			case
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='201300' then '商店页'
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='200900' then '半屏'
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='203300' then 'H5'
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1] is null then '半屏'
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='202100'
				and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2] in ('0','1') then '普通弹窗'
				when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='202100'
				and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2] in ('3') then '充值返回推弹窗'
				else '其他' end recharge_source,
			get_json_string(custom_data, '$.activityId')  activity_id,
			get_json_string(custom_data, '$.strategyId') strategy_id,
			get_json_string(cooorder_extinfo, '$.SubscribeStatus') SubscribeStatus,
			case when shop_item=0 then '普通充值'
				when shop_item=810 then 'SVIP'
				when shop_item=840 then '签到卡'
				else '其他' end shop_item_type
		from ads.ads_short_video_payorder_view a
		where dt='${dt}'
			and test_flag=0
		) a
		inner join ods.ods_ab_hj_related b  on a.strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.create_time >= c.exp_start_time and c.exp_end_time>a.create_time
			and a.create_time >= c.start_time and c.end_time>a.create_time
),
-- 充值档位曝光事件
t3 as(
	select
		case
			when element_id='200900' or page_id='200900' then '半屏'
			when page_id ='201300' then '商店页'
			when page_id ='203300' then 'H5'
			when element_id='202100' and element_type in('0','1') then '普通弹窗'
			when element_id='202100' and element_type in('3') then '充值返回推弹窗'
			else '其他' end recharge_source,
		event_strategy_id as  strategy_id,
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,
		login_id user_id,
		event_tm,
		dt
	from ads.ads_sensors_cd_video_rechargeexposure_view a
	inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
	inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	where dt='${dt}'
		and  product_id = '6833'
	group by 1,2,3,4,5,6,7,8
) -- select * from t3
,
-- 充值事件
t4 as (
	select a.dt,a.strategy_id,a.user_id,a.event_tm,
		b.ab_id as exp_id,b.version_id as exp_grp_id ,c.exp_grp_ver_id
	from (
		select dt,event_strategy_id as strategy_id,login_id as user_id, event_tm
		from ads.ads_sensors_cd_video_ordercreateaction_view
		where dt='${dt}'
	) a
	inner join ods.ods_ab_hj_related b  on a.strategy_id = b.strategy_id
	inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
)
,
z1 as (
		select
			t3.dt ,t3.exp_id,t3.exp_grp_id,t3.exp_grp_ver_id,
			case
				when t3.strategy_id is null then '续订(或策略id为空)'
				when t3.strategy_id in (
				21907679071567884,
				21412617518317655,
				21412110712176725,
				21411962535805011,
				59996164203217021,
				90064658960220161,
				72785256107606176) then '商店页'
				else recharge_source end recharge_source,
			case when t3.strategy_id is null then '续订(或策略id为空)'
				else t3.strategy_id end as strategy_id,
			t3.user_id,
			count( t3.user_id) as  exposure_pv
		from t123
		inner join t3 	on t123.user_id = t3.user_id
		group by 1,2,3,4,5,6,7
)     -- select count(1) from z1 where exp_id=42 and exp_grp_id=700025 -- strategy_id=117349256963293517
,
-- 活跃关联充值
z2 as(
	select
	*
	FROM
		(
		select
			t2.dt ,t2.exp_id,t2.exp_grp_id,t2.exp_grp_ver_id,
			case
				when t2.strategy_id is null then '续订(或策略id为空)'
				when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
				when t2.strategy_id in (
				21907679071567884,
				21412617518317655,
				21412110712176725,
				21411962535805011,
				59996164203217021,
				90064658960220161,
				72785256107606176) then '商店页'
				else recharge_source end recharge_source,
			case
				when t2.strategy_id is null then '续订(或策略id为空)'
				else t2.strategy_id end strategy_id,
			shop_item_type,
			item_count,
			t2.user_id,
			count(distinct t2.user_id) recharge_un,
			count(t2.user_id) recharge_times,
			sum(base_amount) recharge_amount,
			sum(item_count) recharge_amount_pre,
			sum(case when shop_item_type='普通充值' then base_amount end) `normal_recharge_amount`,
			sum(case when shop_item_type='签到卡' then base_amount end) `signin_recharge_amount`,
			sum(case when shop_item_type='SVIP' then base_amount end) `svip_recharge_amount`,
			count(case when shop_item_type='普通充值' then t2.user_id end) `normal_recharge_times`,
			count(case when shop_item_type='签到卡' then t2.user_id end) `signin_recharge_times`,
			count(case when shop_item_type='SVIP' then t2.user_id end) `svip_recharge_times`,
			count(distinct case when shop_item_type='普通充值' then t2.user_id end) `normal_recharge_uv`,
			count(distinct case when shop_item_type='签到卡' then t2.user_id end) `signin_recharge_uv`,
			count(distinct case when shop_item_type='SVIP' then t2.user_id end) `svip_recharge_uvt`
		from t123
		inner join t2
			on t123.user_id = t2.user_id
		group by 1,2,3,4,5,6,7,8,9
		) z2a
	where 1=1
)    -- select * from z2 where   strategy_id=117349256963293517
,
z3 as (
		select
			t4.dt ,t4.exp_id,t4.exp_grp_id,t4.exp_grp_ver_id,
			case when t4.strategy_id is null then '续订(或策略id为空)'
				else t4.strategy_id end as strategy_id,
			t4.user_id
		from t123
		inner join t4 	on t123.user_id = t4.user_id
		group by 1,2,3,4,5,6
)     -- select count(1) from z3 where exp_id=42 and exp_grp_id=700025 -- strategy_id=117349256963293517

select dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		user_id,
		ifnull(sum(recharge_un),0)  as recharge_un,
		ifnull(sum(recharge_amount),0)  as recharge_amount,
		ifnull(sum(recharge_amount_pre),0)  as recharge_amount_pre,
		ifnull(sum(`normal_recharge_amount`),0)  as normal_recharge_amount,
		ifnull(sum(`svip_recharge_amount`),0)  as svip_recharge_amount,
		ifnull(sum(`signin_recharge_amount`),0)  as signin_recharge_amount,
		ifnull(sum(`normal_recharge_uv`),0)  as normal_recharge_uv,
		ifnull(sum(`svip_recharge_uvt`),0)  as svip_recharge_uvt,
		ifnull(sum(`signin_recharge_uv`),0)  as signin_recharge_uv,
		ifnull(sum(recharge_times),0)  as recharge_times,
		ifnull(sum(`normal_recharge_times`),0)  as normal_recharge_times,
		ifnull(sum(`svip_recharge_times`),0)  as svip_recharge_times,
		ifnull(sum(`signin_recharge_times`),0)  as signin_recharge_times,
		ifnull(sum(exposure_pv),0)  as exposure_pv,
		ifnull(sum(create_order_user),0)  as exposure_pv,
		now() as etl_tm
from (
	select
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		user_id,
		0 as recharge_un,
		0  as recharge_amount,
		0  as recharge_amount_pre,
		0  as normal_recharge_amount,
		0 as svip_recharge_amount,
		0  as signin_recharge_amount,
		0 as normal_recharge_uv,
		0  as svip_recharge_uvt,
		0  as signin_recharge_uv,
		0  as recharge_times,
		0  as normal_recharge_times,
		0  as svip_recharge_times,
		0  as signin_recharge_times,
		ifnull((exposure_pv),0)  as exposure_pv,
		0 as create_order_user
	from z1

	union all
	select
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		user_id,
		ifnull((recharge_un),0)  as recharge_un,
		ifnull((recharge_amount),0)  as recharge_amount,
		ifnull((recharge_amount_pre),0)  as recharge_amount_pre,
		ifnull((`normal_recharge_amount`),0)  as normal_recharge_amount,
		ifnull((`svip_recharge_amount`),0)  as svip_recharge_amount,
		ifnull((`signin_recharge_amount`),0)  as signin_recharge_amount,
		ifnull((`normal_recharge_uv`),0)  as normal_recharge_uv,
		ifnull((`svip_recharge_uvt`),0)  as svip_recharge_uvt,
		ifnull((`signin_recharge_uv`),0)  as signin_recharge_uv,
		ifnull((recharge_times),0)  as recharge_times,
		ifnull((`normal_recharge_times`),0)  as normal_recharge_times,
		ifnull((`svip_recharge_times`),0)  as svip_recharge_times,
		ifnull((`signin_recharge_times`),0)  as signin_recharge_times,
		0  as exposure_pv,
		0 as create_order_user
	from z2

	union all
	select
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		user_id,
		0 as recharge_un,
		0  as recharge_amount,
		0  as recharge_amount_pre,
		0  as normal_recharge_amount,
		0 as svip_recharge_amount,
		0  as signin_recharge_amount,
		0 as normal_recharge_uv,
		0  as svip_recharge_uvt,
		0  as signin_recharge_uv,
		0  as recharge_times,
		0  as normal_recharge_times,
		0  as svip_recharge_times,
		0  as signin_recharge_times,
		0  as exposure_pv,
		1 as create_order_user
	from z3

) a
-- where exp_id=42 and exp_grp_id=700025
group by 1,2,3,4,5;
