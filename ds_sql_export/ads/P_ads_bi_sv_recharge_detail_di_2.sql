----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sv_recharge_detail_di
-- workflow_version : 8
-- create_user      : hufengju
-- task_name        : ads_bi_sv_recharge_detail_di
-- task_version     : 8
-- update_time      : 2025-04-07 16:42:04
-- sql_path         : \starrocks\tbl_ads_bi_sv_recharge_detail_di\ads_bi_sv_recharge_detail_di
----------------------------------------------------------------
-- SQL语句
insert into  ads.`ads_bi_sv_recharge_detail_di_2`
-- 活跃表
	with t123 as(
	-- dt,user_id,period_type
		select
			t1.dt,
			t1.user_id,
			period_type,
			user_type,
			dic_lang.remarks,
			case
					when country_level =1 then 'T1'
					when country_level =2 then 'T2'
					else '其他'
				end as country_level,
			dic_mt.enum_name,
			COALESCE(t1.corever,'其他') as corever
		from dws.dws_user_short_video_wide_active_period_ed t1
		left join dim.dim_dic dic_lang  -- 注册/投放语言
		on t1.current_language2 = dic_lang.enum_id
			and dic_lang.table_name = 'dim_producttype'
			and dic_lang.dic_column = 'language_id'
		left join dim.dim_dic  dic_mt  -- mt
		on t1.mt = dic_mt.enum_id
			and dic_mt.table_name = 'dim_user_accountinfo_df'
			and dic_mt.dic_column = 'mt'
		left join dim.dim_country_dic b
		on t1.reg_country=b.code
		where dt>='${bf_1_dt}' and dt<='${dt}'
			and product_id=6833
		group by 1,2,3,4,5,6,7,8
	),

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
		from ads.ads_short_video_payorder_view    --  dwd_trade_short_video_payorder
		where
			test_flag=0
			and dt>='${bf_1_dt}' and dt<='${dt}'
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
			-- case
			-- when cast(real_recharge as float)<10 then concat('00',real_recharge )
			-- when  cast(real_recharge as float)<100 then concat('0',real_recharge)
			-- else real_recharge end item_count,
			event_strategy_id strategy_id,
			-- case
			-- when czlx='vip' then 'SVIP'
			-- when czlx='签到卡充值' then '签到卡'
			-- else '普通充值'  end shop_item_type,
			login_id user_id,
			event_tm,
			max(dt) dt
		from ads.ads_sensors_cd_video_rechargeexposure_view
		where  dt>='${bf_1_dt}' and dt<='${dt}'
			and  product_id = '6833'
		group by 1,2,3,4
	),

	-- 广告曝光事件
	t3a as(
		select
			case
			when element_id='200900' or page_id='200900' then '半屏'
			when page_id ='201300' then '商店页'
			when page_id ='203300' then 'H5'
			when element_id='202100' and element_type in('0','1') then '普通弹窗'
			when element_id='202100' and element_type in('3') then '充值返回推弹窗'
			else '其他' end recharge_source,
			main_strategy_id strategy_id,
			login_id user_id,
			event_tm,
			max(dt) dt
		from ads.ads_sensors_cd_video_adpositionexposure_view
		where
			dt>='2025-03-26' ---改功能03.26上线
			and dt>='${bf_1_dt}' and dt<='${dt}'
			and  product_id = '6833'
		  and main_strategy_id  is not null
		group by 1,2,3,4
		),

		-- 广告收益数据
		t3b as(
		select
			dt,
			'半屏' recharge_source,
			main_strategy_id strategy_id,
			user_id,
			sum(amt) amt
		  from
		dws.dws_advertisement_user_position_amt_ed_new
		where
			dt>='${bf_1_dt}' and dt<='${dt}'
			and product_id=6833
			and main_strategy_id is not null
		group by 1,2,3,4
	),

	-- 活跃关联曝光
	z1 as (
	select
	*
	FROM
		(
			select
				t3.dt ,
				t123.period_type,
				t123.user_type,
				t123.remarks,
				t123.country_level,
				t123.enum_name as mt,
				t123.corever,
				case
				when coalesce(t3.strategy_id,t3a.strategy_id) is null then '续订(或策略id为空)'
				-- when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
				when coalesce(t3.strategy_id,t3a.strategy_id) in (
				21907679071567884,
				21412617518317655,
				21412110712176725,
				21411962535805011,
				59996164203217021,
				90064658960220161,
				72785256107606176) then '商店页'
				else coalesce(t3.recharge_source,t3a.recharge_source) end recharge_source,
				case
				when coalesce(t3.strategy_id,t3a.strategy_id) is null then '续订(或策略id为空)'
				else coalesce(t3.strategy_id,t3a.strategy_id) end strategy_id,
				-- shop_item_type 档位类型,
				-- item_count 充值档位,
				count(distinct t3.user_id) exposure_uv,
				count( t3.user_id) exposure_pv,
				count(distinct t3a.user_id) ad_exposure_uv,
				count( t3a.user_id) ad_exposure_pv
			from t123
			left join t3
			on t123.user_id = t3.user_id and t123.dt = t3.dt
			left join t3a
			on t3.user_id = t3a.user_id and t3.dt = t3a.dt and t3.strategy_id=t3a.strategy_id and t3.recharge_source=t3a.recharge_source
			group by 1,2,3,4,5,6,7,8,9
		) z1a
		where 1=1
		-- and recharge_source in ('半屏')
	),

	-- 活跃关联充值
	z2 as(
		select
		*
		FROM
			(
			select
				t2.dt ,
				t123.period_type,
				t123.user_type,
				t123.remarks,
				t123.country_level,
				t123.enum_name as mt,
				t123.corever,
				case
				when strategy_id is null then '续订(或策略id为空)'
				when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
				when strategy_id in (
				21907679071567884,
				21412617518317655,
				21412110712176725,
				21411962535805011,
				59996164203217021,
				90064658960220161,
				72785256107606176) then '商店页'
				when strategy_id in(
				119945781576073372,
				119945781576073373,
				119945781576073374,
				119945781576073375,
				119945781576073376,
				119945781576073377,
				119945781576073378,
				119945781576073379,
				119945781576073380,
				119945781576073381,
				119945781576073382,
				119945781576073383,
				119741098431744170,
				119741098431744171
				) then 'H5'
				else recharge_source end recharge_source,
				case
				when strategy_id is null then '续订(或策略id为空)'
				else strategy_id end strategy_id,
				shop_item_type , -- 档位类型
				item_count , -- 充值档位
				count(distinct t2.user_id) recharge_un, --充值人数
				count(t2.user_id) recharge_times, --充值次数
				sum(base_amount) recharge_amount, -- 充值金额
				sum(case when shop_item_type='普通充值' then base_amount end) `normal_recharge_amount`,-- `充值金额-普通充值`,
				sum(case when shop_item_type='签到卡' then base_amount end) `signin_recharge_amount`,-- `充值金额-签到卡`,
				sum(case when shop_item_type='SVIP' then base_amount end) `svip_recharge_amount`,-- `充值金额-SVIP`,
				count(case when shop_item_type='普通充值' then t2.user_id end) `normal_recharge_times`,-- `充值次数-普通充值`,
				count(case when shop_item_type='签到卡' then t2.user_id end) `signin_recharge_times`,-- `充值次数-签到卡`,
				count(case when shop_item_type='SVIP' then t2.user_id end) `svip_recharge_times`,-- `充值次数-SVIP`,
				count(distinct case when shop_item_type='普通充值' then t2.user_id end) `normal_recharge_un`,-- `充值人数-普通充值`,
				count(distinct case when shop_item_type='签到卡' then t2.user_id end) `signin_recharge_un`,-- `充值人数-签到卡`,
				count(distinct case when shop_item_type='SVIP' then t2.user_id end) `svip_recharge_un`, -- `充值人数-SVIP`,
				count(distinct case when shop_item_type !='普通充值' then t2.user_id end) `recharge_un_subscription`-- `充值人数-订阅`
			from t123
			left join t2
			on t123.user_id = t2.user_id and t123.dt = t2.dt
			group by 1,2,3,4,5,6,7,8,9,10,11
			) z2a
		where 1=1
		-- and 充值来源 in ('半屏')
	),

	-- 活跃关联广告收益
	z3 as(
		select
		*
		FROM
			(
			select
				t3b.dt ,
				t123.period_type,
				t123.user_type,
				t123.remarks,
				t123.country_level,
				t123.enum_name as mt,
				t123.corever,
				recharge_source  ,
				strategy_id  ,
				sum(amt) ad_amt
			from t123
			left join t3b
			on t123.user_id = t3b.user_id and t123.dt = t3b.dt
			group by 1,2,3,4,5,6,7,8,9
			) z3a
		where 1=1
		-- and 充值来源 in ('半屏')
	),

	dim_strategy as (
		select
			Id id, Name name,
			max(StrategyCode) strategy_code,
			max(null) sort,
			max(case when action_type = 3 then sort end ) sort_popup,
			max(case when action_type =9 then sort end ) sort_return
		from ods.ods_tidb_short_video_center_activity t1
		left join
		ads.ads_tidb_short_video_center_activity_position_view t2
		on t1.Id=t2.center_activity_id
		group by 1,2
		union all
		select id,name,strategy_code,sort,null sort_popup, null sort_return
		from ads.ads_sv_goods_strategy_view
	)

	select
		dt,
		6833 as product_id,
		period_type,
		strategy_id,
		recharge_source,
		user_type,
		remarks as put_language,
		country_level,
		mt,
		corever,
		strategy_name,
		cast(strategy_weight as varchar) strategy_weight,
		cast(strategy_code as varchar) strategy_code,
		if(row_1=1 ,exposure_uv,0)  exposure_uv,
		if(row_1=1 ,exposure_pv,0)  exposure_pv,
		if(row_1=1 ,ad_exposure_uv,0)  ad_exposure_uv,
		if(row_1=1 ,ad_exposure_pv,0)  ad_exposure_pv,
		if(row_1=1 ,ad_amt,0)  ad_amt,
		ifnull(shop_item_type,0) shop_item_type,
		ifnull(item_count,0) item_count,
		ifnull(recharge_un,0) recharge_un,
		ifnull(recharge_times,0) recharge_times,
		ifnull(recharge_amount,0) recharge_amount,
		ifnull(normal_recharge_amount,0) normal_recharge_amount,
		ifnull(signin_recharge_amount,0) `signin_recharge_amount`,
		ifnull(svip_recharge_amount,0) `svip_recharge_amount`,
		ifnull(`normal_recharge_times`,0) `normal_recharge_times`,
		ifnull(`signin_recharge_times`,0) `signin_recharge_times`,
		ifnull(`svip_recharge_times`,0) `svip_recharge_times`,
		ifnull(`normal_recharge_un`,0) `normal_recharge_un`,
		ifnull(`signin_recharge_un`,0) `signin_recharge_un`,
		ifnull(`svip_recharge_un`,0) `svip_recharge_un`,
		ifnull(`recharge_un_subscription`,0) `recharge_un_subscription`,
		now() as etl_time
	from
		(
			select
				z12.*,
				strategy_code , -- 策略代号
				ifnull(name,z12.strategy_id) strategy_name, -- 策略名称
				case
				when recharge_source in ('半屏','商店页','续订(或策略id为空)') then sort
				when recharge_source in ('普通弹窗') then sort_popup
				when recharge_source in ('充值返回推弹窗') then sort_return
				else null end strategy_weight, -- 策略权重
				row_number() over(partition by dt,recharge_source,strategy_id ) row_1
			from
				(
					select
					coalesce(z1.dt,z2.dt) dt,
					coalesce(z1.period_type,z2.period_type) period_type, -- 周期类型
					coalesce(z1.strategy_id,z2.strategy_id) strategy_id, -- 策略ID
					coalesce(z1.recharge_source,z2.recharge_source) recharge_source, -- 充值来源
					coalesce(z1.user_type,z2.user_type) user_type, -- 用户类型
					coalesce(z1.remarks,z2.remarks) remarks, -- 投放语言
					coalesce(z1.country_level,z2.country_level) country_level, -- 国家等级
					coalesce(z1.mt,z2.mt) mt, -- 终端
					coalesce(z1.corever,z2.corever) corever, -- core
					coalesce(z1.exposure_uv,0) exposure_uv, -- 曝光UV
					coalesce(z1.exposure_pv,0) exposure_pv, -- 曝光PV
					coalesce(z1.ad_exposure_uv,0) ad_exposure_uv, -- 广告曝光UV
					coalesce(z1.ad_exposure_pv,0) ad_exposure_pv, -- 广告曝光PV
					coalesce(z3.ad_amt,0) ad_amt,  -- 广告收益
					z2.shop_item_type,  -- 档位类型
					z2.item_count,  -- 充值档位
					z2.recharge_un,  -- 充值人数
					z2.recharge_times,  -- 充值次数
					z2.recharge_amount,  -- 充值金额
					z2.normal_recharge_amount,  -- 充值金额-普通充值
					z2.signin_recharge_amount,  -- 充值金额-签到卡
					z2.svip_recharge_amount,  -- 充值金额-SVIP
					z2.normal_recharge_times,  -- 充值次数-普通充值
					z2.signin_recharge_times,  -- 充值次数-签到卡
					z2.svip_recharge_times,  -- 充值次数-SVIP
					z2.normal_recharge_un,  -- 充值人数-普通充值
					z2.signin_recharge_un,  -- 充值人数-签到卡
					z2.svip_recharge_un,  -- 充值人数-SVIP
					z2.recharge_un_subscription  -- 充值人数-订阅
					from z1
					full join z2
					on z1.strategy_id=z2.strategy_id and z1.recharge_source=z2.recharge_source and z1.dt=z2.dt and z1.period_type=z2.period_type
					full join z3
					on z1.strategy_id=z3.strategy_id and z1.recharge_source=z3.recharge_source and z1.dt=z3.dt and z1.period_type=z3.period_type
				) z12
			left join  dim_strategy
			on z12.strategy_id = dim_strategy.id
		) z13
	where dt is not null
	-- and strategy_name in ('C1-1次复购-20签到卡平替-下订阅(265版本)','C1-2次及以上复购-下订阅(265版本)')
	-- and strategy_code in ('B1V2');
