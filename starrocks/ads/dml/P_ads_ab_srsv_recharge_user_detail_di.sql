----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ab_srsv_recharge_user_detail_di
-- workflow_version : 20
-- create_user      : hufengju
-- task_name        : ads_ab_srsv_recharge_user_detail_di
-- task_version     : 19
-- update_time      : 2025-06-30 15:24:43
-- sql_path         : \starrocks\tbl_ads_ab_srsv_recharge_user_detail_di\ads_ab_srsv_recharge_user_detail_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_ab_srsv_recharge_user_detail_di`
with z1 as (
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
	where  t1.dt>='${bf_1_dt}' and t1.dt<='${dt}'
    and t1.period_type='ctt'
	group by 1,2,3,4,5,6,7,8
), z2 AS
(
	SELECT  t1.dt
	       ,create_time
		   ,product_id
	       ,user_id
	       ,CASE WHEN item_count < 10 THEN concat('00',cast(item_count                                    AS varchar))
	             WHEN item_count < 100 THEN concat('0',cast(item_count AS varchar))  ELSE cast(item_count AS varchar) END item_count
	       ,base_amount/100 base_amount
		   ,real_money
	       ,shop_item
	       ,package_id
	       ,SensorsData
	       ,CASE WHEN regexp(package_id,'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard') THEN '活动'
	             WHEN regexp(package_id,'Ps_HalfLimitFreeCard') THEN '其他'
	             WHEN regexp(package_id,'Ps_Half') THEN '半屏'
	             WHEN regexp(package_id,'Ps_SendCoupon|Ps_ReturnFail|Ps_GiftRewardPop') THEN '半屏' -- 半屏挽留
	             WHEN regexp(package_id,'Ps_Shop_half|Ps_Shop') THEN '商店'
	             WHEN regexp(package_id,'Ps_ReturnRecommend') THEN '返回推弹窗'
	             WHEN regexp(package_id,'Ps_PopInfo') THEN '弹窗' -- TAG弹窗
	             WHEN regexp(package_id,'Ps_Bonus') THEN '商店'
	             WHEN package_id = -99 THEN '空来源'  ELSE '其他' END                                          AS recharge_source
	       ,CASE WHEN regexp(package_id,'Ps_SkipChapter') THEN '跳章解锁'
	             WHEN regexp(package_id,'Ps_H5Shop') THEN 'H5商城'
	             WHEN regexp(package_id,'Ps_ReturnFail') THEN '失败挽留'
	             WHEN regexp(package_id,'Ps_ThirdPay') THEN '三方支付'
	             WHEN regexp(package_id,'Ps_Batch') THEN '批量解锁'
	             WHEN regexp(package_id,'Ps_H5EDMLimitedOffer') THEN 'EDM'  ELSE '其他' END                 AS recharge_source2 -- 部分功能使用了配置的商品策略
	       ,CASE WHEN regexp(package_id,'Ps_ReturnRecommend') THEN coalesce(split(split(package_id,'|')[2],'_')[4] ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4] ) -- 返回推解析活动策略ID
	             WHEN regexp(package_id,'Ps_PopInfo') THEN coalesce(split(split(package_id,'|')[2],'_')[4] ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4] ) -- 弹窗解析活动策略ID
	             ELSE get_json_int(SensorsData,'$.activity_id') END                                       AS activity_id -- 解析神策活动策略（主要是活动充值）
	       ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4]                                       AS dddd
	       ,CASE WHEN regexp(package_id,'Ps_Batch') THEN -1 -- 批量的取package解析
	             ELSE get_json_int(SensorsData,'$.event_strategy_id') END                                 AS strategy_id -- 原始策略ID
	       ,split(split(package_id,'|')[3],'_')[1]                                                        AS strategy_id2 -- 解析package_id策略ID
	       ,CASE WHEN shop_item = 0 THEN '普通充值'
	             WHEN shop_item = 810 THEN 'SVIP'
	             WHEN shop_item IN ( 830,840) THEN '福利包' --
	             WHEN shop_item = 840 THEN '新福利包'
	             WHEN shop_item = 850 THEN 'VIP'
	             WHEN shop_item = 800 THEN '旧订阅卡'  ELSE '其他' END shop_item_type
	       ,get_json_string(cooorder_extinfo,'$.SubscribeStatus') SubscribeStatus
	       ,	case get_json_string(SensorsData,'$.subscription_period')
					when 1 then '周卡' when 2 then '月卡' when 3 then '季卡' when 4 then '年卡' when 5 then '天卡'
					end as item_type
			,SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
		 SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'readerfr.',-1),'minireaderfr.',-1),
				'cdycnovelfr.',-1),'tcreader.',-1),'minireaderft.',-1),'minireaderen.',-1),'ereader.',-1),'readerpt.',-1),'novelpt.',-1) ,'spainreader.',-1),'noveltw.',-1),
				'novelen.',-1),'readerru.',-1),'minireaderes.',-1),'minireaderth.',-1),'readerid.',-1),'thai.',-1),
				'noveles.',-1),'novelru.',-1),'reader4.',-1),'novelth.',-1),'novelid.',-1),'readerja.',-1),'novelja.',-1)
				as item_id
			,case subpay_type when 'AppStore' then 'IOS' when 'GooglePlay' then '安卓' else '三方支付' end as subpay_type
			,ifnull(corever,-99) as core
			,ifnull(mt,-99) as mt
	FROM ads.ads_trade_user_payorder_view t1
	WHERE test_flag = 0
	AND t1.dt>='${bf_1_dt}' and t1.dt<='${dt}'
	-- AND regexp(package_id, 'Ps_ReturnRecommend')
), z3 AS
(
	SELECT  z2.dt
	       ,create_time
	       ,z2.user_id
		   ,z2.product_id
	       ,item_count
	       ,base_amount
		   ,real_money
	       ,shop_item
		   ,case
			when item_type='天卡' and t3.subscription_days  is not null  then t3.subscription_days
			when item_type is null and shop_item IN (800,810,830,840,850) and t2.vip_type is not null then t2.vip_type
			when item_type is null and shop_item IN (800,810,830,840,850) and t2.vip_type is null then '周卡'
				else item_type end as item_type
	       ,CASE WHEN recharge_source = '半屏' AND strategy_id = -1 AND strategy_id2 IN (2,930084) THEN '商店' -- 一般-1的情况都是商店的策略 + 强转商店
	             WHEN strategy_id = 2 THEN '商店' -- 一般2的情况都是商店的策略
	             ELSE recharge_source END                                                           AS recharge_source
	       ,recharge_source2
	       ,activity_id
	       ,strategy_id
	       ,strategy_id2
	       ,shop_item_type
	       ,SubscribeStatus
	       ,CASE WHEN recharge_source = '半屏' AND strategy_id > 0 THEN strategy_id
	             WHEN recharge_source = '半屏' AND (strategy_id = -1 or strategy_id is null or strategy_id = -99) AND strategy_id2 > 0 THEN strategy_id2
	             WHEN recharge_source = '商店' AND strategy_id > 0 THEN strategy_id
	             WHEN recharge_source = '商店' AND (strategy_id = -1 or strategy_id is null or strategy_id = -99) AND strategy_id2 > 0 THEN strategy_id2
	             WHEN recharge_source = '活动' THEN activity_id
	             WHEN recharge_source = '返回推弹窗' AND activity_id > 0 THEN activity_id
	             WHEN recharge_source = '弹窗' AND activity_id > 0 THEN activity_id
	             WHEN recharge_source = '弹窗' AND activity_id = 8684412 THEN 8713442
	             WHEN recharge_source = '弹窗' AND activity_id = 8684413 THEN 8713445
	             WHEN recharge_source = '其他' AND activity_id > 0 THEN activity_id
	             WHEN recharge_source = '其他' AND strategy_id > 0 THEN strategy_id
	             WHEN recharge_source = '其他' AND strategy_id2 > 0 THEN strategy_id2
	             WHEN recharge_source = '空来源' AND activity_id > 0 THEN activity_id
	             WHEN recharge_source = '空来源' THEN coalesce(strategy_id,strategy_id2)  ELSE -99 END AS event_strategy_id
	       ,CASE WHEN recharge_source = '商店' THEN 1
	             WHEN recharge_source = '半屏' AND strategy_id = -1 AND strategy_id2 IN (2,930084) THEN 1
	             WHEN strategy_id = 2 THEN 1
	             WHEN recharge_source = '半屏' THEN 2  ELSE 3 END                                     AS recharge_scene_type
	       ,package_id
	       ,SensorsData
		   ,subpay_type
		   ,z2.core
		   ,z2.mt
	FROM z2
	left join (
		select  item_id ,
		case when if(max(validity)=107,107,min(validity))=1 then '月卡'
			 when if(max(validity)=107,107,min(validity))=3 then '季卡'
			 when if(max(validity)=107,107,min(validity))=12 then '年卡'
			 when if(max(validity)=107,107,min(validity))=107 then '周卡'
			 else '非会员卡' end as vip_type
		from dim.dim_trade_pay_item_info_view
		where merchandise_type in  (800,810,830,840,850)
			and status=1 and is_delete=0
			and product_id <> 3399   -- 商品库表存在日语存在测试数据，单独清洗
		group by 1
	) t2 on z2.item_id = t2.item_id
	left join
	(
		select dt,app_product_id as product_id,identity_login_id as user_id,recharge_type,real_recharge*100 as real_recharge,concat(SUBSTRING_INDEX(subscription_days,'.',1),'天卡') as subscription_days
		from ads.ads_sensors_production_ordersuccess_view
		where dt>='${bf_1_dt}' and dt<='${dt}'
		and recharge_type>0
		group by 1,2,3,4,5,6
	) t3 on z2.dt=t3.dt and  z2.product_id=t3.product_id and z2.user_id=t3.user_id and t3.recharge_type = z2.shop_item and t3.real_recharge = z2.real_money
)
,
z4 AS
(
	SELECT  z3.dt
	       ,z3.create_time
	       ,z3.user_id
	       ,z3.item_count
	       ,z3.base_amount
	       ,z3.shop_item
		   ,z3.item_type
	       ,z3.recharge_source
	       ,z3.recharge_source2 -- 归因跳章解锁/失败挽留等
	       ,SubscribeStatus
	       ,CASE WHEN SubscribeStatus = 2 AND shop_item_type <> '普通充值' THEN '续订(或策略id为空)'
	             WHEN recharge_source = '半屏' AND t1.tactics_name is null AND t3.tactics_name is not null THEN '商店'
	             WHEN recharge_source = '半屏' AND t1.pattern_type = 2 THEN '活动' -- 半屏使用活动专区归为活动
	             WHEN recharge_source = '半屏' AND strategy_id2 = 2 AND strategy_id <> 7 THEN '商店' -- 半屏引用商店策略（2)
	             WHEN recharge_source2 = '失败挽留' AND coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name) is null THEN '其他' -- 半屏, 取不到策略
	             WHEN recharge_source = '空来源' AND recharge_source2 <> '其他' THEN recharge_source2
	             WHEN recharge_source = '空来源' AND t3.tactics_name is not null THEN '商店'
	             WHEN recharge_source = '空来源' AND t4.tactics_name is not null THEN '半屏'
	             WHEN recharge_source = '空来源' AND coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) = '其他' THEN '续订(或策略id为空)'
          ELSE recharge_source END AS recharge_source3 -- 处理半屏引用商店策略
	       ,z3.activity_id
	       ,z3.strategy_id
	       ,z3.strategy_id2
	       ,z3.shop_item_type
	       ,z3.event_strategy_id
	       ,t1.tactics_name                     AS tactics_name1
	       ,t2.tactics_name                     AS tactics_name2
	       ,t3.tactics_name                     AS tactics_name3
	       ,t4.tactics_name                     AS tactics_name4
	       ,CASE WHEN SubscribeStatus = 2 AND shop_item_type <> '普通充值' THEN '续订'
	             WHEN recharge_source = '空来源' AND coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) = '其他' THEN '策略ID为空'  ELSE coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) END AS tactics_name_
	       ,if(t1.pattern_type = 2,'活动专区','其他') AS `半屏档位模式`
              ,package_id
	       ,SensorsData
		   ,z3.subpay_type
		   ,z3.core
		   ,z3.mt
		FROM  z3
		LEFT JOIN dim.tag_center_merchandise_tactics_view t1 -- 半屏/商店取策略
		ON z3.recharge_scene_type = t1.scene_type AND z3.event_strategy_id = t1.tactics_id AND concat( t1.scene_type, '-', t1.tactics_id) NOT IN ('2-360003', '2-330011', '2-330010', '2-330012', '2-480053')
		LEFT JOIN dim.dim_tag_center_activity_view t2 -- 活动策略
		ON z3.activity_id = t2.tactics_id
		LEFT JOIN dim.tag_center_merchandise_tactics_view t3 -- 其他位置取了商店的策略
		ON z3.recharge_scene_type IN (2, 3) -- 3
	 AND t3.scene_type = 1 AND z3.event_strategy_id = t3.tactics_id
		LEFT JOIN dim.tag_center_merchandise_tactics_view t4 -- 补异常半屏数据
		ON z3.recharge_scene_type IN (2, 3) -- 3
	 AND t4.scene_type = 2 AND z3.event_strategy_id = t4.tactics_id
), z5 AS
(
	SELECT  dt
	       ,coalesce(recharge_source3,'其他') AS recharge_source3 -- 充值来源 -- 过滤活跃未充值用户
		   ,b.ab_id as exp_id
		   ,b.version_id as exp_grp_id
		   ,c.exp_grp_ver_id
		   ,c.exp_grp_type
	       ,event_strategy_id               AS  event_strategy_id -- 策略ID
	       ,tactics_name_                   AS strategy_name -- 策略名称
	       ,shop_item_type                  AS shop_item_type  -- 档位类型
	       ,item_count                      AS item_count --充值档位
		   ,item_type
		   ,subpay_type
		   ,core
		   ,mt
	       ,user_id                         AS user_id
         ,create_time
	       ,sum(base_amount) as base_amount
         ,max(package_id) package_id
	       ,max(SensorsData) as SensorsData
	FROM z4
	inner join ods.ods_ab_hj_related b  on z4.event_strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  z4.create_time >= c.exp_start_time and c.exp_end_time>z4.create_time
			and z4.create_time >= c.start_time and c.end_time>z4.create_time
  group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
) ,
z7 AS
(
	select
		b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,c.exp_grp_type,
		a.dt,a.recharge_source3,a.event_strategy_id,a.core,a.mt,a.user_id,
		COUNT(distinct left(a.event_tm,18))  AS exposure_pv,
		MAX(strategy_name) as strategy_name,
		max(exp_element_id) as `exp_element_id`
	from (
		SELECT  dt
			   ,CASE WHEN element_id = '100708' AND t1.pattern_type = 2 THEN '活动'
					 WHEN element_id = '100708' AND t2.tactics_id > 2 AND event_strategy_id NOT IN (690001,720001,510001,540001) THEN '活动'
					 WHEN element_id IN ('100708','100338','100337','100707','100401') AND t0.event_strategy_id IN (2,930084) THEN '商店'
					 WHEN element_id IN (100284) THEN '活动'
					 WHEN element_id = '100708' AND element_type IN (0,-1) THEN '半屏'
					 WHEN element_id IN ('100338','100337','100707') AND t1.pattern_type = 2 THEN '活动'
					 WHEN element_id IN ('100338','100337','100707') THEN '半屏'
					 WHEN element_id IN (100024,100025,100126,100365,100120) THEN '商店'
					 WHEN element_id IN (100031) THEN '商店'
					 WHEN element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN '返回推弹窗'
					 WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN '弹窗'  ELSE '其他' END AS recharge_source3
			   ,CASE WHEN element_id = '100708' AND element_type IN (0,-1) THEN event_strategy_id
					 WHEN element_id IN (100024,100025,100126,100365) THEN event_strategy_id
					 WHEN element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN split(pay_link,'_')[4]
					 WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' AND split(pay_link,'_')[4] = 8684412 THEN 8713442
					 WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' AND split(pay_link,'_')[4] = 8684413 THEN 8713445
					 WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN split(pay_link,'_')[4]
					 WHEN event_strategy_id > 0 THEN event_strategy_id  ELSE t0.activity_id END               AS event_strategy_id -- 策略ID
				,ifnull(app_core_ver,-99) as core
				,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
			   ,coalesce(identity_user_id,login_id)                                                           AS user_id
			   ,event_tm                                                          	 AS event_tm
			   ,coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name)                               AS strategy_name -- `策略名称`
			 ,(element_id) as `exp_element_id`
		FROM ads.ads_sensors_production_rechargeexposure_view t0
		LEFT JOIN dim.tag_center_merchandise_tactics_view t1 -- 半屏/商店取策略
		ON t0.element_id IN ('100708', '100338', '100337', '100707')
				  AND t1.scene_type = 2 AND t0.event_strategy_id = t1.tactics_id
				  AND concat( t1.scene_type, '-', t1.tactics_id) NOT IN ('2-360003', '2-330011', '2-330010', '2-330012', '2-480053', '2-30003', '2-2')
		LEFT JOIN dim.dim_tag_center_activity_view t2 -- 活动策略
		ON (case WHEN element_id = '100400' AND split(pay_link, '_')[1] = 'returnrecommend' THEN split(pay_link, '_')[4]
					WHEN element_id = '100390' AND split(pay_link, '_')[1] = 'popup' AND split(pay_link, '_')[4] = 8684412 THEN 8713442
					WHEN element_id = '100390' AND split(pay_link, '_')[1] = 'popup' AND split(pay_link, '_')[4] = 8684413 THEN 8713445
					WHEN element_id = '100390' AND split(pay_link, '_')[1] = 'popup' THEN split(pay_link, '_')[4]
					WHEN event_strategy_id > 0 THEN event_strategy_id ELSE t0.activity_id end ) = t2.tactics_id
				  AND date(t2.begin_time) <> '0001-01-01'
		LEFT JOIN dim.tag_center_merchandise_tactics_view t3 -- 商店取策略
		ON t3.scene_type = 1 AND t0.event_strategy_id = t3.tactics_id
		WHERE	t0.dt>='${bf_1_dt}' and t0.dt<='${dt}'
			AND project_id = 5
			AND element_id NOT IN ('100647', '100651', '100107')
	) a
	inner join ods.ods_ab_hj_related b  on a.event_strategy_id = b.strategy_id
	inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
		and a.event_tm >= c.start_time and c.end_time>a.event_tm
	group by 1,2,3,4,5,6,7,8,9,10
)
, z8 AS -- 广告收入
(
	SELECT
			b.ab_id as exp_id,b.version_id as exp_grp_id,c.exp_grp_ver_id,c.exp_grp_type
			,dt
	       ,user_id
	       ,a.strategy_id as event_strategy_id
	       ,core
	       ,mt
	       ,SUM(PV)     AS ad_PV
	       ,SUM(AMOUNT) AS ad_amount
	FROM
	(
		SELECT  dt
		       ,split(main_strategy_id,'_')[1] AS strategy_id
		       ,login_id                       AS user_id
			   ,ifnull(app_core_ver,-99) as core
			   ,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
			   ,event_tm
		       ,1                              AS `PV`
		       ,0                              AS `AMOUNT`
		FROM ads.ads_sensors_production_ad_position_exposure_view
		WHERE dt>='${bf_1_dt}' and dt<='${dt}'
		AND main_strategy_id is not null
		AND ad_position_id IN (18, 62)
		UNION ALL
		SELECT  dt
		       ,split(main_strategy_id,'_')[1] AS strategy_id
		       ,login_id
			   ,ifnull(app_core_ver,-99) as core
			   ,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
			   ,event_tm
		       ,1                              AS `PV`
		       ,0                              AS `AMOUNT`
		FROM ads.ads_sensors_production_element_expose_view
		WHERE dt>='${bf_1_dt}' and dt<='${dt}'
		AND element_id = '100356'
		AND ad_position_id = 18
		AND main_strategy_id is not null
		UNION ALL
		SELECT  dt
		       ,split(main_strategy_id,'_')[1]                                                                                               AS strategy_id
		       ,login_id
			   ,ifnull(app_core_ver,-99) as core
			   ,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
			   ,event_tm
		       ,0                                                                                                                            AS `PV`
		       ,CASE WHEN os IN ('4','Android','HarmonyOS') AND ad_platform = 'AdMob' THEN ad_revenue/10000000000  ELSE ad_revenue/10000 END AS `AMOUNT`
		FROM ads.ads_sensors_production_ad_revenue_action_view
		WHERE dt>='${bf_1_dt}' and dt<='${dt}'
		AND main_strategy_id is not null
		AND ad_position_id IN (18, 62)
		UNION ALL
		select t1.dt,t1.strategy_id,t1.user_id,t1.core,t1.mt,t1.event_tm,t1.PV,t2.H5peramount  AS amount
		from (
			SELECT  t1.dt
				   ,split(main_strategy_id,'_')[1] AS strategy_id
				   ,login_id                       AS user_id
				   ,event_tm
				   ,ifnull(app_core_ver,-99) as core
				   ,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
				   ,0                              AS PV
				   --,H5peramount                    AS amount
			FROM ads.ads_sensors_production_element_click_view t1
			WHERE t1.dt>='${bf_1_dt}' and t1.dt<='${dt}'
			AND element_id = '100356'
			AND ad_position_id = 18
			AND main_strategy_id is not null
		) t1
		LEFT JOIN
		(
			SELECT  dt
					,ifnull(core,-99) as core
					,ifnull(mt,-99)  as mt
			       ,SUM(amt)/SUM(cnt ) AS H5peramount
			FROM dws.dws_advertisement_user_position_amt_ed
			WHERE dt>='${bf_1_dt}' and dt<='${dt}'
			AND positions = '59'
			GROUP BY 1,2,3
		) t2
		ON t1.dt = t2.dt and t1.core=t2.core and t1.mt=t2.mt
	) a
	inner join ods.ods_ab_hj_related b  on a.strategy_id = b.strategy_id
		inner join dwd.dwd_ab_exp_version_detail c on b.ab_id = c.exp_id and b.version_id=c.exp_grp_id and  a.event_tm >= c.exp_start_time and c.exp_end_time>a.event_tm
			and a.event_tm >= c.start_time and c.end_time>a.event_tm
	GROUP BY  1,2,3,4,5,6,7,8,9
),
z9 AS (
	SELECT  *
		   ,ROW_NUMBER() over(PARTITION BY dt,user_id,exp_id,exp_grp_id,exp_grp_ver_id,recharge_source3,event_strategy_id,core,mt ) row_1
	FROM
	(
		SELECT  ifnull(z5.dt,z7.dt)                  AS dt -- `日期`
			   ,ifnull(z5.user_id,z7.user_id)        AS user_id
			   ,ifnull(z5.exp_id,z7.exp_id)        AS exp_id
			   ,ifnull(z5.exp_grp_id,z7.exp_grp_id)        AS exp_grp_id
			   ,ifnull(z5.exp_grp_ver_id,z7.exp_grp_ver_id)        AS exp_grp_ver_id
			   ,ifnull(z5.exp_grp_type,z7.exp_grp_type)        AS exp_grp_type
			   ,ifnull(z5.recharge_source3,z7.recharge_source3)      AS recharge_source3 --充值来源
			   ,ifnull(z5.event_strategy_id,z7.event_strategy_id)        AS event_strategy_id -- 策略ID
			   ,ifnull(ifnull(z5.strategy_name,z7.strategy_name),'其他') AS strategy_name -- 策略名称
			   ,ifnull(z7.exposure_pv,0)                    AS exposure_pv -- 曝光PV
			   ,z5.shop_item_type -- 档位类型
			   ,z5.item_count --充值档位
			   ,z5.item_type
			   ,z5.subpay_type
			   ,ifnull(z5.core,z7.core) as core
			   ,ifnull(z5.mt,z7.mt) as mt
			   ,z5.user_id                             AS recharge_user_id  -- 充值user_id  -- 没充值的是空
			   ,z5.base_amount                         AS base_amount --`充值金额`
			   ,z8.ad_PV                             AS ad_PV --`广告曝光PV`
			   ,z8.ad_amount                         AS ad_amount --`广告收入`
			 ,package_id
			   ,SensorsData
			 ,exp_element_id
		FROM z5
		FULL JOIN z7
		ON z7.dt = z5.dt
			 AND z7.user_id = z5.user_id
			 AND z7.exp_id = z5.exp_id
			 AND z7.exp_grp_id = z5.exp_grp_id
			 AND z7.exp_grp_ver_id = z5.exp_grp_ver_id
			 AND z7.event_strategy_id = z5.event_strategy_id
			 AND z7.recharge_source3 = z5.recharge_source3
			 and z5.core = z7.core
			 and z5.mt = z7.mt
		LEFT JOIN z8
		ON z7.dt = z8.dt
			 AND z7.user_id = z8.user_id
			 AND z7.exp_id = z8.exp_id
			 AND z7.exp_grp_id = z8.exp_grp_id
			 AND z7.exp_grp_ver_id = z8.exp_grp_ver_id
			 AND z7.event_strategy_id = z8.event_strategy_id
			 AND z7.recharge_source3 = '半屏'
			 and z8.core = z7.core
			 and z8.mt = z7.mt
	) a0
),
z10 AS (
	SELECT dt -- `日期`
		   ,user_id
		   ,exp_id
		   ,exp_grp_id
		   ,exp_grp_ver_id
		   ,recharge_source3 as recharge_source--`充值来源`
		   ,event_strategy_id -- `策略ID`
		   ,strategy_name --`策略名称`
		   ,row_1
		   ,exp_grp_type
		   ,if(row_1 = 1 ,exposure_pv,0)  AS exposure_pv --`策略曝光PV`
		   ,if(row_1 = 1 ,ad_PV,0)  ad_exposure_pv -- `广告曝光PV`
		   ,shop_item_type -- `档位类型`
		   ,item_count -- `充值档位`
		   ,item_type
		   ,subpay_type
		   ,core
		   ,mt
		   ,recharge_user_id --`充值user_id`
		   ,base_amount -- `充值金额`
		  ,if(row_1 = 1 ,ad_amount,0)   ad_amount -- `广告收入`
		  ,package_id
			,SensorsData
		  ,exp_element_id
	FROM z9
)
,
-- 分流、策略命中人数
z11 as (
	select
		a.dt,a.exp_id,a.exp_grp_id,a.exp_grp_ver_id,b.version_type as exp_grp_type,user_id,max(divideTrafficUser) as divideTrafficUser,max(strategyHitUser) as strategyHitUser
	from (
		select a.dt,a.exp_id,a.exp_grp_id,a.exp_grp_ver_id,a.user_id,a.user_id as divideTrafficUser,null as strategyHitUser
		from dwd.dwd_ab_exp_user_detail_di a
		left join ods.ods_ab_hj_related b on a.exp_id =b.ab_id and b.version_id = a.exp_grp_id
		where a.dt>='${bf_1_dt}' and a.dt<='${dt}' and  b.project_id=1
		group by 1,2,3,4,5,6
	union all
		select a.dt,a.exp_id,a.exp_grp_id,a.exp_grp_ver_id,a.user_id,null as divideTrafficUser,a.user_id as strategyHitUser
		from dwm.dwm_ab_exp_strategy_hit_user_di a
		left join ods.ods_ab_hj_related b on a.exp_id =b.ab_id and b.version_id = a.exp_grp_id
		where a.dt>='${bf_1_dt}' and a.dt<='${dt}' and  b.project_id=1
		group by 1,2,3,4,5,6
	) a
	left join ods.syncbi_ab_experiment_versions b on a.exp_id=b.experiment_id  and a.exp_grp_id=b.version_number
	group by 1,2,3,4,5,6
)
select
	coalesce(z10.dt,z11.dt) as dt
	,1 as project_id
	,coalesce(z10.exp_id,z11.exp_id) as exp_id
	,coalesce(z10.exp_grp_id,z11.exp_grp_id) as exp_grp_id
	,coalesce(z10.exp_grp_ver_id,z11.exp_grp_ver_id) as exp_grp_ver_id
	,ifnull(z10.event_strategy_id,-99) as strategy_id
	,ifnull(z10.recharge_source,-99) as recharge_source
	,coalesce(z10.user_id,z11.user_id) as user_id
	,ifnull(z10.mt,-99) as mt
	,ifnull(z10.core,-99) as core
	,ifnull(z10.row_1,-99) as row_1
    ,coalesce(z10.exp_grp_type,z11.exp_grp_type) as exp_grp_type
	,z10.shop_item_type as shop_item_type
	,z10.item_count as item_count
	,z10.item_type as item_type
	,z10.subpay_type as subpay_type
	,z10.strategy_name as strategy_name
	,z1.user_type as user_type
	,z1.remarks as put_language
	,z1.country_level as country_level
	,ifnull(z10.exposure_pv,0) as exposure_pv
	,ifnull(z10.ad_exposure_pv,0) as ad_exposure_pv
	,z10.recharge_user_id as recharge_user_id
	,ifnull(z10.base_amount,0) as recharge_amount
	,ifnull(z10.ad_amount,0) as ad_amount
	,null as sv_last_preload_ecpm
	,null as recharge_mode
	,z11.divideTrafficUser
	,z11.strategyHitUser
	,now() as etl_ime
 from z10
inner join  z1 on z1.dt=z10.dt and z1.user_id = z10.user_id
full join z11 on z10.dt=z11.dt and z10.exp_id=z11.exp_id and z10.exp_grp_id=z11.exp_grp_id and z10.exp_grp_ver_id=z11.exp_grp_ver_id and z10.user_id=z11.user_id
;
