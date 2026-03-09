----------------------------------------------------------------
-- 程序功能： AB实验核心指标表
-- 程序名： P_ads_ab_exp_core_index_stream
-- 目标表： ads.ads_ab_exp_core_index_stream
-- 负责人： qhr
-- 开发日期： 2026-03-09
----------------------------------------------------------------

insert into tmp.ads_ab_exp_core_index_stream
-- 实验总人数
with exp_user_tmp as (
    select a.exp_id                                          -- 实验ID
         , count(distinct a.exp_grp_users)    as totalNumber -- 实验总人数
      from dwm.dwm_ab_exp_distinct_stat_di as a
      join ods.syncbi_ab_experiment        as b
        on a.exp_id = b.id
       and a.dt <= date(b.end_time)
     group by 1
)
-- 去重指标
, distinct_data_tmp as (
    select a.exp_id                                                   -- 实验ID
         , a.exp_grp_id                                               -- 实验组ID
         , a.exp_grp_ver_id                                           -- 实验组ID
         , count(distinct exp_grp_users)         as divideTrafficNum  -- 分流人数
         , count(distinct strategy_hit_users)    as strategyHitNum    -- 策略命中人数
         , count(distinct exposure_users)        as exposureNum       -- 曝光人数
         , count(distinct click_users)           as clickNum          -- 点击人数
         , count(distinct watch_users)           as viewNum           -- 观看人数
         , count(distinct unlock_users)          as unlockNum         -- 解锁人数
         , count(distinct pay_unlock_users)      as payUnlockNum      -- 付费解锁人数
         , count(distinct adv_unlock_users)      as adv_unlock_users  -- 广告解锁剧集人数
         , count(distinct recharge_users)        as rechargePeopleNum -- 充值人数
         , count(distinct consume_users)         as consumNum         -- 消费人数
      from dwm.dwm_ab_exp_distinct_stat_di    as a
      join dwd.dwd_ab_exp_version_detail      as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
     where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
-- 累加指标
, accumulate_data_tmp as (
    select a.exp_id                                             -- 实验ID
         , a.exp_grp_id                                         -- 实验组ID
         , a.exp_grp_ver_id                                     -- 实验组ID
         , sum(exp_cnt)                  as exp_cnt             -- 曝光次数
         , sum(clc_cnt)                  as clc_cnt             -- 点击次数
         , sum(watch_episodes)           as viewEpisodeNum      -- 观看集数
         , sum(all_unlock_episodes)      as allUnlockEpisodeNum -- 解锁集数
         , sum(unlock_episodes)          as payUnlockEpisodeNum -- 付费解锁集数
         , sum(unlock_amount)            as unlock_amount       -- 解锁数量
         , sum(recharge_amount)          as rechargeAmount      -- 充值金额(分成后)
         , sum(recharge_amount_pre)      as rechargeAmount_pre  -- 充值金额(分成前)
         , sum(total_adv_amount)         as total_adv_amount    -- 总广告收入
         , sum(adv_amount)               as adv_amount          -- 广告收入
         , sum(third_h5_amount)          as third_h5_amount     -- 第三方H5收入
         , sum(third_recharge_amount)    as threePartiesAcount  -- 三方实收
         , sum(recharge_times)           as rechargeNum         -- 充值次数
         , sum(coin_consume)             as coin_consume        -- 阅币消费金额
         , sum(gift_consume)             as gift_consume        -- 礼券消费金额
         , sum(adv_unlock_times)         as adv_unlock_times    -- 广告解锁剧集次数
      from dwm.dwm_ab_exp_accumulation_stat_di    as a
      join dwd.dwd_ab_exp_version_detail          as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
     where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
, recharge_data_tmp as (
    select a.exp_id                                                                                                                                                                         -- 实验ID
         , a.exp_grp_id                                                                                                                                                                     -- 实验组ID
         , a.exp_grp_ver_id                                                                                                                                                                 -- 实验组ID
         , count(distinct case when a.exposure_pv > 0 then a.user_id end)                                                                                     as exposure_uv                -- 充值曝光uv
         , sum(case when a.recharge_amount > 0 then a.recharge_un end)                                                                                        as recharge_user              -- 充值用户数
         , count(distinct case when a.create_order_user > 0 then a.user_id end)                                                                               as create_order_user          -- 创建订单用户数
         , count(distinct case when a.exposure_pv > 0 then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.user_id, null) end)    as l14_exposure_uv            -- 充值曝光uv
         , count(distinct case when a.exposure_pv > 0 then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.user_id, null) end)    as l30_exposure_uv            -- 充值曝光uv
         , sum(case when a.recharge_amount > 0 then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_un, 0) end)          as l14_recharge_user          -- 充值用户数
         , sum(case when a.recharge_amount > 0 then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_un, 0) end)          as l30_recharge_user          -- 充值用户数
         , sum(a.recharge_amount)                                                                                                                             as recharge_amount            -- 充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_amount, 0))                                               as l14_recharge_amount        -- 充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_amount, 0))                                               as l30_recharge_amount        -- 充值金额
         , sum(a.signin_recharge_amount)                                                                                                                      as signin_recharge_amount     -- 签到卡-充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.signin_recharge_amount, 0))                                        as l14_signin_recharge_amount -- 签到卡-充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.signin_recharge_amount, 0))                                        as l30_signin_recharge_amount -- 签到卡-充值金额
         , sum(a.svip_recharge_amount)                                                                                                                        as svip_recharge_amount       -- SVIP-充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.svip_recharge_amount, 0))                                          as l14_svip_recharge_amount   -- SVIP-充值金额
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.svip_recharge_amount, 0))                                          as l30_svip_recharge_amount   -- SVIP-充值金额
         , sum(a.normal_recharge_amount)                                                                                                                      as normal_recharge_amount     -- 普通充值金额
      from dwm.dwm_ab_exp_recharge_data_di       as a
      left join dwd.dwd_ab_exp_version_detail    as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
     where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
