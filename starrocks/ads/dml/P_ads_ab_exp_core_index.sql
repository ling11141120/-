----------------------------------------------------------------
-- 程序功能： AB实验核心指标表
-- 程序名： P_ads_ab_exp_core_index
-- 目标表： ads.ads_ab_exp_core_index
-- 负责人： qhr
-- 开发日期： 2026-03-09
----------------------------------------------------------------

insert into tmp.ads_ab_exp_core_index
-- 去重指标
with distinct_data_tmp as (
    select '${dt}'                                                                                                     as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1                                                                               as windowNum
         , ifnull(  sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then bitmap_count(exp_grp_users) end)
                  , 0
                 )                                                                                                     as divideTrafficNum     -- 分流人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then strategy_hit_users end)    as strategyHitNum       -- 策略命中人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then exposure_users     end)    as exposureNum          -- 曝光人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then click_users        end)    as clickNum             -- 点击人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then watch_users        end)    as viewNum              -- 观看人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_users       end)    as unlockNum            -- 解锁人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then pay_unlock_users   end)    as payUnlockNum         -- 付费解锁人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_unlock_users   end)    as adv_unlock_users     -- 广告解锁剧集人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_users     end)    as rechargePeopleNum    -- 充值人数
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then consume_users      end)    as consumNum            -- 消费人数
      from dwm.dwm_ab_exp_distinct_stat_di    as a
      left join dim.dim_date                  as b
        on a.dt >= b.datestr and b.datestr >= date_sub(a.dt, interval 30 day)
     where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
-- 累加指标
, accumulate_data_tmp as (
    select '${dt}'                                                                                             as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1                                                                       as windowNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then exp_cnt               end)    as exp_cnt                -- 曝光pv
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then clc_cnt               end)    as clc_cnt                -- 点击pv
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then watch_episodes        end)    as viewEpisodeNum         -- 观看集数
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then all_unlock_episodes   end)    as allUnlockEpisodeNum    -- 解锁集数
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_episodes       end)    as payUnlockEpisodeNum    -- 付费解锁集数
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_amount         end)    as unlock_amount          -- 解锁数量
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_amount       end)    as rechargeAmount         -- 充值金额(分成后)
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_amount_pre   end)    as rechargeAmount_pre     -- 充值金额(分成前)
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then total_adv_amount      end)    as total_adv_amount       -- 总广告收入
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_amount            end)    as adv_amount             -- 广告收入
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then third_h5_amount       end)    as third_h5_amount        -- 第三方H5收入
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then third_recharge_amount end)    as threePartiesAcount     -- 三方实收
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_times        end)    as rechargeNum            -- 充值次数
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then coin_consume          end)    as coin_consume           -- 阅币消费金额
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then gift_consume          end)    as gift_consume           -- 礼券消费金额
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_unlock_times      end)    as adv_unlock_times       -- 广告解锁剧集次数
      from dwm.dwm_ab_exp_accumulation_stat_di    as a
      left join dim.dim_date                      as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 30 day)
     where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
, recharge_data_tmp as (
    select '${dt}'                                                                                                                       as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1                                                                                                 as windowNum
         , count(distinct case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.exposure_pv > 0 then a.user_id end)          as exposure_uv
         , count(distinct case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.create_order_user > 0 then a.user_id end)    as create_order_user    -- 创建订单用户数
         , sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.recharge_amount > 0 then a.recharge_un end)             as recharge_user        -- 充值用户数
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end)                                  as recharge_amount      -- 订单金额
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.signin_recharge_amount end)                           as signin_recharge_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.svip_recharge_amount end)                             as svip_recharge_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.normal_recharge_amount end)                           as normal_recharge_amount
      from dwm.dwm_ab_exp_recharge_data_di    as a
      left join dim.dim_date                  as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 30 day)
     where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
