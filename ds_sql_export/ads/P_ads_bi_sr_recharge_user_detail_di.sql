----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sr_recharge_user_detail_di
-- workflow_version : 47
-- create_user      : hufengju
-- task_name        : ads_bi_sr_recharge_user_detail_di
-- task_version     : 27
-- update_time      : 2025-12-24 15:03:25
-- sql_path         : \starrocks\tbl_ads_bi_sr_recharge_user_detail_di\ads_bi_sr_recharge_user_detail_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_sr_recharge_user_detail_di`
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
	group by 1,2,3,4,5,6,7,8
), z2 AS
(
	SELECT  t1.dt
	       ,create_time
	       ,user_id
	       ,CASE WHEN item_count < 10 THEN concat('00',cast(item_count                                    AS varchar))
	             WHEN item_count < 100 THEN concat('0',cast(item_count AS varchar))  ELSE cast(item_count AS varchar) END item_count
	       ,base_amount/100 base_amount
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
	             WHEN shop_item = 860 THEN 'NSVIP'
	             WHEN shop_item = 800 THEN '旧订阅卡'  ELSE '其他' END shop_item_type
	       ,get_json_string(cooorder_extinfo,'$.SubscribeStatus') SubscribeStatus
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
	SELECT  dt
	       ,create_time
	       ,user_id
	       ,item_count
	       ,base_amount
	       ,shop_item
		   ,t2.vip_type as item_type
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
		   ,z2.subpay_type
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
		where merchandise_type in  (800,810,830,840,850,860)
			and status=1 and is_delete=0
			and product_id <> 3399   -- 商品库表存在日语存在测试数据，单独清洗
		group by 1
	) t2 on z2.item_id = t2.item_id
),
z3_1 as (
	select
		z3.*,t.item_type,ifnull(coalesce(z3.item_type,t.item_type),case when base_amount<13 and shop_item>0 then '周卡' when base_amount>=13 and shop_item>0 then '月卡' end ) as item_type2
		--distinct cast (SUBSTRING_INDEX(t.subscription_days,'.',1) as int) as subscription_days
	from z3
	left join (
		select
		dt,identity_login_id,ifnull(pay_source,-99) as pay_source,recharge_type,
		min(case when  cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)>0 and cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)<20 then '周卡'
			when  cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)>=20 and cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)<80 then '月卡'
			when  cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)>=80 and cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)<300 then '季卡'
			when  cast (SUBSTRING_INDEX(subscription_days,'.',1) as int)>=300  then '年卡'
			end ) as item_type
		from ods_log.ods_sensors_cd_video_production_ordersuccess
		where project_id=5
		and dt>='${bf_1_dt}' and dt<='${dt}'
		and recharge_type>0
		group by 1,2,3,4
	) t on z3.dt=t.dt and z3.user_id=t.identity_login_id and z3.package_id = t.pay_source and z3.shop_item=t.recharge_type
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
		   ,z3.item_type2 as item_type
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
		FROM z3_1 as z3
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
  group by 1,2,3,4,5,6,7,8,9,10,11,12
) ,
z7 AS
(
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
	       ,COUNT(distinct left(event_tm,18))                                                             AS exposure_pv -- `曝光PV`
	       ,MAX(coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name))                                AS strategy_name -- `策略名称`
         ,max(element_id) as `exp_element_id`
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
	ON t3.scene_type = 1
              AND t0.event_strategy_id = t3.tactics_id
	WHERE	t0.dt>='${bf_1_dt}' and t0.dt<='${dt}'
	AND project_id = 5
	AND element_id NOT IN ('100647', '100651', '100107')
	GROUP BY  1,2,3,4,5,6
)
, z8 AS -- 广告收入
(
	SELECT  dt
	       ,user_id
	       ,strategy_id as event_strategy_id
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
		       ,0                                                                                                                            AS `PV`
		       ,CASE WHEN os IN ('4','Android','HarmonyOS') AND ad_platform = 'AdMob' THEN ad_revenue/10000000000  ELSE ad_revenue/10000 END AS `AMOUNT`
		FROM ads.ads_sensors_production_ad_revenue_action_view
		WHERE dt>='${bf_1_dt}' and dt<='${dt}'
		AND main_strategy_id is not null
		AND ad_position_id IN (18, 62)
		UNION ALL
		select t1.dt,t1.strategy_id,t1.user_id,t1.core,t1.mt,t1.PV,t2.H5peramount  AS amount
		from (
			SELECT  t1.dt
				   ,split(main_strategy_id,'_')[1] AS strategy_id
				   ,login_id                       AS user_id
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
	) zad
	GROUP BY  1,2,3,4,5
),
z9 AS (
	SELECT  *
		   ,ROW_NUMBER() over(PARTITION BY dt,user_id,recharge_source3,event_strategy_id,core,mt ) row_1
	FROM
	(
		SELECT  ifnull(z5.dt,z7.dt)                  AS dt -- `日期`
			   ,ifnull(z5.user_id,z7.user_id)        AS user_id
			   ,ifnull(z5.recharge_source3,z7.recharge_source3)      AS recharge_source3 --充值来源
			   ,ifnull(z5.event_strategy_id,z7.event_strategy_id)              AS event_strategy_id -- 策略ID
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
			 AND z7.event_strategy_id = z5.event_strategy_id
			 AND z7.recharge_source3 = z5.recharge_source3
			 and z5.core = z7.core
			 and z5.mt = z7.mt
		LEFT JOIN z8
		ON z7.dt = z8.dt
			 AND z7.user_id = z8.user_id
			 AND z7.event_strategy_id = z8.event_strategy_id
			 AND z7.recharge_source3 = '半屏'
			 and z8.core = z7.core
			 and z8.mt = z7.mt
	) a0
),
z10 AS (
	SELECT dt -- `日期`
		   ,user_id
		   ,recharge_source3 as recharge_source--`充值来源`
		   ,event_strategy_id -- `策略ID`
		   ,strategy_name --`策略名称`
		   ,row_1
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
select
	z10.dt
	,z1.period_type
	,ifnull(z10.event_strategy_id,-99) as event_strategy_id
	,ifnull(z10.recharge_source,-99) as recharge_source
	,z10.user_id
	,z10.mt
	,z10.core
	,z10.row_1
	,z10.shop_item_type
	,z10.item_count
	,item_type
	,z10.subpay_type
	,z10.strategy_name
	,z1.user_type
	,z1.remarks as put_language
	,z1.country_level
	,z10.exposure_pv
	,z10.ad_exposure_pv
	,z10.recharge_user_id
	,z10.base_amount as recharge_amount
	,z10.ad_amount
	,z10.package_id
	,z10.SensorsData
    ,z10.exp_element_id
	,now() as etl_ime
 from z10
inner join  z1 on z1.dt=z10.dt and z1.user_id = z10.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sr_recharge_user_detail_di
-- workflow_version : 47
-- create_user      : hufengju
-- task_name        : ads_bi_sr_recharge_user_detail_di_v1
-- task_version     : 21
-- update_time      : 2025-12-24 15:03:25
-- sql_path         : \starrocks\tbl_ads_bi_sr_recharge_user_detail_di\ads_bi_sr_recharge_user_detail_di_v1
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_sr_recharge_user_detail_di`
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
	       ,CASE WHEN regexp(package_id,'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard|CombinAct') THEN '活动'
	             WHEN regexp(package_id,'Ps_HalfLimitFreeCard') THEN '其他'
	             WHEN regexp(package_id,'Ps_Half|Ps_PWAHalf') THEN '半屏'
	             WHEN regexp(package_id,'Ps_SendCoupon|Ps_ReturnFail|Ps_GiftRewardPop|Ps_MulityChapterVip') THEN '半屏' -- 半屏挽留
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
	             WHEN shop_item = 860 THEN 'NSVIP'
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
			,seconds_diff(t2.FinishTime,t1.create_time) as finish_time
	FROM ads.ads_trade_user_payorder_view t1
	left join (
		select OrderSerialId,FinishTime  from ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di where ProductId != 6833
	) t2 on t1.order_id= t2.OrderSerialId
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
			when item_type is null and shop_item IN (800,810,830,840,850,860) and t2.vip_type is not null then t2.vip_type
			when item_type is null and shop_item IN (800,810,830,840,850,860) and t2.vip_type is null then '周卡'
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
			,finish_time
	FROM z2
	left join (
		select  item_id ,
		case when if(max(validity)=107,107,min(validity))=1 then '月卡'
			 when if(max(validity)=107,107,min(validity))=3 then '季卡'
			 when if(max(validity)=107,107,min(validity))=12 then '年卡'
			 when if(max(validity)=107,107,min(validity))=107 then '周卡'
			 else '非会员卡' end as vip_type
		from dim.dim_trade_pay_item_info_view
		where merchandise_type in  (800,810,830,840,850,860)
			and status=1 and is_delete=0
			and product_id <> 3399   -- 商品库表存在日语存在测试数据，单独清洗
		group by 1
	) t2 on z2.item_id = t2.item_id
	left join
	(
		select
		dt,app_product_id as product_id,identity_login_id as user_id,recharge_type,recharge_amount as recharge_amount,concat(max(SUBSTRING_INDEX(subscription_days,'.',1)),'天卡') as subscription_days
		from ads.ads_sensors_production_ordersuccess_view
		where dt>='${bf_1_dt}' and dt<='${dt}'
		and recharge_type>0
		group by 1,2,3,4,5
	) t3 on z2.dt=t3.dt and  z2.product_id=t3.product_id and z2.user_id=t3.user_id and t3.recharge_type = z2.shop_item and t3.recharge_amount = z2.real_money
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
		   ,z3.finish_time
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
), z4_1 AS
(
	SELECT  dt
	       ,coalesce(recharge_source3,'其他') AS recharge_source3 -- 充值来源 -- 过滤活跃未充值用户
	       ,event_strategy_id               AS  event_strategy_id -- 策略ID
	       ,tactics_name_                   AS strategy_name -- 策略名称
	       ,shop_item_type                  AS shop_item_type  -- 档位类型
	       ,item_count                      AS item_count --充值档位
		   ,item_type
		   ,subpay_type
		   ,core
		   ,mt
	       ,user_id                         AS user_id
         --,create_time
	       ,sum(base_amount) as base_amount
		   ,count(1) as recharge_order_num
		   ,avg(finish_time) as finish_time
         ,max(package_id) package_id
	       ,max(SensorsData) as SensorsData
	FROM z4
  group by 1,2,3,4,5,6,7,8,9,10,11
)
,
-- 创建订单事件
t4 as (
	select
		CASE WHEN element_id = '100390' THEN '弹窗'
             WHEN element_id = '100352' THEN '其他'
             WHEN element_id in('100400', '202100') THEN '返回推弹窗'
             WHEN element_id = '100284' THEN '活动'
             WHEN element_id IN  ('100708','100337','200900') THEN '半屏'
             WHEN element_id IN ( 100024,100025,100026,100121,100120 ) THEN '商店'  ELSE '其他' END               AS `recharge_source`,
		case
		 when cast(real_recharge as float)<10 then concat('00',real_recharge )
		 when  cast(real_recharge as float)<100 then concat('0',real_recharge)
		 else real_recharge end item_count,
		CASE WHEN element_id IN ('100390','100352','100400','100284') THEN activity_id  ELSE event_strategy_id END AS event_strategy_id,
		CASE WHEN recharge_type = 0 THEN '普通充值'
             WHEN recharge_type = 810 THEN 'SVIP'
             WHEN recharge_type IN ( 830,840) THEN '福利包' --
             WHEN recharge_type = 840 THEN '新福利包'
             WHEN recharge_type = 850 THEN 'VIP'
             WHEN recharge_type = 860 THEN 'NSVIP'
             WHEN recharge_type = 800 THEN '旧订阅卡'  ELSE '其他' END shop_item_type,
		coalesce(login_id,cast(distinct_id as int)) user_id,
		ifnull(app_core_ver,-99) as core,
		ifnull(os,-99) as mt,
		-- event_tm,
		dt,
		zffs as subpay_type,
	  count(1) as create_order_num
	from ads.ads_sensors_production_ordercreateaction_view
	where  dt>='${bf_1_dt}' and dt<='${dt}'
		AND element_id NOT IN ('100647', '100651', '100107')
	group by 1,2,3,4,5,6,7,8,9
)
,
z5 as (
	select
		coalesce(t4.dt,z4_1.dt) dt
		,coalesce(t4.recharge_source,z4_1.recharge_source3,'其他') AS recharge_source3 -- 充值来源
		,coalesce(t4.event_strategy_id,z4_1.event_strategy_id) event_strategy_id  -- 策略ID
		,z4_1.strategy_name 	-- -- 策略名称
		,coalesce(t4.shop_item_type,z4_1.shop_item_type) shop_item_type  -- 档位类型
		,coalesce(t4.item_count,z4_1.item_count) item_count --充值档位
		,z4_1.item_type
		,coalesce(t4.subpay_type,z4_1.subpay_type) subpay_type
		,coalesce(t4.core,z4_1.core) core
		,coalesce(t4.mt,z4_1.mt) mt
		,coalesce(t4.user_id,z4_1.user_id) user_id
		,z4_1.base_amount as base_amount
		,z4_1.recharge_order_num as recharge_order_num
		,z4_1.finish_time as finish_time
		,z4_1.package_id as package_id
		,z4_1.SensorsData as SensorsData
		,t4.create_order_num as create_order_num
	from t4
	full join z4_1 on t4.dt=z4_1.dt and t4.recharge_source = z4_1.recharge_source3 and t4.event_strategy_id and z4_1.event_strategy_id and t4.shop_item_type = z4_1.shop_item_type
			and t4.item_count = z4_1.item_count and t4.subpay_type = z4_1.subpay_type and t4.core = z4_1.core and t4.mt = z4_1.mt and t4.user_id = z4_1.user_id

)
,
z7 AS
(
	SELECT  dt
	       ,CASE WHEN element_id = '100708' AND t1.pattern_type = 2 THEN '活动'
	             WHEN element_id = '100708' AND t2.tactics_id > 2 AND event_strategy_id NOT IN (690001,720001,510001,540001) THEN '活动'
	             WHEN element_id IN ('100708','100338','100337','100707','100401') AND t0.event_strategy_id IN (2,930084) THEN '商店'
	             WHEN element_id IN (100284) THEN '活动'
	             WHEN element_id = '100708' AND element_type IN (0,-1) THEN '半屏'
	             WHEN element_id IN ('100338','100337','100707', '200900') AND t1.pattern_type = 2 THEN '活动'
	             WHEN element_id IN ('100338','100337','100707', '200900') THEN '半屏'
	             WHEN element_id IN (100024,100025,100126,100365,100120) THEN '商店'
	             WHEN element_id IN (100031) THEN '商店'
	             WHEN element_id IN (202100) THEN '返回推弹窗'
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
	       ,COUNT(distinct left(event_tm,18))                                                             AS exposure_pv -- `曝光PV`
	       ,MAX(coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name))                                AS strategy_name -- `策略名称`
         ,max(element_id) as `exp_element_id`
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
	ON t3.scene_type = 1
              AND t0.event_strategy_id = t3.tactics_id
	WHERE	t0.dt>='${bf_1_dt}' and t0.dt<='${dt}'
	AND project_id = 5
	AND element_id NOT IN ('100647', '100651', '100107')
	GROUP BY  1,2,3,4,5,6
)
, z8 AS -- 广告收入
(
	SELECT  dt
	       ,user_id
	       ,strategy_id as event_strategy_id
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
		       ,0                                                                                                                            AS `PV`
		       ,CASE WHEN os IN ('4','Android','HarmonyOS') AND ad_platform = 'AdMob' THEN ad_revenue/10000000000  ELSE ad_revenue/10000 END AS `AMOUNT`
		FROM ads.ads_sensors_production_ad_revenue_action_view
		WHERE dt>='${bf_1_dt}' and dt<='${dt}'
		AND main_strategy_id is not null
		AND ad_position_id IN (18, 62)
		UNION ALL
		select t1.dt,t1.strategy_id,t1.user_id,t1.core,t1.mt,t1.PV,t2.H5peramount  AS amount
		from (
			SELECT  t1.dt
				   ,split(main_strategy_id,'_')[1] AS strategy_id
				   ,login_id                       AS user_id
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
	) zad
	GROUP BY  1,2,3,4,5
),
z9 AS (
	SELECT  *
		   ,ROW_NUMBER() over(PARTITION BY dt,user_id,recharge_source3,event_strategy_id,core,mt ) row_1
	FROM
	(
		SELECT  ifnull(z5.dt,z7.dt)                  AS dt -- `日期`
			   ,ifnull(z5.user_id,z7.user_id)        AS user_id
			   ,ifnull(z5.recharge_source3,z7.recharge_source3)      AS recharge_source3 --充值来源
			   ,ifnull(z5.event_strategy_id,z7.event_strategy_id)              AS event_strategy_id -- 策略ID
			   ,ifnull(ifnull(z5.strategy_name,z7.strategy_name),'其他') AS strategy_name -- 策略名称
			   ,ifnull(z7.exposure_pv,0)                    AS exposure_pv -- 曝光PV
			   ,z5.shop_item_type -- 档位类型
			   ,z5.item_count --充值档位
			   ,z5.item_type
			   ,z5.subpay_type
			   ,ifnull(z5.core,z7.core) as core
			   ,ifnull(z5.mt,z7.mt) as mt
			   ,if(z5.base_amount > 0 ,z5.user_id ,null )                           AS recharge_user_id  -- 充值user_id  -- 没充值的是空
			   ,z5.base_amount                         AS base_amount --`充值金额`
			   ,z5.recharge_order_num		-- 成功订单数
			   ,z5.finish_time   		-- 订单完成时间
			   ,z5.create_order_num		-- 创建订单数
			   ,z8.ad_PV                             AS ad_PV --`广告曝光PV`
			   ,z8.ad_amount                         AS ad_amount --`广告收入`
			 ,package_id
			   ,SensorsData
			 ,exp_element_id
		FROM z5
		FULL JOIN z7
		ON z7.dt = z5.dt
			 AND z7.user_id = z5.user_id
			 AND z7.event_strategy_id = z5.event_strategy_id
			 AND z7.recharge_source3 = z5.recharge_source3
			 and z5.core = z7.core
			 and z5.mt = z7.mt
		LEFT JOIN z8
		ON z7.dt = z8.dt
			 AND z7.user_id = z8.user_id
			 AND z7.event_strategy_id = z8.event_strategy_id
			 AND z7.recharge_source3 = '半屏'
			 and z8.core = z7.core
			 and z8.mt = z7.mt
	) a0
),
z10 AS (
	SELECT dt -- `日期`
		   ,user_id
		   ,recharge_source3 as recharge_source--`充值来源`
		   ,event_strategy_id -- `策略ID`
		   ,strategy_name --`策略名称`
		   ,row_1
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
		   ,recharge_order_num
		   ,finish_time
		   ,create_order_num
		  ,if(row_1 = 1 ,ad_amount,0)   ad_amount -- `广告收入`
		  ,package_id
			,SensorsData
		  ,exp_element_id
	FROM z9
)
select
	z10.dt
	,z1.period_type
	,ifnull(z10.event_strategy_id,-99) as event_strategy_id
	,ifnull(z10.recharge_source,-99) as recharge_source
	,z10.user_id
	,z10.mt
	,z10.core
	,z10.row_1
	,z10.shop_item_type
	,z10.item_count
	,item_type
	,z10.subpay_type  -- 充值类型 = 支付方式
	,z10.strategy_name
	,z1.user_type
	,z1.remarks as put_language
	,z1.country_level
	,z10.exposure_pv
	,z10.ad_exposure_pv
	,z10.recharge_user_id
	,z10.base_amount as recharge_amount
	,z10.recharge_order_num
	,z10.create_order_num
	,z10.finish_time
	,z10.ad_amount
	,z10.package_id
	,z10.SensorsData
    ,z10.exp_element_id
	,now() as etl_ime
 from z10
inner join  z1 on z1.dt=z10.dt and z1.user_id = z10.user_id
;

-- SQL语句
commit;
