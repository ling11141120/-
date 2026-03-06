INSERT INTO ads.ads_ab_exp_core_index
-- 去重指标
WITH distinct_data_tmp AS (
	select
			'${dt}' as dt,
			a.exp_id,
			a.exp_grp_id,
			a.exp_grp_ver_id,
			datediff(a.dt,b.datestr)+1 as windowNum,
            ifnull(sum( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN bitmap_count(exp_grp_users) END),0)AS divideTrafficNum, -- 分流人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN strategy_hit_users END) AS strategyHitNum, -- 策略命中人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN exposure_users END ) AS exposureNum, -- 曝光人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN click_users END ) AS clickNum, -- 点击人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN watch_users END ) AS viewNum, -- 观看人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN unlock_users END ) AS unlockNum, -- 解锁人数
			COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN pay_unlock_users END ) AS payUnlockNum, -- 付费解锁人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN adv_unlock_users END ) AS adv_unlock_users, -- 广告解锁剧集人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN recharge_users END ) AS rechargePeopleNum, -- 充值人数
            COUNT(DISTINCT case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN consume_users END ) AS consumNum -- 消费人数
    FROM dwm.dwm_ab_exp_distinct_stat_di a
   left join dim.dim_date b on a.dt>=b.datestr and b.datestr>=date_sub(a.dt,interval 30 day)
		WHERE a.dt >= DATE_ADD('${dt}', -31)
		AND a.dt < DATE_ADD('${dt}', 1)
	group by 1,2,3,4,5
),

 -- 累加指标
accumulate_data_tmp AS (
	select
			'${dt}' as dt,
			a.exp_id,
			a.exp_grp_id,
			a.exp_grp_ver_id,
			datediff(a.dt,b.datestr)+1 as windowNum,
			SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN exp_cnt END) AS exp_cnt, -- 曝光pv
			 SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN clc_cnt END) AS clc_cnt, -- 点击pv
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN watch_episodes END) AS viewEpisodeNum, -- 观看集数
			 SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN all_unlock_episodes END) AS allUnlockEpisodeNum, -- 解锁集数
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN unlock_episodes END) AS payUnlockEpisodeNum, -- 付费解锁集数
			 SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN unlock_amount END) AS unlock_amount, -- 解锁数量
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN recharge_amount END ) AS rechargeAmount, -- 充值金额(分成后)
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN recharge_amount_pre END ) AS rechargeAmount_pre, -- 充值金额(分成前)
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN total_adv_amount END ) AS total_adv_amount, -- 总广告收入
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN adv_amount END ) AS adv_amount, -- 广告收入
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN third_h5_amount END ) AS third_h5_amount, -- 第三方H5收入
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN third_recharge_amount END ) AS threePartiesAcount, -- 三方实收
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN recharge_times END ) AS rechargeNum, -- 充值次数
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN coin_consume END ) AS coin_consume, -- 阅币消费金额
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN gift_consume END ) AS gift_consume, -- 礼券消费金额
	         SUM( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN adv_unlock_times END ) AS adv_unlock_times -- 广告解锁剧集次数
	 FROM dwm.dwm_ab_exp_accumulation_stat_di a
	   left join dim.dim_date b on a.dt>=b.datestr and b.datestr>=date_sub(a.dt,interval 30 day)
			WHERE a.dt >= DATE_ADD('${dt}', -31)
			AND a.dt < DATE_ADD('${dt}', 1)
		group by 1,2,3,4,5

),

