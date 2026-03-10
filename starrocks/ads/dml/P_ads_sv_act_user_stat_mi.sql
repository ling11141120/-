----------------------------------------------------------------
-- 程序功能： 用户统计月度表
-- 程序名： P_ads_sv_act_user_stat_mi
-- 目标表： ads.ads_sv_act_user_stat_mi
-- 负责人： qhr
-- 开发日期： 2026-03-09
----------------------------------------------------------------

insert into ads.ads_sv_act_user_stat_mi
-- 阅读用户
with t3  as(
    select date_format(a.dt, '%Y-%m-01')           as dt
         , a.login_id                              as user_id
         , count(distinct episode_id)              as watch_epis
      from (select dt
                 , login_id
                 , event_tm
                 , episode_id
                 , split(activity_link, '_')[5]    as event_strategy_id
                 , split(activity_link, '_')[8]    as activity_or_shorplay
              from ads.ads_sensors_cd_video_startwatching_view    as a1
             where date_format(dt, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
               and product_id = '6833'
               and activity_link is not null
           )                                as a
      join ods.ods_ab_hj_related            as b
        on a.event_strategy_id = b.strategy_id
      join dwd.dwd_ab_exp_version_detail    as c
       on b.ab_id = c.exp_id
      and b.version_id = c.exp_grp_id
      and a.event_tm >= c.exp_start_time
      and c.exp_end_time > a.event_tm
      and a.event_tm >= c.start_time
      and c.end_time > a.event_tm
    where a.activity_or_shorplay != 0
    group by 1, 2
)
-- 解锁用户
, t4 as (
    select date_format(a.dt, '%Y-%m-01')                as dt
         , a.login_id                                   as user_id
         , sum(a.coin_consume) + sum(a.gift_consume)    as unlock_amount
      from (select dt
                 , login_id
                 , event_tm
                 , unlock_type
                 , coin_consume
                 , gift_consume
                 , split(activity_link, '_')[5]    as event_strategy_id
                 , split(activity_link, '_')[8]    as activity_or_shorplay
            from ads.ads_sensors_cd_video_unlockEpisode_view           as a1
           where date_format(dt, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
             and product_id = '6833'
             and activity_link is not null
             and unlock_type in ('1', '2', '3', '6', '9', '10', '11')
           )                             as a
      join ods.ods_ab_hj_related         as b
        on a.event_strategy_id = b.strategy_id
      join dwd.dwd_ab_exp_version_detail as c
        on b.ab_id = c.exp_id
       and b.version_id = c.exp_grp_id
       and a.event_tm >= c.exp_start_time
       and c.exp_end_time > a.event_tm
       and a.event_tm >= c.start_time
       and c.end_time > a.event_tm
     where a.unlock_type in ('1', '2', '3', '6', '9', '10', '11')
       and a.activity_or_shorplay != 0
     group by 1, 2
)
select date_format('${bf_1_dt}', '%Y-%m-01') as dt
     , product_id
     , count(user_id)                        as totalUsers
     , avg(arpu)                             as arpuMean
     , stddev(arpu)                          as arpuSt
     , variance(arpu)                        as arpuVar
     , avg(pay_rate)                         as payRateMean
     , stddev(pay_rate)                      as payRateSt
     , variance(pay_rate)                    as payRateVar
     , avg(pay_rate)                         as payAllRateMean
     , stddev(pay_rate)                      as payAllRateSt
     , variance(pay_rate)                    as payAllRateVar
     , avg(ad_arpu)                          as adverArpuMean
     , stddev(ad_arpu)                       as adverArpuSt
     , variance(ad_arpu)                     as adverArpuVar
     , avg(total_ad_arpu)                    as totalAdverArpuMean
     , stddev(total_ad_arpu)                 as totalAdverArpuSt
     , variance(total_ad_arpu)               as totalAdverArpuVar
     , avg(ad_unlock_rate)                   as adverUnlockRateMean
     , stddev(ad_unlock_rate)                as adverUnlockRateSt
     , variance(ad_unlock_rate)              as adverUnlockRateVar
     , avg(ad_unlock_episodes_rate)          as adverUnlockEpisodeNumMean
     , stddev(ad_unlock_episodes_rate)       as adverUnlockEpisodeNumSt
     , variance(ad_unlock_episodes_rate)     as adverUnlockEpisodeNumVar
     , avg(oneExposureArpu)                  as oneExposureArpuMean
     , stddev(oneExposureArpu)               as oneExposureArpuSt
     , variance(oneExposureArpu)             as oneExposureArpuVar
     , avg(oneExposureArpu)                  as oneExposureAllArpuMean
     , stddev(oneExposureArpu)               as oneExposureAllArpuSt
     , variance(oneExposureArpu)             as oneExposureAllArpuVar
     , avg(oneExposureArpuDingYue)           as oneExposureArpuDingYueMean
     , stddev(oneExposureArpuDingYue)        as oneExposureArpuDingYueSt
     , variance(oneExposureArpuDingYue)      as oneExposureArpuDingYueVar
     , avg(oneRechargePercent)               as oneRechargePercentMean
     , stddev(oneRechargePercent)            as oneRechargePercentSt
     , variance(oneRechargePercent)          as oneRechargePercentVar
     , avg(dingYueAmountPercent)             as dingYueAmountPercentMean
     , stddev(dingYueAmountPercent)          as dingYueAmountPercentSt
     , variance(dingYueAmountPercent)        as dingYueAmountPercentVar
     , avg(dingYueAmountPercent)             as dingYueAmountAllPercentMean
     , stddev(dingYueAmountPercent)          as dingYueAmountAllPercentSt
     , variance(dingYueAmountPercent)        as dingYueAmountAllPercentVar
     , avg(orderCreateRate)                  as orderCreateRateMean
     , stddev(orderCreateRate)               as orderCreateRateSt
     , variance(orderCreateRate)             as orderCreateRateVar
     , avg(predictARPU)                      as predictARPUMean
     , stddev(predictARPU)                   as predictARPUSt
     , variance(predictARPU)                 as predictARPUVar
     , count(distinct user_id)               as buyersNum
     , sum(arpu)                             as buyAmount
     , avg(unlockArppu)                      as unlockArppuMean
     , stddev(unlockArppu)                   as unlockArppuSt
     , variance(unlockArppu)                 as unlockArppuVar
     , avg(unlockArppu)                      as unlockArpuMean
     , stddev(unlockArppu)                   as unlockArpuSt
     , variance(unlockArppu)                 as unlockArpuVar
     , now()                                 as saveTime
     , now()                                 as updateTime
     , avg(watch_epis)                       as watchEpisodeNumAvgMean
     , stddev(watch_epis)                    as watchEpisodeNumAvgSt
     , variance(watch_epis)                  as watchEpisodeNumAvgVar
  from (select case when a.product_id = 6833 then 3 end                                                    as product_id
             , a.dt
             , a.user_id
             , ifnull(b.recharge_amount, 0)                                                                as arpu
             , if(b.user_id is not null, 1, 0)                                                             as pay_rate
             , ifnull(c.ad_revenue_excluding_h5, 0)                                                        as ad_arpu
             , ifnull(c.total_ad_revenue, 0)                                                               as total_ad_arpu
             , if(d.user_id is not null, 1, 0)                                                             as ad_unlock_rate
             , ifnull(d.unlock_cnt, 0)                                                                     as ad_unlock_episodes_rate
             , ifnull(b.recharge_amount, 0)                                                                as oneExposureArpu
             , ifnull(b.signin_recharge_amount + b.svip_recharge_amount, 0)                                as oneExposureArpuDingYue
             , ifnull(b.normal_recharge_amount / b.recharge_amount, 0)                                     as oneRechargePercent
             , ifnull((b.signin_recharge_amount + b.svip_recharge_amount) / b.recharge_amount,0)           as dingYueAmountPercent
             , if(f.user_id is not null, 1, 0)                                                             as orderCreateRate
             , ifnull(b.recharge_amount + (b.signin_recharge_amount + b.svip_recharge_amount) * 0.36,0)    as predictARPU
             , ifnull(t4.unlock_amount, 0)                                                                 as unlockArppu
             , ifnull(t3.watch_epis, 0)                                                                    as watch_epis
          from (select product_id
                     , date_format(dt, '%Y-%m-01') as dt
                     , user_id
                  from dws.dws_user_short_video_wide_active_period_ed    -- 活跃用户
                 where product_id = 6833
                   and date_format(dt, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                 group by 1, 2, 3
               )      a
          left join (select date_format(dt, '%Y-%m-01')                               as dt
                          , user_id
                          , sum(base_amount) / 100                                    as recharge_amount
                          , sum(case when shop_item = 0 then base_amount end) / 100   as normal_recharge_amount
                          , sum(case when shop_item = 840 then base_amount end) / 100 as signin_recharge_amount
                          , sum(case when shop_item = 810 then base_amount end) / 100 as svip_recharge_amount
                       from ads.ads_short_video_payorder_view -- 充值
                      where test_flag = 0
                        and date_format(dt, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                      group by 1, 2
                    ) b
            on a.dt = b.dt
           and a.user_id = b.user_id
          left join (select date_format(dt, '%Y-%m-01')                       as dt
                          , user_id
                          , sum(if(sv_adp.ad_show_type_name != 'H5', amt, 0)) as ad_revenue_excluding_h5
                          , sum(amt)                                          as total_ad_revenue
                       from dws.dws_advertisement_user_position_amt_ed as t1        -- 广告收入
                       left join dim.dim_sv_ads_position_view          as sv_adp    -- 广告位ID
                         on t1.positions = sv_adp.ad_position
                      where product_id = 6833
                        and date_format(dt, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                      group by 1, 2
                    )        c
            on a.dt = c.dt
           and a.user_id = c.user_id
          left join (select date_format(create_time, '%Y-%m-01') as dt
                          , user_id
                          , count(1)                             as unlock_cnt
                       from ads.ads_short_video_series_unlock_view    -- 广告解锁
                      where date_format(create_time, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                        and not date_format(expire_time, '%Y%m%d%H%i%s') like '9999%'
                      group by 1, 2
                    )        d
            on a.dt = d.dt
           and a.user_id = d.user_id
          left join (select date_format(event_tm, '%Y-%m-01') as dt
                          , login_id                          as user_id
                       from ads.ads_sensors_cd_video_rechargeexposure_view    -- 充值档位曝光
                      where date_format(event_tm, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                      group by 1, 2
                    )        e
            on a.dt = e.dt
           and a.user_id = e.user_id
          left join (select date_format(event_tm, '%Y-%m-01') as dt
                          , login_id                          as user_id
                       from ads.ads_sensors_cd_video_ordercreateaction_view    -- 创建订单用户
                      where date_format(event_tm, '%Y-%m-01') = date_format('${bf_1_dt}', '%Y-%m-01')
                      group by 1, 2
                    )        f
            on a.dt = f.dt
           and a.user_id = f.user_id
          left join t4
            on a.dt = t4.dt
           and a.user_id = t4.user_id
          left join t3
            on a.dt = t3.dt
           and a.user_id = t3.user_id
       ) a
 group by 1, 2
;