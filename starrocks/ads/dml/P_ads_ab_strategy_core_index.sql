----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ab_strategy_core_index
-- workflow_version : 19
-- create_user      : hufengju
-- task_name        : ads_ab_strategy_core_index
-- task_version     : 14
-- update_time      : 2025-05-24 14:51:34
-- sql_path         : \starrocks\tbl_ads_ab_strategy_core_index\ads_ab_strategy_core_index
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_ab_strategy_core_index
WITH distinct_data_tmp AS (   ---- 去重指标
	select
		a.dt,
		0 as strategy_id,
		2 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		ifnull(sum(  bitmap_count(exp_grp_users) ),0)AS divideTrafficNum, -- 分流人数
		COUNT(DISTINCT  strategy_hit_users ) AS strategyHitNum, -- 策略命中人数
		COUNT(DISTINCT  exposure_users  ) AS exposureNum, -- 曝光人数
		COUNT(DISTINCT  click_users  ) AS clickNum, -- 点击人数
		COUNT(DISTINCT  watch_users  ) AS viewNum, -- 观看人数
		COUNT(DISTINCT  unlock_users  ) AS unlockNum, -- 解锁人数
		COUNT(DISTINCT  adv_unlock_users  ) AS adv_unlock_users, -- 广告解锁剧集人数
		COUNT(DISTINCT  recharge_users  ) AS rechargePeopleNum, -- 充值人数
		COUNT(DISTINCT  consume_users  ) AS consumNum -- 消费人数
    FROM dwm.dwm_ab_exp_distinct_stat_di a
    left join ods.ods_ab_hj_related b on a.exp_id=b.ab_id and a.exp_grp_id=b.version_id
	left join ods.`ods_tidb_ab_hj_strategy` c on b.strategy_id = c.strategy_id
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5

	union all

		select
		a.dt,
		0 as strategy_id,
		1 as statisticType,
		0 as strategyType,
		0 as strategySecondType,
		ifnull(sum(  bitmap_count(exp_grp_users) ),0)AS divideTrafficNum, -- 分流人数
		COUNT(DISTINCT  strategy_hit_users ) AS strategyHitNum, -- 策略命中人数
		COUNT(DISTINCT  exposure_users  ) AS exposureNum, -- 曝光人数
		COUNT(DISTINCT  click_users  ) AS clickNum, -- 点击人数
		COUNT(DISTINCT  watch_users  ) AS viewNum, -- 观看人数
		COUNT(DISTINCT  unlock_users  ) AS unlockNum, -- 解锁人数
		COUNT(DISTINCT  adv_unlock_users  ) AS adv_unlock_users, -- 广告解锁剧集人数
		COUNT(DISTINCT  recharge_users  ) AS rechargePeopleNum, -- 充值人数
		COUNT(DISTINCT  consume_users  ) AS consumNum -- 消费人数
    FROM dwm.dwm_ab_exp_distinct_stat_di a
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5

	union all

	select
		a.dt,
		ifnull(b.strategy_id,-99) as strategy_id,
		3 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		ifnull(sum(  bitmap_count(exp_grp_users) ),0)AS divideTrafficNum, -- 分流人数
		COUNT(DISTINCT  strategy_hit_users ) AS strategyHitNum, -- 策略命中人数
		COUNT(DISTINCT  exposure_users  ) AS exposureNum, -- 曝光人数
		COUNT(DISTINCT  click_users  ) AS clickNum, -- 点击人数
		COUNT(DISTINCT  watch_users  ) AS viewNum, -- 观看人数
		COUNT(DISTINCT  unlock_users  ) AS unlockNum, -- 解锁人数
		COUNT(DISTINCT  adv_unlock_users  ) AS adv_unlock_users, -- 广告解锁剧集人数
		COUNT(DISTINCT  recharge_users  ) AS rechargePeopleNum, -- 充值人数
		COUNT(DISTINCT  consume_users  ) AS consumNum -- 消费人数
    FROM dwm.dwm_ab_exp_distinct_stat_di a
    left join ods.ods_ab_hj_related b on a.exp_id=b.ab_id and a.exp_grp_id=b.version_id
	left join ods.`ods_tidb_ab_hj_strategy` c on b.strategy_id = c.strategy_id
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5
),
accumulate_data_tmp AS (   -- 累加指标
	select
		a.dt,
		0 as strategy_id,
		2 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		 SUM(  watch_episodes ) AS viewEpisodeNum, -- 观看集数
		 SUM(  unlock_episodes ) AS payUnlockEpisodeNum, -- 付费解锁集数
		 SUM(  recharge_amount  ) AS rechargeAmount, -- 充值金额(分成后)
		 SUM(  recharge_amount_pre  ) AS rechargeAmount_pre, -- 充值金额(分成前)
		 SUM(  total_adv_amount  ) AS total_adv_amount, -- 总广告收入
		 SUM(  adv_amount  ) AS adv_amount, -- 广告收入
		 SUM(  third_h5_amount  ) AS third_h5_amount, -- 第三方H5收入
		 SUM(  third_recharge_amount  ) AS threePartiesAcount, -- 三方实收
		 SUM(  recharge_times  ) AS rechargeNum, -- 充值次数
		 SUM(  coin_consume  ) AS coin_consume, -- 阅币消费金额
		 SUM(  gift_consume  ) AS gift_consume, -- 礼券消费金额
		 SUM(  adv_unlock_times  ) AS adv_unlock_times -- 广告解锁剧集次数
	 FROM dwm.dwm_ab_exp_accumulation_stat_di a
     left join ods.ods_ab_hj_related b on a.exp_id=b.ab_id and a.exp_grp_id=b.version_id
	 left join ods.`ods_tidb_ab_hj_strategy` c on b.strategy_id = c.strategy_id
			WHERE a.dt = '${dt}'
		group by 1,2,3,4,5

		union all

	select
		a.dt,
		0 as strategy_id,
		1 as statisticType,
		0 as strategyType,
		0 as strategySecondType,
		 SUM(  watch_episodes ) AS viewEpisodeNum, -- 观看集数
		 SUM(  unlock_episodes ) AS payUnlockEpisodeNum, -- 付费解锁集数
		 SUM(  recharge_amount  ) AS rechargeAmount, -- 充值金额(分成后)
		 SUM(  recharge_amount_pre  ) AS rechargeAmount_pre, -- 充值金额(分成前)
		 SUM(  total_adv_amount  ) AS total_adv_amount, -- 总广告收入
		 SUM(  adv_amount  ) AS adv_amount, -- 广告收入
		 SUM(  third_h5_amount  ) AS third_h5_amount, -- 第三方H5收入
		 SUM(  third_recharge_amount  ) AS threePartiesAcount, -- 三方实收
		 SUM(  recharge_times  ) AS rechargeNum, -- 充值次数
		 SUM(  coin_consume  ) AS coin_consume, -- 阅币消费金额
		 SUM(  gift_consume  ) AS gift_consume, -- 礼券消费金额
		 SUM(  adv_unlock_times  ) AS adv_unlock_times -- 广告解锁剧集次数
	 FROM dwm.dwm_ab_exp_accumulation_stat_di a
     left join ods.ods_ab_hj_related b on a.exp_id=b.ab_id and a.exp_grp_id=b.version_id
			WHERE a.dt = '${dt}'
		group by 1,2,3,4,5

		union all

	select
		a.dt,
		ifnull(b.strategy_id,-99) as strategy_id,
		3 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		 SUM(  watch_episodes ) AS viewEpisodeNum, -- 观看集数
		 SUM(  unlock_episodes ) AS payUnlockEpisodeNum, -- 付费解锁集数
		 SUM(  recharge_amount  ) AS rechargeAmount, -- 充值金额(分成后)
		 SUM(  recharge_amount_pre  ) AS rechargeAmount_pre, -- 充值金额(分成前)
		 SUM(  total_adv_amount  ) AS total_adv_amount, -- 总广告收入
		 SUM(  adv_amount  ) AS adv_amount, -- 广告收入
		 SUM(  third_h5_amount  ) AS third_h5_amount, -- 第三方H5收入
		 SUM(  third_recharge_amount  ) AS threePartiesAcount, -- 三方实收
		 SUM(  recharge_times  ) AS rechargeNum, -- 充值次数
		 SUM(  coin_consume  ) AS coin_consume, -- 阅币消费金额
		 SUM(  gift_consume  ) AS gift_consume, -- 礼券消费金额
		 SUM(  adv_unlock_times  ) AS adv_unlock_times -- 广告解锁剧集次数
	 FROM dwm.dwm_ab_exp_accumulation_stat_di a
     left join ods.ods_ab_hj_related b on a.exp_id=b.ab_id and a.exp_grp_id=b.version_id
	 left join ods.`ods_tidb_ab_hj_strategy` c on b.strategy_id = c.strategy_id
			WHERE a.dt = '${dt}'
		group by 1,2,3,4,5
),

