-------------------------------------------------
-- 应用报表：海剧-用户维度报表/海剧用户充值明细报表
-------------------------------------------------

------------------  阅读  ------------------
with t_video as (
-- 活跃表
with t123 as(
select
	t1.dt,
	t1.user_id
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
where
	dt >= '${开始时间}'
	and dt <= '${结束时间}'
	${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
	${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
	${if(len(注册国家) == 0,"","and coalesce(b.country,reg_country) in ('" + 注册国家 + "')")}
	${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
	${if(len(国家等级) == 0,"","and
		case
			when country_level =1 then 'T1'
			when country_level =2 then 'T2'
			else '其他'
		end in ('" + 国家等级 + "')")}
	${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
	${if(len(CORE) == 0,"","and COALESCE(t1.corever,'其他') in ('" + CORE + "')")}
group by 1,2
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
	when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='203300' then '活动'
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
where
	test_flag=0
	and dt >= '${开始时间}'
	and dt <= '${结束时间}'
),

-- 充值档位曝光事件
t3 as(
select
	case
	when element_id='200900' or page_id='200900' then '半屏'
	when page_id ='201300' then '商店页'
	when page_id ='203300' then '活动'
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
where
	dt >= '${开始时间}'
	and dt <= '${结束时间}'
	and  product_id = '6833'
group by 1,2,3,4
),

z1 as (
select
*
FROM
	(
	select
		'汇总' as dt ,
		case
		when strategy_id is null then '续订(或策略id为空)'
		-- when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
		when strategy_id in (
		21907679071567884,
		21412617518317655,
		21412110712176725,
		21411962535805011,
		59996164203217021,
		90064658960220161,
		72785256107606176) then '商店页'
		else recharge_source end 充值来源,
		case
		when strategy_id is null then '续订(或策略id为空)'
		else strategy_id end 策略ID,
		-- shop_item_type 档位类型,
		-- item_count 充值档位,
		count(distinct t3.user_id) 曝光UV,
		count( t3.user_id) 曝光PV
	from t123
	left join t3
	on t123.user_id = t3.user_id and t123.dt = t3.dt
	group by 1,2,3
	) z1a
where 1=1
${if(len(充值来源) == 0,"","and 充值来源 in ('" + 充值来源 + "')")}
),

-- 活跃关联充值
z2 as(
select
*
FROM
	(
	select
		'汇总' as dt ,
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
		else recharge_source end 充值来源,
		case
		when strategy_id is null then '续订(或策略id为空)'
		else strategy_id end 策略ID,
		shop_item_type 档位类型,
		item_count 充值档位,
		count(distinct t2.user_id) 充值人数,
		count(t2.user_id) 充值次数,
		sum(base_amount) 充值金额,
		sum(case when shop_item_type='普通充值' then base_amount end) `充值金额-普通充值`,
		sum(case when shop_item_type='签到卡' then base_amount end) `充值金额-签到卡`,
		sum(case when shop_item_type='SVIP' then base_amount end) `充值金额-SVIP`,
		sum(case when shop_item_type!='普通充值' then base_amount end) `充值金额-订阅`,

		count(case when shop_item_type='普通充值' then t2.user_id end) `充值次数-普通充值`,
		count(case when shop_item_type='签到卡' then t2.user_id end) `充值次数-签到卡`,
		count(case when shop_item_type='SVIP' then t2.user_id end) `充值次数-SVIP`,
		count(case when shop_item_type!='普通充值' then t2.user_id end) `充值次数-订阅`,

		count(distinct case when shop_item_type='普通充值' then t2.user_id end) `充值人数-普通充值`,
		count(distinct case when shop_item_type='签到卡' then t2.user_id end) `充值人数-签到卡`,
		count(distinct case when shop_item_type='SVIP' then t2.user_id end) `充值人数-SVIP`,
		count(distinct case when shop_item_type !='普通充值' then t2.user_id end) `充值人数-订阅`
	from t123
	left join t2
	on t123.user_id = t2.user_id and t123.dt = t2.dt
	group by 1,2,3,4,5
	) z2a
where 1=1
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
	日期,
	策略ID,
  策略名称,
	cast(策略代号 as varchar) 策略代号,
  concat(策略代号,'：',策略名称) as `代号+策略`,
	cast(策略权重 as varchar) 权重,
	充值来源,

	if(row_1=1 ,曝光UV,0)  曝光UV,
	if(row_1=1 ,曝光PV,0)  曝光PV,
	ifnull(档位类型,0) 档位类型,
	ifnull(充值档位,0) 充值档位,

	ifnull(充值人数,0) 充值人数,
	ifnull(充值次数,0) 充值次数,
	ifnull(充值金额,0) 充值金额,

	ifnull(`充值金额-普通充值`,0) `充值金额-普通充值`,
	ifnull(`充值金额-订阅`,0) `充值金额-订阅`,
	ifnull(`充值金额-SVIP`,0) `充值金额-SVIP`,
  0                        as `充值金额-VIP`,
	ifnull(`充值金额-签到卡`,0) `充值金额-福利包/签到卡`,
  0                        as `充值金额-旧订阅卡`,

	ifnull(`充值次数-普通充值`,0) `充值次数-普通充值`,
	ifnull(`充值次数-订阅`,0) `充值次数-订阅`,
	ifnull(`充值次数-SVIP`,0) `充值次数-SVIP`,
  0                        as `充值次数-VIP`,
	ifnull(`充值次数-签到卡`,0) `充值次数-福利包/签到卡`,
  0                        as `充值次数-旧订阅卡`,

	ifnull(`充值人数-普通充值`,0) `充值人数-普通充值`,
	ifnull(`充值人数-订阅`,0) `充值人数-订阅`,
	ifnull(`充值人数-SVIP`,0) `充值人数-SVIP`,
  0                        as `充值人数-VIP`,
	ifnull(`充值人数-签到卡`,0) `充值人数-福利包/签到卡`,
  0                        as `充值人数-旧订阅卡`,
  0.36 as `预估订阅ARPU系数`

from
	(
	select
		z12.*,
		strategy_code 策略代号,
		ifnull(name,z12.策略ID) 策略名称,
		case
		when 充值来源 in ('半屏','商店页','续订(或策略id为空)') then sort
		when 充值来源 in ('普通弹窗') then sort_popup
		when 充值来源 in ('充值返回推弹窗') then sort_return
		else null end 策略权重,
		row_number() over(partition by 日期,充值来源,策略ID ) row_1
	from
		(
		select
		ifnull(z1.dt,z2.dt) 日期,
		ifnull(z1.策略ID,z2.策略ID) 策略ID,
		ifnull(z1.充值来源,z2.充值来源) 充值来源,
		ifnull(z1.曝光UV,0) 曝光UV,
		ifnull(z1.曝光PV,0) 曝光PV,
		z2.档位类型,
		z2.充值档位,
		z2.充值人数,
		z2.充值次数,
		z2.充值金额,
		z2.`充值金额-普通充值`,
		z2.`充值金额-签到卡`,
		z2.`充值金额-SVIP`,
		z2.`充值金额-订阅`,
		z2.`充值次数-普通充值`,
		z2.`充值次数-签到卡`,
		z2.`充值次数-SVIP`,
		z2.`充值次数-订阅`,
		z2.`充值人数-普通充值`,
		z2.`充值人数-签到卡`,
		z2.`充值人数-SVIP`,
		z2.`充值人数-订阅`
		from z1
		full join z2
		on z1.策略ID=z2.策略ID and z1.充值来源=z2.充值来源 and z1.dt=z2.dt
		) z12
	left join  dim_strategy
	on z12.策略ID = dim_strategy.id
	) z13
where 日期 is not null
${if(len(策略名称) == 0,"","and 策略名称 in ('" + 策略名称 + "')")}
${if(len(策略代号) == 0,"","and 策略代号 in ('" + 策略代号 + "')")}
${if(len(充值来源) == 0,"","and 充值来源 in ('" + 充值来源 + "')")}
)

------------------  阅读  ------------------
, t_book as (
  with z1 as (
    select
	    t1.dt,
		t1.user_id
  from dws.dws_user_wide_active_period_ed t1
	left join dim.dim_dic dic_lang
	on t1.current_language2 = dic_lang.enum_id
		and dic_lang.table_name = 'dim_producttype'
		and dic_lang.dic_column = 'language_id'
	left join dim.dim_dic  dic_mt
	on t1.mt = dic_mt.enum_id
		and dic_mt.table_name = 'dim_user_accountinfo_df'
		and dic_mt.dic_column = 'mt'
	left join dim.dim_country_dic b
	on t1.reg_country=b.code
where   dt >= '${开始时间}' and dt <= '${结束时间}'
    ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
    ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
    ${if(len(注册国家) == 0,"","and coalesce(b.country,reg_country) in ('" + 注册国家 + "')")}
    ${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
    ${if(len(国家等级) == 0,"","and
        case
            when country_level =1 then 'T1'
            when country_level =2 then 'T2'
            else '其他'
        end in ('" + 国家等级 + "')")}
    ${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
    ${if(len(CORE) == 0,"","and COALESCE(t1.corever,'其他') in ('" + CORE + "')")}
group by 1,2
),
z2 as (
    SELECT  t1.dt
        ,create_time
        ,user_id
        ,CASE WHEN item_count < 10 THEN concat('00',cast(item_count                                    AS varchar))
              WHEN item_count < 100 THEN concat('0',cast(item_count AS varchar))  ELSE cast(item_count AS varchar) END item_count
        ,base_amount/100 base_amount
        ,shop_item
        ,package_id
        ,CASE WHEN regexp(package_id,'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard') THEN '活动'
                WHEN regexp(package_id,'Ps_HalfLimitFreeCard') THEN '其他'
                WHEN regexp(package_id,'Ps_Half') THEN '半屏'
                WHEN regexp(package_id,'Ps_SendCoupon|Ps_ReturnFail|Ps_GiftRewardPop') THEN '半屏'  -- 半屏挽留
                WHEN regexp(package_id,'Ps_Shop_half|Ps_Shop') THEN '商店'
                WHEN regexp(package_id,'Ps_ReturnRecommend') THEN '充值返回推弹窗'
   			    WHEN regexp(package_id,'Ps_PopInfo')  then '普通弹窗' -- TAG弹窗
                WHEN regexp(package_id,'Ps_Bonus') THEN '商店'
                WHEN package_id = -99 THEN '空来源'  ELSE '其他' END             AS recharge_source
        ,CASE WHEN regexp(package_id,'Ps_SkipChapter') THEN '跳章解锁'
            WHEN regexp(package_id,'Ps_H5Shop') THEN 'H5商城'
            WHEN regexp(package_id,'Ps_ReturnFail') THEN '失败挽留'
            WHEN regexp(package_id,'Ps_ThirdPay') THEN '三方支付'
            WHEN regexp(package_id,'Ps_H5EDMLimitedOffer') THEN 'EDM'
          ELSE '其他' END                                         AS recharge_source2
         ,case when regexp(package_id,'Ps_ReturnRecommend') then  split(split(package_id,'|')[2],'_')[4]
		      when regexp(package_id,'Ps_PopInfo') then  split(split(package_id,'|')[2],'_')[4]
             else  get_json_int(SensorsData, '$.activity_id')  end as activity_id
        ,case when regexp(package_id,'Ps_Batch') then -1   -- 批量的取package解析
              else  get_json_int(SensorsData, '$.event_strategy_id')  end as strategy_id  -- 原始策略ID
        ,split(split(package_id,'|')[3],'_')[1]    AS strategy_id2  -- 解析package_id策略ID
        ,CASE WHEN shop_item = 0 THEN '普通充值'
                WHEN shop_item = 810 THEN 'SVIP'
                WHEN shop_item in ( 830,840) THEN '福利包'
                -- WHEN shop_item = 840 THEN '新福利包'
                WHEN shop_item = 850 THEN 'VIP'
                WHEN shop_item = 800 THEN '旧订阅卡'  ELSE '其他' END shop_item_type
        ,get_json_string(cooorder_extinfo, '$.SubscribeStatus') SubscribeStatus
    FROM ads.ads_trade_user_payorder_view t1
    WHERE test_flag = 0
	and user_id not in (176151629)
    AND t1.dt >= '${开始时间}' and t1.dt <= '${结束时间}'
),
z3 as (
    select
    dt,
    create_time,
    user_id,
    item_count,
    base_amount,
    shop_item,
    case when recharge_source = '半屏' and strategy_id = -1 and strategy_id2 in (2,930084) then '商店'  -- 一般-1的情况都是商店的策略
        when strategy_id =2 then '商店'
         else recharge_source end as recharge_source ,
    recharge_source2 ,
    activity_id,
    strategy_id,
    strategy_id2,
    shop_item_type,
    package_id,
    SubscribeStatus,
    case  when recharge_source = '半屏' and strategy_id >0 then strategy_id
            when recharge_source = '半屏' and strategy_id = -1 and strategy_id2 > 0  then strategy_id2
            when recharge_source = '商店' and strategy_id >0 then strategy_id
            when recharge_source = '商店' and (strategy_id = -1 or strategy_id is null)  and strategy_id2 > 0  then strategy_id2
            when recharge_source = '活动'  then activity_id
            when recharge_source = '充值返回推弹窗'  and activity_id >0 then activity_id
            when recharge_source = '普通弹窗'  and activity_id >0 then activity_id
            when recharge_source = '普通弹窗'  and activity_id = 8684412 then 8713442
            when recharge_source = '普通弹窗'  and activity_id = 8684413 then 8713445
            when recharge_source = '其他'  and activity_id >0 then activity_id
            when recharge_source = '其他'  and strategy_id >0 then strategy_id
            when recharge_source = '其他'  and strategy_id2 >0 then strategy_id2
            when recharge_source = '空来源' and  activity_id > 0 then activity_id
            when recharge_source = '空来源' then coalesce(strategy_id,strategy_id2)
    else -99 end as event_strategy_id,
    case when recharge_source = '商店' then 1
         when recharge_source = '半屏' and strategy_id = -1 and strategy_id2 in (2,930084) then 1
         when strategy_id = 2 then 1
         when recharge_source = '半屏' then 2
         else 3  end as recharge_scene_type
    from z2
),
z4 as (
select
    z3.dt,
    z3.create_time,
    z3.user_id,
    z3.item_count,
    z3.base_amount,
    z3.shop_item,
    z3.recharge_source ,
    z3.recharge_source2 , -- 归因跳章解锁/失败挽留等
    SubscribeStatus,
    case when SubscribeStatus = 2 and shop_item_type <> '普通充值' then '续订(或策略id为空)'
         when recharge_source = '半屏' and  t1.tactics_name is null  and t3.tactics_name is not null then '商店'
         when recharge_source = '半屏' and  t1.pattern_type = 2 then '活动'   -- 半屏使用活动专区归为活动
         when recharge_source = '半屏' and  strategy_id2 = 2 and strategy_id <> 7 then '商店'   -- 半屏引用商店策略（2)
         when recharge_source2 = '失败挽留' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name) is null  then '其他'   -- 半屏,取不到策略
         when recharge_source = '空来源' and recharge_source2 <>'其他' then recharge_source2
         when recharge_source = '空来源' and t3.tactics_name  is not null then '商店'
         when recharge_source = '空来源' and t4.tactics_name  is not null then '半屏'
         when recharge_source = '空来源' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) ='其他' then '续订(或策略id为空)'
    else recharge_source end as recharge_source3 , -- 处理半屏引用商店策略
    z3.activity_id,
    z3.strategy_id,
    z3.strategy_id2,
    z3.shop_item_type,
    z3.package_id,
    z3.event_strategy_id ,
  t1.tactics_name as tactics_name1,
  t2.tactics_name as tactics_name2,
  t3.tactics_name as tactics_name3,
  t4.tactics_name as tactics_name4,
  case when SubscribeStatus = 2 and shop_item_type <> '普通充值' then '续订'
       when recharge_source = '空来源' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) ='其他' then '策略ID为空'
  else coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) end as tactics_name_,
  if(t1.pattern_type = 2,'活动专区','其他') as `半屏档位模式`
from z1
left join z3
on z1.user_id = z3.user_id
and z1.dt = z3.dt
left join  dim.tag_center_merchandise_tactics_view   t1  -- 半屏/商店取策略
  on z3.recharge_scene_type = t1.scene_type
 and z3.event_strategy_id = t1.tactics_id
 and concat( t1.scene_type,'-',t1.tactics_id) not in ('2-360003','2-330011','2-330010','2-330012','2-480053')
left join  dim.dim_tag_center_activity_view   t2  -- 活动策略
  on z3.activity_id  = t2.tactics_id
left join  dim.tag_center_merchandise_tactics_view   t3    -- 其他位置取了商店的策略
   on z3.recharge_scene_type  in (2,3)  -- 3
  and t3.scene_type = 1
  and z3.event_strategy_id = t3.tactics_id
left join  dim.tag_center_merchandise_tactics_view   t4    -- 补异常半屏数据
   on z3.recharge_scene_type  in (2,3)  -- 3
  and t4.scene_type = 2
  and z3.event_strategy_id = t4.tactics_id
)
,
z5 as (
    select
       '汇总' as dt,
       充值来源,
       event_strategy_id  as 策略ID,
       count(distinct t0.user_id) as 曝光UV,
	   -- count(1) as  曝光PV
       sum(exposure_pv_s) as  曝光PV,
       max(tactics_name) as 策略名称
    from z1
    left join (
         -- 部分曝光落表，其余走实时
            SELECT  dt
               ,CASE WHEN position = '半屏' AND t1.pattern_type = 2 THEN '活动'
                     WHEN position in ('半屏','100708') AND t2.tactics_id > 2 and event_strategy_id not in (690001,720001,510001,540001)  THEN '活动'
                    WHEN position in ('半屏','100338','100337','100707','100401') AND t0.event_strategy_id in (2,930084) THEN '商店'
                     WHEN position IN (100284) THEN '活动'
                     WHEN position IN (100031,100120) THEN '商店'
                     WHEN position IN ('商店','半屏') THEN position
                     WHEN position = '100400' THEN '充值返回推弹窗'
                     WHEN position = '100390' THEN '普通弹窗'
                     WHEN position in ('100338','100337','100707') and t1.pattern_type = 2 THEN '活动'
                     WHEN position in ('100338','100337','100707') then '半屏' ELSE '其他' END               AS 充值来源
               ,CASE WHEN event_strategy_id > 0 THEN event_strategy_id  ELSE t0.activity_id END AS event_strategy_id
               ,user_id
               ,exposure_pv_10s as exposure_pv_s
               ,coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name) as tactics_name
        FROM ads.ads_bi_sr_rechargeexposure_statistics_di t0
        LEFT JOIN dim.tag_center_merchandise_tactics_view t1
        ON t0.position in ('半屏','100338','100337','100707')
          AND t1.scene_type = 2
          AND t0.event_strategy_id = t1.tactics_id
           and concat( t1.scene_type,'-',t1.tactics_id) not in ('2-360003','2-330011','2-330010','2-330012','2-480053','2-30003','2-2')
        left join  dim.dim_tag_center_activity_view   t2  -- 活动策略
         on t0.activity_id  = t2.tactics_id
      AND date(t2.begin_time) <> '0001-01-01'
        LEFT JOIN dim.tag_center_merchandise_tactics_view t3 -- 商店取策略
        ON t3.scene_type = 1 AND t0.event_strategy_id = t3.tactics_id
        WHERE position NOT IN ('100647', '100651')
        AND t0.dt >= '${开始时间}' and t0.dt <= '${结束时间}'
        and t0.dt < date_add(current_date(),-3)
        UNION ALL
        SELECT  dt
               ,CASE WHEN element_id = '100708' AND t1.pattern_type = 2 THEN '活动'
                     WHEN element_id = '100708' AND t2.tactics_id > 2 and event_strategy_id not in (690001,720001,510001,540001)  THEN '活动'
                     WHEN element_id in ('100708','100338','100337','100707','100401') AND t0.event_strategy_id in (2,930084)  THEN '商店'
                     WHEN element_id IN (100284) THEN '活动'
                     WHEN element_id = '100708' AND element_type IN (0,-1) THEN '半屏'
                     WHEN element_id in ('100338','100337','100707')  AND t1.pattern_type = 2 THEN '活动'
                     WHEN element_id in ('100338','100337','100707')  THEN '半屏'
                     WHEN element_id IN (100024,100025,100126,100365,100120) THEN '商店'
                     WHEN element_id IN (100031) THEN '商店'
                     WHEN element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN '充值返回推弹窗'
					 WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN '普通弹窗'
					 ELSE '其他' END AS 充值来源
               ,CASE WHEN element_id = '100708' AND element_type IN (0,-1) THEN event_strategy_id
                     WHEN element_id IN (100024,100025,100126,100365) THEN event_strategy_id

                     when element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN split(pay_link, '_')[4]
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' and split(pay_link, '_')[4]= 8684412 THEN 8713442
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' and split(pay_link, '_')[4]= 8684413 THEN 8713445
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN split(pay_link, '_')[4]
                     WHEN event_strategy_id > 0 THEN event_strategy_id  ELSE t0.activity_id END   AS event_strategy_id
               ,coalesce(identity_user_id,login_id)                                            AS user_id
               ,COUNT(distinct left(event_tm,18))
               ,max(coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name) )
        -- FROM ods_log.ods_sensors_cd_video_production_rechargeexposure t0
        FROM ads.ads_sensors_production_rechargeexposure_view t0
        LEFT JOIN dim.tag_center_merchandise_tactics_view t1 -- 半屏/商店取策略
        ON t0.element_id in ('100708','100338','100337','100707')
        AND  t1.scene_type = 2
        AND t0.event_strategy_id = t1.tactics_id
         and concat( t1.scene_type,'-',t1.tactics_id) not in ('2-360003','2-330011','2-330010','2-330012','2-480053','2-30003','2-2')
       left join  dim.dim_tag_center_activity_view   t2  -- 活动策略
         on (case when element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN split(pay_link, '_')[4]
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' and split(pay_link, '_')[4]= 8684412 THEN 8713442
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' and split(pay_link, '_')[4]= 8684413 THEN 8713445
                     when element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN split(pay_link, '_')[4]
             WHEN event_strategy_id > 0 THEN event_strategy_id  ELSE t0.activity_id end     )
                        = t2.tactics_id
      AND date(t2.begin_time) <> '0001-01-01'
       LEFT JOIN dim.tag_center_merchandise_tactics_view t3 -- 商店取策略
        ON t3.scene_type = 1 AND t0.event_strategy_id = t3.tactics_id
        WHERE dt >= date_add(current_date(),-3)
        AND t0.dt >= '${开始时间}' and t0.dt <= '${结束时间}'
        AND project_id = 5
        AND element_id NOT IN ('100647', '100651')
        GROUP BY  1,2,3,4
    ) t0
   on z1.user_id = t0.user_id and z1.dt = t0.dt  and event_strategy_id > 0
     group by 1,2,3
),
  z6 AS (
SELECT
       '汇总' as dt
       ,coalesce(recharge_source3,'其他') AS 充值来源 -- 过滤活跃未充值用户
       ,event_strategy_id               AS 策略ID
       ,tactics_name_                   AS 策略名称
       ,shop_item_type                  AS 档位类型
       ,item_count                      AS 充值档位
       ,COUNT(user_id)                  AS 充值次数
       ,COUNT(distinct user_id) 充值人数
       ,SUM(base_amount) 充值金额
       ,SUM(case WHEN shop_item_type = '普通充值' THEN base_amount end) `充值金额-普通充值`
       ,SUM(case WHEN shop_item_type <> '普通充值' THEN base_amount end) `充值金额-订阅`
       ,SUM(case WHEN shop_item_type = 'SVIP' THEN base_amount end) `充值金额-SVIP`
       ,SUM(case WHEN shop_item_type IN ('福利包','新福利包') THEN base_amount end) `充值金额-福利包`
       ,SUM(case WHEN shop_item_type = 'VIP' THEN base_amount end) `充值金额-VIP`
       ,SUM(case WHEN shop_item_type = '旧订阅卡' THEN base_amount end) `充值金额-旧订阅卡`

       ,COUNT(case WHEN shop_item_type = '普通充值' THEN 1 end) `充值次数-普通充值`
       ,COUNT(case WHEN shop_item_type <> '普通充值' THEN 1 end) `充值次数-订阅`
       ,COUNT(case WHEN shop_item_type = 'SVIP' THEN 1 end) `充值次数-SVIP`
       ,COUNT(case WHEN shop_item_type IN ('福利包','新福利包') THEN 1 end) `充值次数-福利包`
       ,COUNT(case WHEN shop_item_type = 'VIP' THEN 1 end) `充值次数-VIP`
       ,COUNT(case WHEN shop_item_type = '旧订阅卡' THEN 1 end) `充值次数-旧订阅卡`

       ,COUNT(distinct case WHEN shop_item_type = '普通充值' THEN user_id end) `充值人数-普通充值`
       ,COUNT(distinct case WHEN shop_item_type <> '普通充值' THEN user_id end) `充值人数-订阅`
       ,COUNT(distinct case WHEN shop_item_type = 'SVIP' THEN user_id end) `充值人数-SVIP`
       ,COUNT(distinct case WHEN shop_item_type IN ('福利包','新福利包') THEN user_id end) `充值人数-福利包`
       ,COUNT(distinct case WHEN shop_item_type = 'VIP' THEN user_id end) `充值人数-VIP`
       ,COUNT(distinct case WHEN shop_item_type = '旧订阅卡' THEN user_id end) `充值人数-旧订阅卡`
FROM z4
GROUP BY  1,2,3,4,5,6 )

SELECT  日期
       ,策略ID
       ,策略名称
       ,plan_code as `策略代号`
       ,concat(coalesce(plan_code,'/'),'：',策略名称) as `代号+策略`
       ,cast(sort as varchar)  as `权重`
       ,CASE WHEN 充值来源 = '半屏' AND 策略名称 = '其他' THEN '其他'  ELSE 充值来源 END AS 充值来源

       ,if(row_1 = 1 ,曝光UV,0)                                          AS 曝光UV
       ,if(row_1 = 1 ,曝光PV,0)                                          AS 曝光PV
       ,ifnull(`档位类型`,0)                                               AS 档位类型
       ,ifnull(`充值档位`,0)                                               AS 充值档位

       ,ifnull(`充值人数`,0)                                               AS 充值人数
       ,ifnull(`充值次数`,0)                                               AS 充值次数
       ,ifnull(`充值金额`,0)                                               AS 充值金额

       ,ifnull(`充值金额-普通充值`,0)                                      AS `充值金额-普通充值`
       ,ifnull(`充值金额-订阅`,0)                                          AS `充值金额-订阅`
       ,ifnull(`充值金额-SVIP`,0)                                          AS `充值金额-SVIP`
       ,ifnull(`充值金额-VIP`,0)                                           AS `充值金额-VIP`
       ,ifnull(`充值金额-福利包`,0)                                         AS `充值金额-福利包/签到卡`
       ,ifnull(`充值金额-旧订阅卡`,0)                                       AS `充值金额-旧订阅卡`

       ,ifnull(`充值人数-普通充值`,0)                                       AS `充值人数-普通充值`
       ,ifnull(`充值人数-订阅`,0)                                           AS `充值人数-订阅`
       ,ifnull(`充值人数-SVIP`,0)                                          AS `充值人数-SVIP`
       ,ifnull(`充值人数-VIP`,0)                                           AS `充值人数-VIP`
       ,ifnull(`充值人数-福利包`,0)                                         AS `充值人数-福利包/签到卡`
       ,ifnull(`充值人数-旧订阅卡`,0)                                       AS `充值人数-旧订阅卡`

       ,ifnull(`充值次数-普通充值`,0)                                       AS `充值次数-普通充值`
       ,ifnull(`充值次数-订阅`,0)                                           AS `充值次数-订阅`
       ,ifnull(`充值次数-SVIP`,0)                                          AS `充值次数-SVIP`
       ,ifnull(`充值次数-VIP`,0)                                           AS `充值次数-VIP`
       ,ifnull(`充值次数-旧订阅卡`,0)                                       AS `充值次数-旧订阅卡`
       ,0.5 as `预估订阅ARPU系数`

FROM
(
	SELECT  *
	       ,ROW_NUMBER() over(PARTITION BY 日期,充值来源,策略ID ) row_1
	FROM
	(
		SELECT  ifnull(z5.dt,z6.dt) 日期
		       ,ifnull(z6.策略ID,z5.策略ID) 策略ID
		       ,ifnull(ifnull(z6.策略名称,z5.策略名称),'其他') 策略名称
		       ,ifnull(z6.充值来源,z5.充值来源) 充值来源
		       ,ifnull(z5.曝光UV,0) 曝光UV
		       ,ifnull(z5.曝光PV,0) 曝光PV
		       ,z6.档位类型
		       ,z6.充值档位
		       ,z6.充值人数
		       ,z6.充值次数
		       ,z6.充值金额
		       ,z6.`充值金额-普通充值`
		       ,z6.`充值金额-订阅`
		       ,z6.`充值金额-SVIP`
		       ,z6.`充值金额-VIP`
		       ,z6.`充值金额-福利包`
		       ,z6.`充值金额-旧订阅卡`
		       ,z6.`充值人数-普通充值`
		       ,z6.`充值人数-订阅`
		       ,z6.`充值人数-SVIP`
		       ,z6.`充值人数-VIP`
		       ,z6.`充值人数-福利包`
		       ,z6.`充值人数-旧订阅卡`
		       ,z6.`充值次数-普通充值`
		       ,z6.`充值次数-订阅`
		       ,z6.`充值次数-SVIP`
		       ,z6.`充值次数-VIP`
		       ,z6.`充值次数-福利包`
		       ,z6.`充值次数-旧订阅卡`
		FROM z5
		FULL JOIN z6
		ON z5.dt = z6.dt AND z5.策略ID = z6.策略ID AND z5.充值来源 = z6.充值来源
		HAVING ifnull(z5.dt, z6.dt) is not null AND ifnull(z6.充值来源, z5.充值来源) is not null


	) z12
	LEFT JOIN
	(
			SELECT  CASE WHEN scene_type = 1 THEN '商店'
		             WHEN scene_type = 2 and  pattern_type = 2 then '活动'
                 WHEN scene_type = 2 THEN '半屏'
		             WHEN scene_type = 3 THEN '即冲即消' END AS location
		       ,tactics_id
		       ,sort
               ,max(plan_code) as plan_code
		FROM dim.tag_center_merchandise_tactics_view
        group by 1,2,3
		UNION ALL
		SELECT  CASE WHEN action_type = 9 THEN '充值返回推弹窗'
		             WHEN action_type = 3 THEN '普通弹窗'
                 ELSE '活动' END AS location
		       ,center_activity_id
		       ,sort
               ,max(plan_code) as plan_code
		FROM ads.ads_tidb_short_read_center_activity_position_view a1
        left join  dim.dim_tag_center_activity_view  a2
         on a1.center_activity_id = a2.tactics_id
        group by 1,2,3
	) z112
    on z12.策略ID = z112.tactics_id
    and z12.充值来源 = z112.location
) z13
 where 1=1
  -- AND 策略ID not in  ('720002','1080012' )
  and (充值人数 > 0 or 曝光UV > 20)
  ${if(len(策略名称) == 0,"","and 策略名称 in ('" + 策略名称 + "')")}
  ${if(len(策略代号) == 0,"","and plan_code in ('" + 策略代号 + "')")}
  ${if(len(充值来源) == 0,"","and CASE WHEN 充值来源 = '半屏' AND 策略名称 = '其他' THEN '其他'  ELSE 充值来源 END  in ('" + 充值来源 + "')")}
--  AND 策略ID = '360003'
 -- AND 策略名称  = '其他'
-- AND CASE WHEN 充值来源 = '半屏' AND 策略名称 = '其他' THEN '其他'  ELSE 充值来源 END  = '商店'
  -- AND ifnull(z6.策略ID, z5.策略ID) = 480152

  )
--  AND 策略ID = '360003'
 -- AND 策略名称  = '其他'
-- AND CASE WHEN 充值来源 = '半屏' AND 策略名称 = '其他' THEN '其他'  ELSE 充值来源 END  = '商店'
  -- AND ifnull(z6.策略ID, z5.策略ID) = 480152


select * from ${if(业务线== "海阅","t_book","t_video")}