, fuzha_data_tmp as (
    select a.exp_id                                                                                                      -- 实验ID
         , a.exp_grp_id                                                                                                  -- 实验组ID
         , a.exp_grp_ver_id                                                                                              -- 实验组ID
         , a.windowNum
         , round(b.rechargeAmount / a.strategyHitNum, 4)                                    as arpu                      -- ARPU
         , round(c.recharge_user / c.exposure_uv, 4)                                        as payRate                   -- 付费率
         , c.recharge_user                                                                  as payRateFenzi              -- 付费率分子(成功人数)
         , c.exposure_uv                                                                    as payRateFenMu              -- 付费率分母(上一步人数)
         , (b.rechargeAmount + b.adv_amount + b.third_h5_amount)                            as estimatedRevenue          -- SUM_AGG(入包人数)*(ARPU-SUM_AGG(group6_recharge_amount)/SUM_AGG(group6_uv))  预估收益
         , round(b.rechargeAmount / a.rechargePeopleNum, 2)                                 as arppu                     -- 充值金额/充值人数  ARPPU
         , round(b.rechargeAmount / b.rechargeNum, 2)                                       as unitPrice                 -- 充值金额/充值次数  客单价
         , round(b.rechargeNum / a.rechargePeopleNum, 2)                                    as rechargeAvg               -- 充值次数/充值人数  人均充值次数
         , round((b.coin_consume + b.gift_consume) / consumNum, 2)                          as totalArppu                -- 阅币消费金额+礼券消费金额/消费人数  总消费ARPPU
         , round(b.coin_consume / consumNum, 2)                                             as readCoinsArppu            -- 阅币消费金额/消费人数  阅币消费ARPPU
         , round(b.threePartiesAcount / rechargeAmount, 2)                                  as threePartiesPercent       -- 三方实收/充值金额  三方实收占比
         , round(1 - b.rechargeAmount / b.rechargeAmount_pre, 2)                            as amountRate                -- 分成后/分成前  费率
         , round((b.coin_consume + b.gift_consume) / a.strategyHitNum, 2)                   as readCoinsAndVoucherApru   -- 阅币消费金额+礼券消费金额/入包人数  阅币礼券消费ARPU
         , round(a.consumNum / a.strategyHitNum, 4)                                         as consumeRate               -- 消费人数/入包人数  消费率
         , round(b.adv_amount / a.strategyHitNum, 4)                                        as adverArpu                 -- 广告收入/入包人数  广告ARPU
         , round(b.total_adv_amount / a.strategyHitNum, 4)                                  as totalAdverArpu            -- 总广告收入/入包人数  总广告ARPU
         , round(a.adv_unlock_users / a.strategyHitNum, 4)                                  as adverUnlockRate           -- 广告解锁剧集人数/入包人数  广告解锁率
         , a.adv_unlock_users                                                               as adverUnlockRateFenzi      -- 广告解锁率分子(成功人数)
         , a.strategyHitNum                                                                 as adverUnlockRateFenmu      -- 广告解锁率分母(上一步人数)
         , round(b.adv_unlock_times / a.adv_unlock_users, 2)                                as adverUnlockEpisodeNum     -- 广告解锁剧集次数/广告解锁剧集人数  人均广告解锁剧集
         , ifnull(c.exposure_uv, 0)                                                         as exposure_uv               -- 单人曝光uv
         , ifnull(c.recharge_user, 0)                                                       as recharge_user             -- 充值用户数
         , c.recharge_amount
         , round(c.recharge_amount / c.exposure_uv, 4)                                      as oneExposureArpu           -- 单人曝光ARPU
         , round((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv,4)         as oneExposureArpuDingYue    -- 单人曝光ARPU(订阅)
         , round(c.normal_recharge_amount / c.recharge_amount, 4)                           as oneRechargePercent        -- 单次充值占比
         , c.normal_recharge_amount                                                         as oneRechargePercentFenzi   -- 单次充值占比分子(普通充值金额)
         , c.recharge_amount                                                                as oneRechargePercentFenmu   -- 单次充值占比分母(充值金额)
         , round((signin_recharge_amount + svip_recharge_amount) / c.recharge_amount,4)     as dingYueAmountPercent      -- 订阅金额占比
         , (signin_recharge_amount + svip_recharge_amount)                                  as dingYueAmountPercentFenzi -- 订阅金额占比分子(订阅金额)
         , c.recharge_amount                                                                as dingYueAmountPercentFenmu -- 订阅金额占比分母(充值金额)
         , round(c.create_order_user / c.exposure_uv, 4)                                    as orderCreateRate           -- 订单创建率
         , ifnull(c.create_order_user, 0)                                                   as orderCreateRateFenzi      -- 订单创建率分子（订单创建人数）
         , ifnull(c.exposure_uv, 0)                                                         as orderCreateRateFenmu      -- 订单创建率分母（曝光人数)
         , round(   (c.recharge_amount / c.exposure_uv)
                  + ((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv) * 0.36
                 , 4
                )                                                                           as predictARPU               -- 预估ARPU
         , ifnull(c.recharge_user, 0)                                                       as buyersNum                 -- 购买人数
         , ifnull(c.recharge_amount, 0)                                                     as buyAmount                 -- 购买金额
         , ifnull(a.exposureNum, 0)                                                         as episodeExposureNum        -- 推剧曝光人数
         , round(a.clickNum / a.exposureNum, 6)                                             as clickCTR                  -- 点击率CTR
         , round(b.clc_cnt / b.exp_cnt, 6)                                                  as ctr                       -- CTR（pv）
         , round(b.unlock_amount / a.payUnlockNum, 4)                                       as unlockArppu               -- 人均解锁ARPPU
         , round(b.unlock_amount / a.exposureNum, 4)                                        as unlockArpu                -- 人均解锁ARPU
      from distinct_data_tmp           as a
      left join accumulate_data_tmp    as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
       and a.windowNum = b.windowNum
      left join recharge_data_tmp      as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
       and a.windowNum = c.windowNum
)
-- 实验总人数
, exp_user_tmp as (
    select a.exp_id                                           -- 实验ID
         , count(distinct exp_grp_users)    as totalNumber    -- 实验总人数
      from dwm.dwm_ab_exp_distinct_stat_di    as a
      join ods.syncbi_ab_experiment           as b
        on a.exp_id = b.id
       and a.dt < b.end_time
     where a.dt >= '${dt}'
     group by 1
)
select a.exp_id
     , a.exp_grp_id
     , '${dt}'                                                                                                  as dt
     , b.project_id
     , a.exp_grp_ver_id
     , a.windowNum                                                                                              as windowNum
     , b.exp_name
     , b.exp_grp_name
     , b.exp_grp_type
     , c.totalNumber
     , a.strategyHitNum                                                                                         as totalNumberGroup
     , a.divideTrafficNum                                                                                       as groupNum
     , a.divideTrafficNum                                                                                       as includeGroupNum
     , a.divideTrafficNum                                                                                       as divideTrafficNum
     , a.strategyHitNum
     , f.exposure_uv
     , a.clickNum
     , a.viewNum
     , a.unlockNum
     , a.payUnlockNum
     , e.viewEpisodeNum
     , e.allUnlockEpisodeNum                                                                                    as unlockEpisodeNum
     , e.payUnlockEpisodeNum
     , f.estimatedRevenue
     , f.arpu
     , f.payRate
     , f.payRateFenzi
     , f.payRateFenMu
     , round(    sum(f.payRateFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)
               / sum(f.payRateFenMu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)
             , 4)                                                                                               as payAllRate
     , sum(f.payRateFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                 as payAllRateFenzi
     , sum(f.payRateFenMu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                 as payAllRateFenMu
     , f.arppu
     , f.unitPrice
     , f.rechargeAvg
     , f.totalArppu
     , f.readCoinsArppu
     , a.rechargePeopleNum
     , e.rechargeNum
     , e.rechargeAmount
     , e.threePartiesAcount
     , f.threePartiesPercent
     , f.amountRate
     , a.consumNum
     , e.coin_consume
     , e.gift_consume
     , f.readCoinsAndVoucherApru
     , f.consumeRate
     , f.adverArpu
     , f.totalAdverArpu
     , f.adverUnlockRate
     , f.adverUnlockRateFenzi
     , f.adverUnlockRateFenmu
     , f.adverUnlockEpisodeNum
     , f.oneExposureArpu
     , round(    sum(f.recharge_amount) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)
               / sum(f.exposure_uv) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)
             , 4
            )                                                                                                   as oneExposureAllArpu
     , sum(f.recharge_amount) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)              as oneExposureAllArpuFenzi
     , sum(f.exposure_uv) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                  as oneExposureAllArpuFenmu
     , f.oneExposureArpuDingYue
     , f.oneRechargePercent
     , f.oneRechargePercentFenzi
     , f.oneRechargePercentFenmu
     , f.dingYueAmountPercent
     , f.dingYueAmountPercentFenzi
     , f.dingYueAmountPercentFenmu
     , round(    sum(f.dingYueAmountPercentFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) 
               / sum(f.dingYueAmountPercentFenmu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)
             , 4
            )                                                                                                   as dingYueAmountAllPercent
     , sum(f.dingYueAmountPercentFenzi) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)    as dingYueAmountAllPercentFenzi
     , sum(f.dingYueAmountPercentFenmu) over(partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)    as dingYueAmountAllPercentFenmu
     , f.orderCreateRate
     , f.orderCreateRateFenzi
     , f.orderCreateRateFenmu
     , f.predictARPU
     , f.buyersNum
     , f.buyAmount
     , a.exposureNum                                                                                            as episodeExposureNum
     , round(a.clickNum / a.exposureNum, 6)                                                                     as clickCTR
     , f.ctr
     , f.unlockArppu
     , f.unlockArpu
     , now()                                                                                                    as saveTime
     , now()                                                                                                    as updateTime
     , b.start_time
     , b.end_time
     , round(e.viewEpisodeNum / a.viewNum, 6)                                                                   as watchEpisodeNumAvg
  from distinct_data_tmp                     as a
  left join dwd.dwd_ab_exp_version_detail    as b
    on a.exp_id = b.exp_id
   and a.exp_grp_id = b.exp_grp_id
   and a.exp_grp_ver_id = b.exp_grp_ver_id
  left join exp_user_tmp                     as c
    on a.exp_id = c.exp_id
  left join accumulate_data_tmp              as e
    on a.exp_id = e.exp_id
   and a.exp_grp_id = e.exp_grp_id
   and a.exp_grp_ver_id = e.exp_grp_ver_id
   and a.windowNum = e.windowNum
  left join fuzha_data_tmp                   as f
    on a.exp_id = f.exp_id
   and a.exp_grp_id = f.exp_grp_id
   and a.exp_grp_ver_id = f.exp_grp_ver_id
   and a.windowNum = f.windowNum
 where date(b.end_time)>='${dt}'
   and date(b.exp_end_time)>='${dt}'
;