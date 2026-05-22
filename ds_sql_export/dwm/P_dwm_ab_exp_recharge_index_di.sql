----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_ab_exp_recharge_index_di
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : dwm_ab_exp_recharge_index_di
-- task_version     : 2
-- update_time      : 2025-03-09 23:56:18
-- sql_path         : \starrocks\tbl_dwm_ab_exp_recharge_index_di\dwm_ab_exp_recharge_index_di
----------------------------------------------------------------
-- SQL语句
insert into dwm.`dwm_ab_exp_recharge_index_di`
-- 曝光数据
-- INSERT INTO dwm.dwm_ab_exp_accumulation_stat_di
with user_exp_grp_ver as (
	select
		exp_id,exp_grp_id,exp_grp_ver_id,strategy_id,user_id,
		min(exp_start_time) as exp_start_time,
		max(exp_end_time) as exp_end_time,
		min(start_time) as start_time,
		max(end_time) as end_time,
		min(hit_time) as hit_time
	from dwm.dwm_ab_exp_strategy_hit_user_di
	group by 1,2,3,4,5
)
,
-- 充值数据与消费数据
t123 as(
	select t1.dt,t2.*
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
	inner join user_exp_grp_ver t2 on t1.user_id=t2.user_id and date(t2.exp_start_time)<=t1.dt and date(t2.exp_end_time)>=t1.dt
) -- select * from t123 where exp_id=20 and exp_grp_id=439410

,
-- 订单表数据
t2 as(
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
	from ads.ads_short_video_payorder_view
	where dt='${dt}'
		and test_flag=0
),
-- 充值档位曝光事件
t3 as(
	select
		case
			when element_id='200900' then '半屏'
			when page_id ='201300' then '商店页'
			when page_id ='203300' then 'H5'
			when element_id='202100' and element_type in('0','1') then '普通弹窗'
			when element_id='202100' and element_type in('3') then '充值返回推弹窗'
			else '其他' end recharge_source,
		event_strategy_id as  strategy_id,
		login_id user_id,
		event_tm,
		dt
	from ads.ads_sensors_cd_video_rechargeexposure_view
	where dt='${dt}'
		and  product_id = '6833'
	group by 1,2,3,4,5
) -- select * from t3
,
z1 as (
		select
			t3.dt ,t123.exp_id,t123.exp_grp_id,t123.exp_grp_ver_id,
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
			count(distinct t3.user_id) as  exposure_uv,
			count( t3.user_id) as  exposure_pv
		from t123
		left join t3
		on t123.user_id = t3.user_id and t123.strategy_id = t3.strategy_id and t3.event_tm >= t123.exp_start_time and t123.exp_end_time>=t3.event_tm
			and t3.event_tm >= t123.start_time and t123.end_time>=t3.event_tm and t123.hit_time<=t3.event_tm
		group by 1,2,3,4,5,6
)   -- select * from z1 where exp_id=20 and exp_grp_id=439410
,
-- 活跃关联充值
z2 as(
	select
	*
	FROM
		(
		select
			t2.dt ,t123.exp_id,t123.exp_grp_id,t123.exp_grp_ver_id,
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
			count(distinct t2.user_id) recharge_uv,
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
		left join t2
			on t123.user_id = t2.user_id and t123.strategy_id = t2.strategy_id and t123.dt = t2.dt and t2.create_time >= t123.exp_start_time and t123.exp_end_time>=t2.create_time
				and t2.create_time >= t123.start_time and t123.end_time>=t2.create_time and t123.hit_time<=t2.create_time
		group by 1,2,3,4,5,6
		) z2a
	where 1=1
)   -- select * from z2 where exp_id=20 and exp_grp_id=439410

select dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		ifnull(max(recharge_amount),0)  as recharge_amount,
		ifnull(max(recharge_amount_pre),0)  as recharge_amount_pre,
		ifnull(max(`normal_recharge_amount`),0)  as normal_recharge_amount,
		ifnull(max(`svip_recharge_amount`),0)  as svip_recharge_amount,
		ifnull(max(`signin_recharge_amount`),0)  as signin_recharge_amount,
		ifnull(max(recharge_uv),0)  as recharge_uv,
		ifnull(max(`normal_recharge_uv`),0)  as normal_recharge_uv,
		ifnull(max(`svip_recharge_uvt`),0)  as svip_recharge_uvt,
		ifnull(max(`signin_recharge_uv`),0)  as signin_recharge_uv,
		ifnull(max(recharge_times),0)  as recharge_times,
		ifnull(max(`normal_recharge_times`),0)  as normal_recharge_times,
		ifnull(max(`svip_recharge_times`),0)  as svip_recharge_times,
		ifnull(max(`signin_recharge_times`),0)  as signin_recharge_times,
		ifnull(max(exposure_pv),0)  as exposure_pv,
		ifnull(max(exposure_uv),0) as exposure_uv,
		now() as etl_tm
from (
	select
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		0  as recharge_amount,
		0  as recharge_amount_pre,
		0  as normal_recharge_amount,
		0 as svip_recharge_amount,
		0  as signin_recharge_amount,
		0 as recharge_uv,
		0 as normal_recharge_uv,
		0  as svip_recharge_uvt,
		0  as signin_recharge_uv,
		0  as recharge_times,
		0  as normal_recharge_times,
		0  as svip_recharge_times,
		0  as signin_recharge_times,
		ifnull(sum(exposure_pv),0)  as exposure_pv,
		ifnull(sum(exposure_uv),0) as exposure_uv
	from z1
	where dt is not null
	group by 1,2,3,4

	union all
	select
		dt,
		exp_id,
		exp_grp_id,
		exp_grp_ver_id,
		ifnull(sum(recharge_amount),0)  as recharge_amount,
		ifnull(sum(recharge_amount_pre),0)  as recharge_amount_pre,
		ifnull(sum(`normal_recharge_amount`),0)  as normal_recharge_amount,
		ifnull(sum(`svip_recharge_amount`),0)  as svip_recharge_amount,
		ifnull(sum(`signin_recharge_amount`),0)  as signin_recharge_amount,
		ifnull(sum(recharge_uv),0)  as recharge_uv,
		ifnull(sum(`normal_recharge_uv`),0)  as normal_recharge_uv,
		ifnull(sum(`svip_recharge_uvt`),0)  as svip_recharge_uvt,
		ifnull(sum(`signin_recharge_uv`),0)  as signin_recharge_uv,
		ifnull(sum(recharge_times),0)  as recharge_times,
		ifnull(sum(`normal_recharge_times`),0)  as normal_recharge_times,
		ifnull(sum(`svip_recharge_times`),0)  as svip_recharge_times,
		ifnull(sum(`signin_recharge_times`),0)  as signin_recharge_times,
		0  as exposure_pv,
		0 as exposure_uv
	from z2
	where dt is not null
	group by 1,2,3,4
) a
group by 1,2,3,4;
