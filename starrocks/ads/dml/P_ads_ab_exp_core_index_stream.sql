INSERT INTO ads.ads_ab_exp_core_index_stream
-- 实验总人数
with exp_user_tmp AS (
  SELECT
     a.exp_id, -- 实验ID
     COUNT(DISTINCT  a.exp_grp_users ) AS totalNumber -- 实验总人数
 FROM dwm.dwm_ab_exp_distinct_stat_di a
 inner join  ods.syncbi_ab_experiment b on a.exp_id =b.id and a.dt<=date(b.end_time)
 GROUP BY 1
),

-- 去重指标
distinct_data_tmp AS (

		SELECT
				a.exp_id, -- 实验ID
				a.exp_grp_id, -- 实验组ID
				a.exp_grp_ver_id, -- 实验组ID
				COUNT(DISTINCT  exp_grp_users ) AS divideTrafficNum, -- 分流人数
				COUNT(DISTINCT  strategy_hit_users ) AS strategyHitNum, -- 策略命中人数
				COUNT(DISTINCT  exposure_users  ) AS exposureNum, -- 曝光人数
				COUNT(DISTINCT  click_users  ) AS clickNum, -- 点击人数
				COUNT(DISTINCT  watch_users  ) AS viewNum, -- 观看人数
				COUNT(DISTINCT  unlock_users  ) AS unlockNum, -- 解锁人数
				COUNT(DISTINCT  pay_unlock_users  ) AS payUnlockNum, -- 付费解锁人数
				COUNT(DISTINCT  adv_unlock_users  ) AS adv_unlock_users, -- 广告解锁剧集人数
				COUNT(DISTINCT  recharge_users  ) AS rechargePeopleNum, -- 充值人数
				COUNT(DISTINCT  consume_users  ) AS consumNum -- 消费人数
		FROM dwm.dwm_ab_exp_distinct_stat_di a
		INNER JOIN dwd.dwd_ab_exp_version_detail b
		ON a.exp_id = b.exp_id
		AND a.exp_grp_id = b.exp_grp_id
		AND a.exp_grp_ver_id = b.exp_grp_ver_id
	where a.dt<=date(b.exp_end_time)
GROUP BY 1,2,3

),

 -- 累加指标
accumulate_data_tmp AS (

 SELECT
         a.exp_id, -- 实验ID
         a.exp_grp_id, -- 实验组ID
         a.exp_grp_ver_id, -- 实验组ID
		 sum(exp_cnt) exp_cnt, -- 曝光次数
		 sum(clc_cnt) clc_cnt, -- 点击次数
         SUM(  watch_episodes ) AS viewEpisodeNum, -- 观看集数
		 SUM(  all_unlock_episodes ) AS allUnlockEpisodeNum, -- 解锁集数
         SUM(  unlock_episodes ) AS payUnlockEpisodeNum, -- 付费解锁集数
		 SUM(  unlock_amount ) AS unlock_amount, -- 解锁数量
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
INNER JOIN dwd.dwd_ab_exp_version_detail b
         ON a.exp_id = b.exp_id
             AND a.exp_grp_id = b.exp_grp_id
             AND a.exp_grp_ver_id = b.exp_grp_ver_id
	where a.dt<=date(b.exp_end_time)
 GROUP BY 1,2,3
),
recharge_data_tmp as (
	select
		 a.exp_id, -- 实验ID
         a.exp_grp_id, -- 实验组ID
         a.exp_grp_ver_id, -- 实验组ID
         count(distinct case when a.exposure_pv>0  then a.user_id end)  as exposure_uv, -- 充值曝光uv
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.user_id, null) end)  as l14_exposure_uv, -- 充值曝光uv
         count(distinct case when a.exposure_pv>0  then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.user_id, null) end)  as l30_exposure_uv, -- 充值曝光uv
		 sum(case when a.recharge_amount>0 then  a.recharge_un end) as recharge_user, -- 充值用户数
		 sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_un, 0) end) as l14_recharge_user, -- 充值用户数
		 sum(case when a.recharge_amount>0 then  if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_un, 0) end) as l30_recharge_user, -- 充值用户数
		 count(distinct case when a.create_order_user>0 then a.user_id end) as create_order_user, -- 创建订单用户数
         sum(a.recharge_amount) as recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_amount, 0)) as l14_recharge_amount, -- 充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_amount, 0)) as l30_recharge_amount, -- 充值金额
         sum(a.signin_recharge_amount) as signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.signin_recharge_amount, 0)) as l14_signin_recharge_amount, -- 签到卡-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.signin_recharge_amount, 0)) as l30_signin_recharge_amount, -- 签到卡-充值金额
         sum(a.svip_recharge_amount) as svip_recharge_amount, -- SVIP-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.svip_recharge_amount, 0)) as l14_svip_recharge_amount, -- SVIP-充值金额
         sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.svip_recharge_amount, 0)) as l30_svip_recharge_amount, -- SVIP-充值金额
         sum(a.normal_recharge_amount) as normal_recharge_amount -- 普通充值金额
	from dwm.`dwm_ab_exp_recharge_data_di` a
	left join dwd.dwd_ab_exp_version_detail b
         ON a.exp_id = b.exp_id
             AND a.exp_grp_id = b.exp_grp_id
             AND a.exp_grp_ver_id = b.exp_grp_ver_id
	where a.dt<=date(b.exp_end_time)
    GROUP BY 1,2,3
)