-- 派生指标
, fuzha_data_tmp as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , round(b.rechargeAmount / a.strategyHitNum, 4)                                                      as arpu                      -- ARPU
         , round(c.recharge_user / c.exposure_uv, 4)                                                          as payRate                   -- 付费率
         , round(c.l14_recharge_user / c.l14_exposure_uv, 4)                                                  as l14_payRate               -- 付费率
         , round(c.l30_recharge_user / c.l30_exposure_uv, 4)                                                  as l30_payRate               -- 付费率
         , round(    sum(c.recharge_user) over (partition by a.exp_id, a.exp_grp_id)
                   / sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)
                 , 4
                )                                                                                             as payAllRate
         , sum(c.recharge_user) over (partition by a.exp_id, a.exp_grp_id)                                    as payAllRateFenzi
         , sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)                                      as payAllRateFenMu
         , round(b.threePartiesAcount / b.rechargeAmount, 4)                                                  as threePartiesPercent       --  三方支付充值金额/充值金额 三方实收占比
         , a.rechargePeopleNum                                                                                as payRateFenzi              -- 付费率分子(成功人数)
         , a.strategyHitNum                                                                                   as payRateFenMu              -- 付费率分母(上一步人数)
         , (b.rechargeAmount + b.adv_amount + b.third_h5_amount)                                              as estimatedRevenue          --  预估收益
         , round(b.rechargeAmount / a.rechargePeopleNum, 2)                                                   as arppu                     -- 充值金额/充值人数  ARPPU
         , round(b.rechargeAmount / b.rechargeNum, 2)                                                         as unitPrice                 -- 充值金额/充值次数  客单价
         , round(b.rechargeNum / a.rechargePeopleNum, 2)                                                      as rechargeAvg               -- 充值次数/充值人数  人均充值次数
         , round((b.coin_consume + b.gift_consume) / consumNum, 2)                                            as totalArppu                -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
         , round(b.coin_consume / consumNum, 2)                                                               as readCoinsArppu            -- 阅币消费金额/消费人数  阅币消费ARPPU
         , round(1 - b.rechargeAmount / b.rechargeAmount_pre, 2)                                              as amountRate                -- 分成后/分成前  费率
         , round((b.coin_consume + b.gift_consume) / a.strategyHitNum, 2)                                     as readCoinsAndVoucherApru   -- 阅币消费金额+礼券消费金额/入包人数  阅币礼券消费ARPU
         , round(a.consumNum / a.strategyHitNum, 4)                                                           as consumeRate               -- 消费人数/入包人数  消费率
         , round(b.adv_amount / a.strategyHitNum, 4)                                                          as adverArpu                 -- 广告收入/入包人数  广告ARPU
         , round(b.total_adv_amount / a.strategyHitNum, 4)                                                    as totalAdverArpu            -- 总广告收入/入包人数  总广告ARPU
         , round(a.adv_unlock_users / a.strategyHitNum, 4)                                                    as adverUnlockRate           -- 广告解锁剧集人数/入包人数  广告解锁率
         , a.adv_unlock_users                                                                                 as adverUnlockRateFenzi      -- 广告解锁率分子(成功人数)
         , a.strategyHitNum                                                                                   as adverUnlockRateFenmu      -- 广告解锁率分母(上一步人数)
         , round(b.adv_unlock_times / a.adv_unlock_users, 2)                                                  as adverUnlockEpisodeNum     -- 广告解锁剧集次数/广告解锁剧集人数  人均广告解锁剧集
         , ifnull(c.exposure_uv, 0)                                                                           as exposure_uv               -- 单人曝光uv
         , round(c.recharge_amount / c.exposure_uv, 4)                                                        as oneExposureArpu           -- 单人曝光ARPU
         , round(c.l14_recharge_amount / c.l14_exposure_uv, 4)                                                as l14_oneExposureArpu       -- 单人曝光ARPU
         , round(c.l30_recharge_amount / c.l30_exposure_uv, 4)                                                as l30_oneExposureArpu       -- 单人曝光ARPU
         , round(   sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)
                  / sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)
                 ,4
                )                                                                                             as oneExposureAllArpu
         , sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)                                  as oneExposureAllArpuFenzi
         , sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)                                      as oneExposureAllArpuFenMu
         , round((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv,4)                           as oneExposureArpuDingYue    -- 单次充值占比
         , round(c.normal_recharge_amount / c.recharge_amount, 4)                                             as oneRechargePercent        -- 单次充值占比
         , c.normal_recharge_amount                                                                           as oneRechargePercentFenzi   -- 单次充值占比分子(普通充值金额)
         , c.recharge_amount                                                                                  as oneRechargePercentFenmu   -- 单次充值占比分母(充值金额)
         , round((signin_recharge_amount + svip_recharge_amount) / c.recharge_amount,4)                       as dingYueAmountPercent      -- 订阅金额占比
         , round((l14_signin_recharge_amount + l14_svip_recharge_amount) / c.l14_recharge_amount, 4)          as l14_dingYueAmountPercent  -- 订阅金额占比
         , round((l30_signin_recharge_amount + l30_svip_recharge_amount) / c.l30_recharge_amount,4)           as l30_dingYueAmountPercent  -- 订阅金额占比
         , (signin_recharge_amount + svip_recharge_amount)                                                    as dingYueAmountPercentFenzi -- 订阅金额占比分子(订阅金额)
         , c.recharge_amount                                                                                  as dingYueAmountPercentFenmu -- 订阅金额占比分母(充值金额)
         , round(   sum((signin_recharge_amount + svip_recharge_amount)) over (partition by a.exp_id, a.exp_grp_id)
                  / sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)
                 ,4
                )                                                                                             as dingYueAmountAllPercent
         , sum((signin_recharge_amount + svip_recharge_amount)) over (partition by a.exp_id, a.exp_grp_id)    as dingYueAmountAllPercentFenzi
         , sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)                                  as dingYueAmountAllPercentFenMu
         , round(c.create_order_user / c.exposure_uv, 4)                                                      as orderCreateRate           -- 订单创建率
         , round(    (c.recharge_amount / c.exposure_uv)
                   + ((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv) * 0.36
                 , 4
                )                                                                                             as predictARPU               -- 预估ARPU
         , round(    (c.l14_recharge_amount / c.l14_exposure_uv)
                   + ((l14_signin_recharge_amount + l14_svip_recharge_amount) / c.l14_exposure_uv) * 0.36
                 , 4
                )                                                                                             as l14_predictARPU           -- 预估ARPU
         , round(    (c.l30_recharge_amount / c.l30_exposure_uv)
                   + ((l30_signin_recharge_amount + l30_svip_recharge_amount) / c.l30_exposure_uv) * 0.36
                 , 4
                )                                                                                             as l30_predictARPU           -- 预估ARPU
         , ifnull(c.recharge_user, 0)                                                                         as buyersNum                 -- 购买人数
         , ifnull(c.recharge_amount, 0)                                                                       as buyAmount                 -- 购买金额
         , ifnull(a.exposureNum, 0)                                                                           as episodeExposureNum        -- 推剧曝光人数
         , round(a.clickNum / a.exposureNum, 6)                                                               as clickCTR                  -- 点击率CTR
         , round(b.clc_cnt / b.exp_cnt, 6)                                                                    as ctr                       -- CTR（pv）
         , round(b.unlock_amount / a.payUnlockNum, 4)                                                         as unlockArppu               -- 人均解锁ARPPU
         , round(b.unlock_amount / a.exposureNum, 4)                                                          as unlockArpu                -- 人均解锁ARPU
      from distinct_data_tmp           as a
      left join accumulate_data_tmp    as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
      left join recharge_data_tmp      as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
)
select a.exp_id
     , a.exp_grp_id
     , e.project_id
     , a.exp_grp_ver_id
     , e.exp_name
     , e.exp_grp_name
     , e.exp_grp_type
     , d.totalNumber
     , a.strategyHitNum                          as totalNumberGroup -- 策略命中数
     , a.divideTrafficNum                        as groupNum         -- 进组人数
     , a.divideTrafficNum                        as includeGroupNum  -- 入包人数
     , a.divideTrafficNum                                            -- 分流人数
     , a.strategyHitNum                                              -- 策略命中人数
     , c.exposure_uv                                                 -- 曝光人数
     , a.clickNum
     , a.viewNum
     , a.unlockNum
     , a.payUnlockNum
     , b.viewEpisodeNum
     , b.allUnlockEpisodeNum                     as unlockEpisodeNum
     , b.payUnlockEpisodeNum
     , c.estimatedRevenue
     , c.arpu
     , c.payRate
     , c.l14_payRate
     , c.l30_payRate
     , c.payAllRate
     , c.payAllRateFenzi
     , c.payAllRateFenMu
     , c.arppu
     , c.unitPrice
     , c.rechargeAvg
     , c.totalArppu
     , c.readCoinsArppu
     , a.rechargePeopleNum
     , b.rechargeNum
     , b.rechargeAmount
     , b.threePartiesAcount
     , c.threePartiesPercent
     , c.amountRate
     , a.consumNum
     , b.coin_consume                            as readCoinsConsumAmount
     , b.gift_consume                            as voucherConsumAmount
     , c.readCoinsAndVoucherApru
     , c.consumeRate
     , c.adverArpu
     , c.totalAdverArpu
     , c.adverUnlockRate
     , c.adverUnlockEpisodeNum
     , c.oneExposureArpu
     , c.l14_oneExposureArpu
     , c.l30_oneExposureArpu
     , c.oneExposureAllArpu
     , c.oneExposureAllArpuFenzi
     , c.oneExposureAllArpuFenMu
     , c.oneExposureArpuDingYue
     , c.oneRechargePercent
     , c.dingYueAmountPercent
     , c.l14_dingYueAmountPercent
     , c.l30_dingYueAmountPercent
     , c.dingYueAmountAllPercent
     , c.dingYueAmountAllPercentFenzi
     , c.dingYueAmountAllPercentFenMu
     , c.orderCreateRate
     , c.predictARPU
     , c.l14_predictARPU
     , c.l30_predictARPU
     , c.buyersNum
     , c.buyAmount
     , a.exposureNum                             as episodeExposureNum
     , round(a.clickNum / a.exposureNum, 6)      as clickCTR
     , c.ctr
     , c.unlockArppu
     , c.unlockArpu
     , NOW()                                     as saveTime
     , NOW()                                     as updateTime
     , round(b.viewEpisodeNum / a.viewNum, 6)    as watchEpisodeNumAvg
  from distinct_data_tmp                     as a
  left join accumulate_data_tmp              as b
    on a.exp_id = b.exp_id
   and a.exp_grp_id = b.exp_grp_id
   and a.exp_grp_ver_id = b.exp_grp_ver_id
  left join fuzha_data_tmp                   as c
    on a.exp_id = c.exp_id
   and a.exp_grp_id = c.exp_grp_id
   and a.exp_grp_ver_id = c.exp_grp_ver_id
  left join exp_user_tmp                     as d
    on a.exp_id = d.exp_id
  left join dwd.dwd_ab_exp_version_detail    as e
    on a.exp_id = e.exp_id
   and a.exp_grp_id = e.exp_grp_id
   and a.exp_grp_ver_id = e.exp_grp_ver_id
 where date(e.exp_end_time) >= '${dt}'
   and date(e.end_time) >= '${dt}'
;