recharge_data_tmp as (
	select '${dt}' as dt,a.exp_id,a.exp_grp_id,a.exp_grp_ver_id,
		datediff(a.dt,b.datestr)+1 as windowNum,
		count(distinct case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) and a.exposure_pv>0 THEN a.user_id end) as exposure_uv,
		sum(case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) and a.recharge_amount>0 THEN a.recharge_un  end ) as recharge_user, -- 充值用户数
		count(distinct case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) and a.create_order_user>0 THEN a.user_id end ) as create_order_user, -- 创建订单用户数
		sum(case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.recharge_amount end) as recharge_amount,  -- 订单金额
		sum(case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.signin_recharge_amount end) as signin_recharge_amount,
		sum(case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.svip_recharge_amount end) as svip_recharge_amount,
		sum(case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.normal_recharge_amount end) as normal_recharge_amount
	from dwm.`dwm_ab_exp_recharge_data_di` a
	left join dim.dim_date b on a.dt>=b.datestr and b.datestr>=date_sub(a.dt,interval 30 day)
		WHERE a.dt >= DATE_ADD('${dt}', -31)
		AND a.dt < DATE_ADD('${dt}', 1)
	group by 1,2,3,4,5
)
,
fuzha_data_tmp AS (

    SELECT
        a.exp_id, -- 实验ID
        a.exp_grp_id, -- 实验组ID
        a.exp_grp_ver_id, -- 实验组ID
		a.windowNum,
        ROUND(b.rechargeAmount/a.strategyHitNum,4)   AS arpu,  -- ARPU
        ROUND(c.recharge_user/c.exposure_uv,4)   AS payRate,  -- 付费率
        c.recharge_user  AS payRateFenzi,  -- 付费率分子(成功人数)
        c.exposure_uv  AS payRateFenMu,  -- 付费率分母(上一步人数)
        (b.rechargeAmount + b.adv_amount + b.third_h5_amount) AS estimatedRevenue,  -- SUM_AGG(入包人数)*(ARPU-SUM_AGG(group6_recharge_amount)/SUM_AGG(group6_uv))  预估收益
        ROUND(b.rechargeAmount/a.rechargePeopleNum,2)  AS arppu,  -- 充值金额/充值人数  ARPPU
        ROUND(b.rechargeAmount/b.rechargeNum,2)  AS unitPrice,  -- 充值金额/充值次数  客单价
        ROUND(b.rechargeNum/a.rechargePeopleNum,2)  AS rechargeAvg,  -- 充值次数/充值人数  人均充值次数
        ROUND((b.coin_consume + b.gift_consume)/consumNum,2)  AS totalArppu,  -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
        ROUND(b.coin_consume/consumNum,2)  AS readCoinsArppu,  -- 阅币消费金额/消费人数  阅币消费ARPPU
        ROUND(b.threePartiesAcount/rechargeAmount,2)  AS threePartiesPercent,  -- 三方实收/充值金额  三方实收占比
        ROUND(1-b.rechargeAmount/b.rechargeAmount_pre,2)  AS amountRate,  -- 分成后/分成前  费率
        ROUND((b.coin_consume + b.gift_consume)/a.strategyHitNum,2)  AS readCoinsAndVoucherApru,  -- 阅币消费金额+礼券消费金额/入包人数  阅币礼券消费ARPU
        ROUND(a.consumNum/a.strategyHitNum,4)  AS consumeRate,  -- 消费人数/入包人数  消费率
        ROUND(b.adv_amount/a.strategyHitNum,4)  AS adverArpu,  -- 广告收入/入包人数  广告ARPU
        ROUND(b.total_adv_amount/a.strategyHitNum,4)  AS totalAdverArpu,  -- 总广告收入/入包人数  总广告ARPU
        ROUND(a.adv_unlock_users/a.strategyHitNum,4)  AS adverUnlockRate,  -- 广告解锁剧集人数/入包人数  广告解锁率
        a.adv_unlock_users  AS adverUnlockRateFenzi,  -- 广告解锁率分子(成功人数)
        a.strategyHitNum  AS adverUnlockRateFenmu,  -- 广告解锁率分母(上一步人数)
        ROUND(b.adv_unlock_times/a.adv_unlock_users,2)  AS adverUnlockEpisodeNum,  -- 广告解锁剧集次数/广告解锁剧集人数  人均广告解锁剧集
		ifnull(c.exposure_uv,0) as exposure_uv , -- 单人曝光uv
		ifnull(c.recharge_user,0) as recharge_user , -- 充值用户数
		c.recharge_amount,
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
        ifnull(c.recharge_amount,0)  AS buyAmount,  -- 购买金额
		ifnull(a.exposureNum,0)  AS episodeExposureNum,  -- 推剧曝光人数
		ROUND(a.clickNum/a.exposureNum,6) AS clickCTR, -- 点击率CTR
		ROUND(b.clc_cnt/b.exp_cnt,6) AS ctr, -- CTR（pv）
		ROUND(b.unlock_amount/a.payUnlockNum,4) AS unlockArppu,   -- 人均解锁ARPPU
		ROUND(b.unlock_amount/a.exposureNum,4) AS unlockArpu   -- 人均解锁ARPU
     FROM distinct_data_tmp a
     left JOIN accumulate_data_tmp b
         ON a.exp_id = b.exp_id
             AND a.exp_grp_id = b.exp_grp_id
             AND a.exp_grp_ver_id = b.exp_grp_ver_id
			 and a.windowNum=b.windowNum
      left JOIN recharge_data_tmp c
         ON a.exp_id = c.exp_id
             AND a.exp_grp_id = c.exp_grp_id
             AND a.exp_grp_ver_id = c.exp_grp_ver_id
			 and a.windowNum = c.windowNum
)