-- 派生指标
,fuzha_data_tmp AS (
    SELECT
        a.exp_id,
        a.exp_grp_id,
        a.exp_grp_ver_id,
        ROUND(b.rechargeAmount/a.strategyHitNum,4)   AS arpu,  -- ARPU
        ROUND(c.recharge_user/c.exposure_uv,4)   AS payRate,  -- 付费率
        ROUND(c.l14_recharge_user/c.l14_exposure_uv,4)   AS l14_payRate,  -- 付费率
        ROUND(c.l30_recharge_user/c.l30_exposure_uv,4)   AS l30_payRate,  -- 付费率
        round(sum(c.recharge_user) over(partition by a.exp_id, a.exp_grp_id) /sum(c.exposure_uv) over(partition by a.exp_id, a.exp_grp_id), 4) as payAllRate,
        sum(c.recharge_user) over(partition by a.exp_id, a.exp_grp_id) as payAllRateFenzi,
        sum(c.exposure_uv) over(partition by a.exp_id, a.exp_grp_id) as payAllRateFenMu,
        ROUND(b.threePartiesAcount/b.rechargeAmount,4)   AS threePartiesPercent,  --  三方支付充值金额/充值金额 三方实收占比
        a.rechargePeopleNum  AS payRateFenzi,  -- 付费率分子(成功人数)
        a.strategyHitNum  AS payRateFenMu,  -- 付费率分母(上一步人数)
        (b.rechargeAmount + b.adv_amount + b.third_h5_amount) AS estimatedRevenue,   --  预估收益
        ROUND(b.rechargeAmount/a.rechargePeopleNum,2)  AS arppu,  -- 充值金额/充值人数  ARPPU
        ROUND(b.rechargeAmount/b.rechargeNum,2)  AS unitPrice,  -- 充值金额/充值次数  客单价
        ROUND(b.rechargeNum/a.rechargePeopleNum,2)  AS rechargeAvg,  -- 充值次数/充值人数  人均充值次数
        ROUND((b.coin_consume + b.gift_consume)/consumNum,2)  AS totalArppu,  -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
        ROUND(b.coin_consume/consumNum,2)  AS readCoinsArppu,  -- 阅币消费金额/消费人数  阅币消费ARPPU
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
        ROUND(c.recharge_amount/c.exposure_uv,4) as oneExposureArpu, -- 单人曝光ARPU
        ROUND(c.l14_recharge_amount/c.l14_exposure_uv,4) as l14_oneExposureArpu, -- 单人曝光ARPU
        ROUND(c.l30_recharge_amount/c.l30_exposure_uv,4) as l30_oneExposureArpu, -- 单人曝光ARPU
        round(sum(c.recharge_amount) over(partition by a.exp_id, a.exp_grp_id) /sum(c.exposure_uv) over(partition by a.exp_id, a.exp_grp_id), 4) oneExposureAllArpu,
        sum(c.recharge_amount) over(partition by a.exp_id, a.exp_grp_id) as oneExposureAllArpuFenzi,
        sum(c.exposure_uv) over(partition by a.exp_id, a.exp_grp_id) as oneExposureAllArpuFenMu,
        ROUND((signin_recharge_amount+svip_recharge_amount)/c.exposure_uv,4) as oneExposureArpuDingYue, -- 单次充值占比
        ROUND(c.normal_recharge_amount/c.recharge_amount,4) as oneRechargePercent, -- 单次充值占比
        c.normal_recharge_amount as oneRechargePercentFenzi, -- 单次充值占比分子(普通充值金额)
        c.recharge_amount as oneRechargePercentFenmu, -- 单次充值占比分母(充值金额)
        ROUND((signin_recharge_amount+svip_recharge_amount)/c.recharge_amount,4) as dingYueAmountPercent, -- 订阅金额占比
        ROUND((l14_signin_recharge_amount+l14_svip_recharge_amount)/c.l14_recharge_amount,4) as l14_dingYueAmountPercent, -- 订阅金额占比
        ROUND((l30_signin_recharge_amount+l30_svip_recharge_amount)/c.l30_recharge_amount,4) as l30_dingYueAmountPercent, -- 订阅金额占比
        (signin_recharge_amount+svip_recharge_amount) as dingYueAmountPercentFenzi, -- 订阅金额占比分子(订阅金额)
        c.recharge_amount as dingYueAmountPercentFenmu, -- 订阅金额占比分母(充值金额)
        round(sum((signin_recharge_amount+svip_recharge_amount)) over(partition by a.exp_id, a.exp_grp_id) /sum(c.recharge_amount) over(partition by a.exp_id, a.exp_grp_id), 4) dingYueAmountAllPercent,
        sum((signin_recharge_amount+svip_recharge_amount)) over(partition by a.exp_id, a.exp_grp_id) as dingYueAmountAllPercentFenzi,
        sum(c.recharge_amount) over(partition by a.exp_id, a.exp_grp_id) as dingYueAmountAllPercentFenMu,
		ROUND(c.create_order_user/c.exposure_uv,4)   AS orderCreateRate, -- 订单创建率
		ROUND((c.recharge_amount/c.exposure_uv)+((signin_recharge_amount+svip_recharge_amount)/c.exposure_uv)*0.36 ,4) as predictARPU,  -- 预估ARPU
		ROUND((c.l14_recharge_amount/c.l14_exposure_uv)+((l14_signin_recharge_amount+l14_svip_recharge_amount)/c.l14_exposure_uv)*0.36 ,4) as l14_predictARPU,  -- 预估ARPU
		ROUND((c.l30_recharge_amount/c.l30_exposure_uv)+((l30_signin_recharge_amount+l30_svip_recharge_amount)/c.l30_exposure_uv)*0.36 ,4) as l30_predictARPU,  -- 预估ARPU
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
      left JOIN recharge_data_tmp c
         ON a.exp_id = c.exp_id
             AND a.exp_grp_id = c.exp_grp_id
             AND a.exp_grp_ver_id = c.exp_grp_ver_id
)
-- select * from fuzha_data_tmp