recharge_data_tmp as (
	select
		a.dt,
		0 as strategy_id,
		2 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		count(distinct  a.user_id ) as exposure_uv,
		count(distinct case when a.recharge_amount>0 then a.user_id end ) as recharge_user, -- 充值用户数
		count(distinct case when a.create_order_user>0 then a.user_id end ) as create_order_user, -- 创建订单用户数
		sum( a.recharge_amount ) as recharge_amount,  --订单金额
		sum( a.signin_recharge_amount ) as signin_recharge_amount,
		sum( a.svip_recharge_amount ) as svip_recharge_amount,
		sum( a.normal_recharge_amount ) as normal_recharge_amount
	from dwm.`dwm_ab_strategy_recharge_data_di` a
	left join ods.`ods_tidb_ab_hj_strategy` c on a.strategy_id = c.strategy_id
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5

	union all

	select
		a.dt,
		0 as strategy_id,
		1 as statisticType,
		0 as strategyType,
		0 as strategySecondType,
		count(distinct  a.user_id ) as exposure_uv,
		count(distinct case when a.recharge_amount>0 then a.user_id end ) as recharge_user, -- 充值用户数
		count(distinct case when a.create_order_user>0 then a.user_id end ) as create_order_user, -- 创建订单用户数
		sum( a.recharge_amount ) as recharge_amount,  --订单金额
		sum( a.signin_recharge_amount ) as signin_recharge_amount,
		sum( a.svip_recharge_amount ) as svip_recharge_amount,
		sum( a.normal_recharge_amount ) as normal_recharge_amount
	from dwm.`dwm_ab_strategy_recharge_data_di` a
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5

	union all

	select
		a.dt,
		ifnull(a.strategy_id,-99) as strategy_id,
		3 as statisticType,
		ifnull(c.`type`,0) as strategyType,
		ifnull(c.second_type,0) as strategySecondType,
		count(distinct  a.user_id ) as exposure_uv,
		count(distinct case when a.recharge_amount>0 then a.user_id end ) as recharge_user, -- 充值用户数
		count(distinct case when a.create_order_user>0 then a.user_id end ) as create_order_user, -- 创建订单用户数
		sum( a.recharge_amount ) as recharge_amount,  --订单金额
		sum( a.signin_recharge_amount ) as signin_recharge_amount,
		sum( a.svip_recharge_amount ) as svip_recharge_amount,
		sum( a.normal_recharge_amount ) as normal_recharge_amount
	from dwm.`dwm_ab_strategy_recharge_data_di` a
	left join ods.`ods_tidb_ab_hj_strategy` c on a.strategy_id = c.strategy_id
		WHERE a.dt = '${dt}'
	group by 1,2,3,4,5
)

	select
		ifnull(strategy_id,-99) as strategy_id
		,dt
		,project_id
		,windowNum
		,a.statisticType
		,a.strategyType
		,a.strategySecondType
		,max(totalNumber) as totalNumber
		,max(totalNumberGroup) as totalNumberGroup
		,max(groupNum) as groupNum
		,max(includeGroupNum) as includeGroupNum
		,max(divideTrafficNum) as divideTrafficNum
		,max(strategyHitNum) as strategyHitNum
		,max(exposure_uv) as exposure_uv
		,max(clickNum) as clickNum
		,max(viewNum) as viewNum
		,max(unlockNum) as unlockNum
		,max(viewEpisodeNum) as viewEpisodeNum
		,max(payUnlockEpisodeNum) as payUnlockEpisodeNum
		,max(estimatedRevenue) as estimatedRevenue
		,max(arpu) as arpu
		,max(payRate) as payRate
		,max(payRateFenzi) as payRateFenzi
		,max(payRateFenMu) as payRateFenMu
		,max(arppu) as arppu
		,max(unitPrice) as unitPrice
		,max(rechargeAvg) as rechargeAvg
		,max(totalArppu) as totalArppu
		,max(readCoinsArppu) as readCoinsArppu
		,max(rechargePeopleNum) as rechargePeopleNum
		,max(rechargeNum) as rechargeNum
		,max(rechargeAmount) as rechargeAmount
		,max(threePartiesAcount) as threePartiesAcount
		,max(threePartiesPercent) as threePartiesPercent
		,max(amountRate) as amountRate
		,max(consumNum) as consumNum
		,max(coin_consume) as coin_consume
		,max(gift_consume) as gift_consume
		,max(readCoinsAndVoucherApru) as readCoinsAndVoucherApru
		,max(consumeRate) as consumeRate
		,max(adverArpu) as adverArpu
		,max(totalAdverArpu) as totalAdverArpu
		,max(adverUnlockRate) as adverUnlockRate
		,max(adverUnlockRateFenzi) as adverUnlockRateFenzi
		,max(adverUnlockRateFenmu) as adverUnlockRateFenmu
		,max(adverUnlockEpisodeNum) as adverUnlockEpisodeNum
		,max(oneExposureArpu) as oneExposureArpu
		,max(oneExposureArpuDingYue) as oneExposureArpuDingYue
		,max(oneRechargePercent) as oneRechargePercent
		,max(oneRechargePercentFenzi) as oneRechargePercentFenzi
		,max(oneRechargePercentFenmu) as oneRechargePercentFenmu
		,max(dingYueAmountPercent) as dingYueAmountPercent
		,max(dingYueAmountPercentFenzi) as dingYueAmountPercentFenzi
		,max(dingYueAmountPercentFenmu) as dingYueAmountPercentFenmu
		,max(orderCreateRate) as orderCreateRate
		,max(orderCreateRateFenzi) as orderCreateRateFenzi
		,max(orderCreateRateFenmu) as orderCreateRateFenmu
		,max(predictARPU) as predictARPU
		,max(buyersNum) as buyersNum
		,max(buyAmount) as buyAmount
		,NOW() as saveTime
		,NOW() as updateTime
	from (
		SELECT
			a.strategy_id, -- 策略ID
			a.dt,
			3 as project_id,
			  1 as windowNum,
			  a.statisticType,
			a.strategyType,
			a.strategySecondType,
			  0 as totalNumber,
			  0 as totalNumberGroup,
			  0 as groupNum,
			  0 as includeGroupNum,
			  0 as divideTrafficNum,
			  a.strategyHitNum,
			  0 as exposure_uv , -- 单人曝光uv
			  a.clickNum,
		      a.viewNum,
		      a.unlockNum,
		      b.viewEpisodeNum,
		      b.payUnlockEpisodeNum,
		      (b.rechargeAmount + b.adv_amount + b.third_h5_amount) AS estimatedRevenue,  -- SUM_AGG(入包人数)*(ARPU-SUM_AGG(group6_recharge_amount)/SUM_AGG(group6_uv))  预估收益
			ROUND(b.rechargeAmount/a.strategyHitNum,4)   AS arpu,  -- ARPU
			0 AS payRate,  -- 付费率
			0 AS payRateFenzi,  -- 付费率分子(成功人数)
			0 AS payRateFenMu,  -- 付费率分母(上一步人数)
			ROUND(b.rechargeAmount/a.rechargePeopleNum,2)  AS arppu,  -- 充值金额/充值人数  ARPPU
			ROUND(b.rechargeAmount/b.rechargeNum,2)  AS unitPrice,  -- 充值金额/充值次数  客单价
			ROUND(b.rechargeNum/a.rechargePeopleNum,2)  AS rechargeAvg,  -- 充值次数/充值人数  人均充值次数
			ROUND((b.coin_consume + b.gift_consume)/consumNum,2)  AS totalArppu,  -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
			ROUND(b.coin_consume/consumNum,2)  AS readCoinsArppu,  -- 阅币消费金额/消费人数  阅币消费ARPPU
			a.rechargePeopleNum,
			b.rechargeNum,
			b.rechargeAmount,
			b.threePartiesAcount,
			ROUND(b.threePartiesAcount/rechargeAmount,2)  AS threePartiesPercent,  -- 三方实收/充值金额  三方实收占比
			ROUND(1-b.rechargeAmount/b.rechargeAmount_pre,2)  AS amountRate,  -- 分成后/分成前  费率
			a.consumNum,
			b.coin_consume,
			b.gift_consume,
			ROUND((b.coin_consume + b.gift_consume)/a.strategyHitNum,2)  AS readCoinsAndVoucherApru,  -- 阅币消费金额+礼券消费金额/入包人数  阅币礼券消费ARPU
			ROUND(a.consumNum/a.strategyHitNum,4)  AS consumeRate,  -- 消费人数/入包人数  消费率
			ROUND(b.adv_amount/a.strategyHitNum,4)  AS adverArpu,  -- 广告收入/入包人数  广告ARPU
			ROUND(b.total_adv_amount/a.strategyHitNum,4)  AS totalAdverArpu,  -- 总广告收入/入包人数  总广告ARPU
			ROUND(a.adv_unlock_users/a.strategyHitNum,4)  AS adverUnlockRate,  -- 广告解锁剧集人数/入包人数  广告解锁率
			a.adv_unlock_users  AS adverUnlockRateFenzi,  -- 广告解锁率分子(成功人数)
			a.strategyHitNum  AS adverUnlockRateFenmu,  -- 广告解锁率分母(上一步人数)
			ROUND(b.adv_unlock_times/a.adv_unlock_users,2)  AS adverUnlockEpisodeNum,  -- 广告解锁剧集次数/广告解锁剧集人数  人均广告解锁剧集
			-- 0 as exposure_uv , -- 单人曝光uv
			-- 0 as recharge_user , -- 充值用户数
			0 as oneExposureArpu, -- 单人曝光ARPU
			0 as oneExposureArpuDingYue, -- 单人曝光ARPU(订阅)
			0 as oneRechargePercent, -- 单次充值占比
			0 as oneRechargePercentFenzi, -- 单次充值占比分子(普通充值金额)
			0 as oneRechargePercentFenmu, -- 单次充值占比分母(充值金额)
			0 as dingYueAmountPercent, -- 订阅金额占比
			0 as dingYueAmountPercentFenzi, -- 订阅金额占比分子(订阅金额)
			0 as dingYueAmountPercentFenmu, -- 订阅金额占比分母(充值金额)
			0 AS orderCreateRate,  -- 订单创建率
			0 AS orderCreateRateFenzi,  -- 订单创建率分子（订单创建人数）
			0 AS orderCreateRateFenmu,  -- 订单创建率分母（曝光人数)
			0 as predictARPU,  -- 预估ARPU
			0 AS buyersNum,  -- 购买人数
			0 AS buyAmount  -- 购买金额
		 FROM distinct_data_tmp a
		 left JOIN accumulate_data_tmp b ON a.strategy_id = b.strategy_id and a.statisticType=b.statisticType and a.strategyType=b.strategyType and a.strategySecondType=b.strategySecondType

			 union all

		SELECT
			c.strategy_id, -- 策略ID
			c.dt,
			3 as project_id,
			  1 as windowNum,
			statisticType,
			strategyType,
			strategySecondType,
			  0 as totalNumber,
			  0 as totalNumberGroup,
			  0 as groupNum,
			  0 as includeGroupNum,
			  0 as divideTrafficNum,
			  0 as strategyHitNum,
			  ifnull(c.exposure_uv,0) as exposure_uv , -- 单人曝光uv
			  0 as clickNum,
			  0 as viewNum,
			  0 as unlockNum,
			  0 as viewEpisodeNum,
			  0 as payUnlockEpisodeNum,
			  0 AS estimatedRevenue,  -- SUM_AGG(入包人数)*(ARPU-SUM_AGG(group6_recharge_amount)/SUM_AGG(group6_uv))  预估收益
			0  AS arpu,  -- ARPU
			ROUND(c.recharge_user/c.exposure_uv,4)   AS payRate,  -- 付费率
			c.recharge_user  AS payRateFenzi,  -- 付费率分子(成功人数)
			c.exposure_uv  AS payRateFenMu,  -- 付费率分母(上一步人数)

			0 AS arppu,  -- 充值金额/充值人数  ARPPU
			0 AS unitPrice,  -- 充值金额/充值次数  客单价
			0 AS rechargeAvg,  -- 充值次数/充值人数  人均充值次数
			0 AS totalArppu,  -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
			0 AS readCoinsArppu,  -- 阅币消费金额/消费人数  阅币消费ARPPU
			0 AS rechargePeopleNum,
			0 AS rechargeNum,
			0 AS rechargeAmount,
			0 AS threePartiesAcount,

			0 AS threePartiesPercent,  -- 三方实收/充值金额  三方实收占比
			0 AS amountRate,  -- 分成后/分成前  费率

			0 AS consumNum,
			0 AS coin_consume,
			0 AS gift_consume,

			0 AS readCoinsAndVoucherApru,  -- 阅币消费金额+礼券消费金额/入包人数  阅币礼券消费ARPU
			0 AS consumeRate,  -- 消费人数/入包人数  消费率
			0 AS adverArpu,  -- 广告收入/入包人数  广告ARPU
			0 AS totalAdverArpu,  -- 总广告收入/入包人数  总广告ARPU
			0 AS adverUnlockRate,  -- 广告解锁剧集人数/入包人数  广告解锁率
			0 AS adverUnlockRateFenzi,  -- 广告解锁率分子(成功人数)
			0 AS adverUnlockRateFenmu,  -- 广告解锁率分母(上一步人数)
			0 AS adverUnlockEpisodeNum,  -- 广告解锁剧集次数/广告解锁剧集人数  人均广告解锁剧集
			--ifnull(c.exposure_uv,0) as exposure_uv , -- 单人曝光uv
			--ifnull(c.recharge_user,0) as recharge_user , -- 充值用户数
			ROUND(c.recharge_amount/c.exposure_uv,4) as oneExposureArpu, -- 单人曝光ARPU
			ROUND((signin_recharge_amount+svip_recharge_amount)/c.exposure_uv,4) as oneExposureArpuDingYue, -- 单人曝光ARPU(订阅)
			ROUND(c.normal_recharge_amount/c.recharge_amount,4) as oneRechargePercent, -- 单次充值占比
			c.normal_recharge_amount as oneRechargePercentFenzi, -- 单次充值占比分子(普通充值金额)
			c.recharge_amount as oneRechargePercentFenmu, -- 单次充值占比分母(充值金额)
			ROUND((signin_recharge_amount+svip_recharge_amount)/c.recharge_amount,4) as dingYueAmountPercent, -- 订阅金额占比
			(signin_recharge_amount+svip_recharge_amount) as dingYueAmountPercentFenzi, -- 订阅金额占比分子(订阅金额)
			c.recharge_amount as dingYueAmountPercentFenmu, -- 订阅金额占比分母(充值金额)
			ROUND(c.create_order_user/c.exposure_uv,4)   AS orderCreateRate,  -- 订单创建率
			ifnull(c.create_order_user,0)  AS orderCreateRateFenzi,  -- 订单创建率分子（订单创建人数）
			ifnull(c.exposure_uv,0)  AS orderCreateRateFenmu,  -- 订单创建率分母（曝光人数)
			ROUND((c.recharge_amount/c.exposure_uv)+((signin_recharge_amount+svip_recharge_amount)/c.exposure_uv)*0.36 ,4) as predictARPU,  -- 预估ARPU
			ifnull(c.recharge_user,0)  AS buyersNum,  -- 购买人数
			ifnull(c.recharge_amount,0)  AS buyAmount  -- 购买金额
		 FROM  recharge_data_tmp c
) a
	group by 1,2,3,4,5,6,7
;
