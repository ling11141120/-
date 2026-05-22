----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_third_party_payment_funnel
-- workflow_version : 35
-- create_user      : chenmo
-- task_name        : ads_sv_third_party_payment_funnel
-- task_version     : 7
-- update_time      : 2025-07-05 17:01:31
-- sql_path         : \starrocks\tbl_ads_sv_third_party_payment_funnel\ads_sv_third_party_payment_funnel
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_third_party_payment_funnel
-- 活跃表
with active as (
    select
        a.dt,
        a.user_id,
        a.period_type,
        a.user_type,
        a.current_language2,
        b.remarks as current_language2_name,
        case
            when a.country_level = 1 then 'T1'
            when a.country_level = 2 then 'T2'
            else '其他'
        end as country_level,
        a.mt,
        c.enum_name as mt_name,
        coalesce(a.corever, '其他') as corever
    from (
        select
            dt, user_id, period_type, user_type, current_language2, country_level, mt, corever
        from dws.dws_user_short_video_wide_active_period_ed
        where product_id = 6833 and dt >= '${bf_1_dt}' and dt <= '${dt}'
    ) a
    left join (
         -- 注册/投放语言
        select
            enum_id, remarks
        from dim.dim_dic
        where table_name = 'dim_producttype' and dic_column = 'language_id'
    ) b
    on a.current_language2 = b.enum_id
    left join (
         -- mt
        select
            enum_id, enum_name
        from dim.dim_dic
        where table_name = 'dim_user_accountinfo_df' and dic_column = 'mt'
    ) c
    on a.mt = c.enum_id
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
),
-- 字典表
dim_strategy as (
    select
        Id as id,
        Name as name,
        max(StrategyCode) as strategy_code,
        null as sort,
        max(case when action_type = 3 then sort end) sort_popup,
        max(case when action_type =9 then sort end) sort_return
    from ods.ods_tidb_short_video_center_activity a
    left join ads.ads_tidb_short_video_center_activity_position_view b
    on a.Id = b.center_activity_id
    group by 1,2
    union all
    select
        id,
        name,
        strategy_code,
        sort,
        null sort_popup,
        null sort_return
    from ads.ads_sv_goods_strategy_view
),
-- 订单表数据
payorder as(
    select
        dt,
        user_id,
        create_time,
        lpad(item_count, 3, '0') as item_count,
        base_amount/100 as base_amount,
        subpay_type,
        shop_item,
        package_id,
        order_id,
        case
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] = 201300 then '商店页'
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] = 200900 then '半屏'
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] = 203300 then 'H5'
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] is null then '半屏'
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] = 202100 and split(get_json_string(custom_data, '$.sendid'), '_')[2] in(0, 1) then '普通弹窗'
            when split(get_json_string(custom_data, '$.sendId'), '_')[1] = 202100 and split(get_json_string(custom_data, '$.sendid'), '_')[2] = 3 then '充值返回推弹窗'
        else '其他' end recharge_source,
        get_json_string(custom_data, '$.strategyId') as strategy_id,
        get_json_string(cooorder_extinfo, '$.SubscribeStatus') as SubscribeStatus,
        case
            when shop_item = 0 then '普通充值'
            when shop_item = 810 then 'SVIP'
            when shop_item = 840 then '签到卡'
            else '其他'
        end shop_item_type,
        if(subpay_type in ('AppStore', 'GooglePlay'), 0, 1) as if_third,
        b.time_duration
    from (
        select
            dt, user_id, create_time, item_count, base_amount, shop_item, package_id, order_id, custom_data, cooorder_extinfo, subpay_type
        from ads.ads_short_video_payorder_view
        where product_id=6833 and test_flag = 0 and dt >= '${bf_1_dt}' and dt <= '${dt}'
    ) a
    left join (
        -- -- 获取订单创建时间和订单完成时间
        select
            order_serial_id,
            finish_time - create_time as time_duration
        from ads.ads_report_trade_hkpayorder_detail_view
        where product_id = 6833 and dt >= '${bf_1_dt}' and dt <= '${dt}'
    ) b on a.order_id = b.order_serial_id
),
-- 充值档位曝光事件
exposure as (
    select
        case
            when element_id = 200900 or page_id = 200900 then '半屏'
            when page_id = 201300 then '商店页'
            when page_id = 203300 then 'H5'
            when element_id = 202100 and element_type in(0, 1) then '普通弹窗'
            when element_id = 202100 and element_type = 3 then '充值返回推弹窗'
        else '其他' end as recharge_source,
        zffs_list,
        event_strategy_id as strategy_id,
        login_id as user_id,
        event_tm,
        case
            when lower(czlx) like '%vip%' then 810
            when lower(czlx) like '%签到卡%' then 840
            else 0
        end as shop_item,
        max(dt) as dt,
        max(if(zffs_list is not null and zffs_list like '%,%', 1, 0)) if_third
    from ads.ads_sensors_cd_video_rechargeexposure_view
    where product_id = 6833 and dt >= '${bf_1_dt}' and dt <= '${dt}'
    group by 1,2,3,4,5,6
),
-- 创建订单事件
recharge as (
    select
        case
            when element_id = 200900 or page_id = 200900 then '半屏'
            when page_id = 201300 then '商店页'
            when page_id = 203300 then 'H5'
            when element_id = 202100 and element_type in(0, 1) then '普通弹窗'
            when element_id = 202100 and element_type = 3 then '充值返回推弹窗'
        else '其他' end as recharge_source,
	    event_strategy_id as strategy_id,
        login_id as user_id,
        event_tm,
        case
            when lower(czlx) like '%vip%' then 810
            when lower(czlx) like '%签到卡%' then 840
            else 0
        end as shop_item,
        dt,
        if(zffs in ('AppStore', 'GooglePlay', 'Android', 'IOS'), 0, 1) as if_third
    from ads.ads_sensors_cd_video_ordercreateaction_view
    where dt >= '${bf_1_dt}' and dt <= '${dt}'
),
-- 活跃关联曝光
z1 as (
    select
		a.dt,
		a.user_id,
        a.period_type,
        a.user_type,
        a.current_language2,
        a.current_language2_name,
        a.country_level,
        a.mt,
        a.mt_name,
        a.corever,
		case
            when b.strategy_id is null then '续订(或策略id为空)'
            when b.strategy_id in (21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011, 59996164203217021, 90064658960220161, 72785256107606176) then '商店页'
		else b.recharge_source end as recharge_source,
		if(b.strategy_id is null, '续订(或策略id为空)', b.strategy_id) as strategy_id,
		group_concat(distinct b.shop_item order by b.shop_item) as shop_item,
		count(distinct b.user_id) as exposure_uv,
		count(b.user_id) as exposure_pv,
		count(distinct case when if_third = 1 then b.user_id end) as third_party_exposure_uv
	from active a
	join exposure b
	on a.dt = b.dt and a.user_id = b.user_id
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
),
-- 活跃关联创建订单
z2 as(
    select
        a.dt,
		a.user_id,
        a.period_type,
        a.user_type,
        a.current_language2,
        a.current_language2_name,
        a.country_level,
        a.mt,
        a.mt_name,
        a.corever,
        case
            when b.strategy_id is null then '续订(或策略id为空)'
            when b.strategy_id in (21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011, 59996164203217021, 90064658960220161, 72785256107606176) then '商店页'
        else b.recharge_source end as recharge_source,
        if(b.strategy_id is null, '续订(或策略id为空)', b.strategy_id) as strategy_id,
        group_concat(distinct b.shop_item order by b.shop_item) as shop_item,
        count(distinct case when if_third = 0 then b.user_id end) as native_place_order_uv,
        count(distinct case when if_third = 1 then b.user_id end) as third_party_place_order_uv
    from active a
    join recharge b
    on a.dt = b.dt and a.user_id = b.user_id
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
),
-- 活跃关联充值
z3 as(
	select
		a.dt,
		a.user_id,
        a.period_type,
        a.user_type,
        a.current_language2,
        a.current_language2_name,
        a.country_level,
        a.mt,
        a.mt_name,
        a.corever,
        case
            when strategy_id is null then '续订(或策略id为空)'
            when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
            when strategy_id in (21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011, 59996164203217021, 90064658960220161, 72785256107606176) then '商店页'
            when strategy_id in(119945781576073372, 119945781576073373, 119945781576073374, 119945781576073375, 119945781576073376, 119945781576073377, 119945781576073378, 119945781576073379, 119945781576073380, 119945781576073381, 119945781576073382, 119945781576073383, 119741098431744170, 119741098431744171) then 'H5'
            when strategy_code regexp '^HC' THEN 'H5'
		else recharge_source end as recharge_source,
		if(b.strategy_id is null, '续订(或策略id为空)', b.strategy_id) as strategy_id,
		group_concat(distinct b.subpay_type order by b.subpay_type) as subpay_type,
        group_concat(distinct b.shop_item order by b.shop_item) as shop_item,
		count(distinct b.user_id) as recharge_num,
		count(distinct case when if_third = 0 then b.user_id end) as native_recharge_uv,
		count(distinct case when if_third = 1 then b.user_id end) as third_party_recharge_uv,
		count(distinct case when if_third = 0 and SubscribeStatus in (0, 1) then b.user_id end) as exclude_renewal_native_recharge_uv,
		count(distinct case when if_third = 1 and SubscribeStatus in (0, 1) then b.user_id end) as exclude_renewal_third_party_recharge_uv,
		count(case when if_third = 0 then b.user_id end) as native_recharge_pv,
		count(case when if_third = 1 then b.user_id end) as third_party_recharge_pv,
		sum(case when if_third = 0 then b.time_duration end) as native_payment_duration,
		sum(case when if_third = 1 then b.time_duration end) as third_party_payment_duration,
		sum(base_amount) as recharge_amt,
		sum(case when if_third = 0 then b.base_amount end) as native_recharge_amt,
		sum(case when if_third = 1 then b.base_amount end) as third_party_recharge_amt
	from active a
	join payorder b
	on a.dt = b.dt and a.user_id = b.user_id
	left join dim_strategy c
	on b.strategy_id = c.id
	where b.time_duration < 1800
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
)
select
    6833 as product_id,
	coalesce(a.dt, b.dt, c.dt) as dt,
    coalesce(a.period_type, b.period_type, c.period_type) as period_type,
    coalesce(a.recharge_source, b.recharge_source, c.recharge_source) as recharge_source,
    coalesce(a.strategy_id, b.strategy_id, c.strategy_id) as strategy_id,
    coalesce(a.user_id, b.user_id, c.user_id) as user_id,
    coalesce(a.user_type, b.user_type, c.user_type) as user_type,
    coalesce(a.current_language2, b.current_language2, c.current_language2) as current_language2,
    coalesce(a.current_language2_name, b.current_language2_name, c.current_language2_name) as current_language2_name,
    coalesce(a.country_level, b.country_level, c.country_level) as country_level,
    coalesce(a.mt, b.mt, c.mt) as mt,
    coalesce(a.corever, b.corever, c.corever) as corever,
    c.subpay_type,
    c.shop_item,
    coalesce(a.shop_item, b.shop_item, c.shop_item) as shop_item,
	d.strategy_code,
	d.name as strategy_name,
	a.exposure_uv,
	a.exposure_pv,
	a.third_party_exposure_uv,
	b.native_place_order_uv,
	b.third_party_place_order_uv,
	c.native_recharge_uv,
	c.third_party_recharge_uv,
	c.exclude_renewal_native_recharge_uv,
	c.exclude_renewal_third_party_recharge_uv,
	c.native_recharge_pv,
	c.third_party_recharge_pv,
	c.native_payment_duration,
	c.third_party_payment_duration,
	c.native_recharge_amt,
	c.third_party_recharge_amt,
	now() as etl_time
from z1 a
full join z2 b
on a.dt = b.dt and a.user_id = b.user_id and a.period_type = b.period_type and a.recharge_source = b.recharge_source and a.strategy_id = b.strategy_id
full join z3 c
on a.dt = c.dt and a.user_id = c.user_id and a.period_type = c.period_type and a.recharge_source = c.recharge_source and a.strategy_id = c.strategy_id
left join dim_strategy d
on a.strategy_id = d.id;