-- 实验总人数
,exp_user_tmp AS (
 SELECT
     a.exp_id, -- 实验ID
     COUNT(DISTINCT  exp_grp_users ) AS totalNumber -- 实验总人数
 FROM dwm.dwm_ab_exp_distinct_stat_di a
 inner join ods.syncbi_ab_experiment b on a.exp_id =b.id  and a.dt<b.end_time
  where a.dt>='${dt}'
 GROUP BY 1
)


SELECT
      a.exp_id,
      a.exp_grp_id,
      '${dt}' as dt,
      b.project_id,
      a.exp_grp_ver_id,
      a.windowNum as windowNum,
      b.exp_name,
      b.exp_grp_name,
      b.exp_grp_type,
      c.totalNumber,
      a.strategyHitNum as totalNumberGroup,
      a.divideTrafficNum as groupNum,
      a.divideTrafficNum as includeGroupNum,
      a.divideTrafficNum as divideTrafficNum,
      a.strategyHitNum,
      f.exposure_uv,
      a.clickNum,
      a.viewNum,
      a.unlockNum,
	  a.payUnlockNum,
      e.viewEpisodeNum,
	  e.allUnlockEpisodeNum as unlockEpisodeNum,
      e.payUnlockEpisodeNum,
      f.estimatedRevenue,
      f.arpu,
      f.payRate,
      f.payRateFenzi,
      f.payRateFenMu,
      round(sum(f.payRateFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) /sum(f.payRateFenMu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum), 4) as payAllRate,
      sum(f.payRateFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as payAllRateFenzi,
      sum(f.payRateFenMu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as payAllRateFenMu,
      f.arppu,
      f.unitPrice,
      f.rechargeAvg,
      f.totalArppu,
      f.readCoinsArppu,
      a.rechargePeopleNum,
      e.rechargeNum,
      e.rechargeAmount,
      e.threePartiesAcount,
      f.threePartiesPercent,
      f.amountRate,
      a.consumNum,
      e.coin_consume,
      e.gift_consume,
      f.readCoinsAndVoucherApru,
      f.consumeRate,
      f.adverArpu,
      f.totalAdverArpu,
      f.adverUnlockRate,
      f.adverUnlockRateFenzi,
      f.adverUnlockRateFenmu,
      f.adverUnlockEpisodeNum,
      f.oneExposureArpu,
      round(sum(f.recharge_amount) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) /sum(f.exposure_uv) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum), 4) as oneExposureAllArpu,
      sum(f.recharge_amount) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as oneExposureAllArpuFenzi,
      sum(f.exposure_uv) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as oneExposureAllArpuFenmu,
      f.oneExposureArpuDingYue,
      f.oneRechargePercent,
      f.oneRechargePercentFenzi,
      f.oneRechargePercentFenmu,
      f.dingYueAmountPercent,
      f.dingYueAmountPercentFenzi,
      f.dingYueAmountPercentFenmu,
      round(sum(f.dingYueAmountPercentFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) /sum(f.dingYueAmountPercentFenmu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum), 4) as dingYueAmountAllPercent,
      sum(f.dingYueAmountPercentFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as dingYueAmountAllPercentFenzi,
      sum(f.dingYueAmountPercentFenmu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) as dingYueAmountAllPercentFenmu,
	  f.orderCreateRate,
      f.orderCreateRateFenzi,
      f.orderCreateRateFenmu,
	  f.predictARPU,
	  f.buyersNum,
	  f.buyAmount,
	  a.exposureNum as episodeExposureNum,
	  round(a.clickNum/a.exposureNum,6) as  clickCTR,
	  f.ctr,
	  f.unlockArppu,
	  f.unlockArpu,
      NOW() as saveTime,
      NOW() as updateTime,
      b.start_time,
      b.end_time
FROM distinct_data_tmp a
left JOIN dwd.dwd_ab_exp_version_detail b
ON a.exp_id = b.exp_id
   AND a.exp_grp_id = b.exp_grp_id
   AND a.exp_grp_ver_id = b.exp_grp_ver_id
left JOIN exp_user_tmp c
ON a.exp_id = c.exp_id
left JOIN accumulate_data_tmp e
ON a.exp_id = e.exp_id
   AND a.exp_grp_id = e.exp_grp_id
    AND a.exp_grp_ver_id = e.exp_grp_ver_id
	and a.windowNum = e.windowNum
left JOIN fuzha_data_tmp f
    ON a.exp_id = f.exp_id
    AND a.exp_grp_id = f.exp_grp_id
    AND a.exp_grp_ver_id = f.exp_grp_ver_id
	and a.windowNum = f.windowNum
where date(b.end_time)>='${dt}' and date(b.exp_end_time)>='${dt}';