SELECT
        a.exp_id,
        a.exp_grp_id,
        e.project_id,
        a.exp_grp_ver_id,
        e.exp_name,
        e.exp_grp_name,
        e.exp_grp_type,
        d.totalNumber,
        a.strategyHitNum AS totalNumberGroup,     -- 策略命中数
        a.divideTrafficNum AS groupNum,             -- 进组人数
        a.divideTrafficNum AS includeGroupNum,      -- 入包人数
        a.divideTrafficNum,     -- 分流人数
        a.strategyHitNum,       -- 策略命中人数
        c.exposure_uv,          -- 曝光人数
        a.clickNum,
        a.viewNum,
        a.unlockNum,
		a.payUnlockNum,
        b.viewEpisodeNum,
		b.allUnlockEpisodeNum as unlockEpisodeNum,
        b.payUnlockEpisodeNum,
        c.estimatedRevenue,
        c.arpu,
        c.payRate,
        c.l14_payRate,
        c.l30_payRate,
        c.payAllRate,
        c.payAllRateFenzi,
        c.payAllRateFenMu,
        c.arppu,
        c.unitPrice,
        c.rechargeAvg,
        c.totalArppu,
        c.readCoinsArppu,
        a.rechargePeopleNum,
        b.rechargeNum,
        b.rechargeAmount,
        b.threePartiesAcount,
        c.threePartiesPercent,
        c.amountRate,
        a.consumNum,
        b.coin_consume AS readCoinsConsumAmount,
        b.gift_consume AS voucherConsumAmount,
        c.readCoinsAndVoucherApru,
        c.consumeRate,
        c.adverArpu,
        c.totalAdverArpu,
        c.adverUnlockRate,
        c.adverUnlockEpisodeNum,
        c.oneExposureArpu,
        c.l14_oneExposureArpu,
        c.l30_oneExposureArpu,
        c.oneExposureAllArpu,
        c.oneExposureAllArpuFenzi,
        c.oneExposureAllArpuFenMu,
        c.oneExposureArpuDingYue,
        c.oneRechargePercent,
	    c.dingYueAmountPercent,
	    c.l14_dingYueAmountPercent,
	    c.l30_dingYueAmountPercent,
	    c.dingYueAmountAllPercent,
        c.dingYueAmountAllPercentFenzi,
        c.dingYueAmountAllPercentFenMu,
		c.orderCreateRate,
		c.predictARPU,
		c.l14_predictARPU,
		c.l30_predictARPU,
        c.buyersNum,
	    c.buyAmount,
		a.exposureNum as episodeExposureNum,
		round(a.clickNum/a.exposureNum,6) as  clickCTR,
		c.ctr,
		c.unlockArppu,
		c.unlockArpu,
        NOW() as saveTime,
        NOW() as updateTime
FROM distinct_data_tmp a
left JOIN accumulate_data_tmp b
    ON a.exp_id = b.exp_id
    AND a.exp_grp_id = b.exp_grp_id
    AND a.exp_grp_ver_id = b.exp_grp_ver_id
left  JOIN fuzha_data_tmp c
    ON a.exp_id = c.exp_id
    AND a.exp_grp_id = c.exp_grp_id
    AND a.exp_grp_ver_id = c.exp_grp_ver_id
left JOIN exp_user_tmp d
    ON a.exp_id = d.exp_id
left JOIN dwd.dwd_ab_exp_version_detail e
    ON a.exp_id = e.exp_id
    AND a.exp_grp_id = e.exp_grp_id
    AND a.exp_grp_ver_id = e.exp_grp_ver_id
     where date(e.exp_end_time) >= '${dt}' and date(e.end_time)>='${dt}';