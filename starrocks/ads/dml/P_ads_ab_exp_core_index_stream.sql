----------------------------------------------------------------
-- 程序功能： 
-- 程序名： P_ads_ab_exp_core_index_stream
-- 目标表： ads.ads_ab_exp_core_index_stream
-- 负责人： tyg
-- 开发日期：2026-06-25
----------------------------------------------------------------

insert into ads.ads_ab_exp_core_index_stream
-- 海阅实验分组映射（公共CTE）
with hj_exp_mapping as (
    select a.login_id
         , c.exp_id
         , c.exp_grp_id
      from (select login_id
              from ads.ads_sensors_production_itemexposure_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union

            select login_id
              from ads.ads_sensors_production_itemclick_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union

            select login_id
              from ads.ads_sensors_production_startreadingchapter_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and activity_link is not null

union

            select identity_login_id as login_id
              from ads.ads_sensors_production_unlockchapter_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and activity_link is not null

union

            select login_id
              from ads.ads_sensors_production_rechargeexposure_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = 5

union

            select user_id as login_id
              from ads.ads_trade_user_payorder_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and test_flag = 0
           ) as a
      inner join (select 276    as exp_id
                       , 214160 as exp_grp_id
                       , 0      as grp_idx

union all

                  select 276
                       , 558230
                       , 2

union all

                  select 120033
                       , 423421
                       , 1

union all

                  select 120033
                       , 824626
                       , 3
                 ) as c
        on mod(abs(murmur_hash3_32(a.login_id)), 4) = c.grp_idx
)
-- 实验总人数
, exp_user_tmp as (
    select a.exp_id
         , count(distinct a.exp_grp_users) as totalNumber
      from dwm.dwm_ab_exp_distinct_stat_di as a
      join ods.syncbi_ab_experiment as b
        on a.exp_id = b.id
       and a.dt <= date(b.end_time)
     group by 1

union all

    select c.exp_id
         , count(distinct a.login_id) as totalNumber
      from ads.ads_sensors_production_itemexposure_view as a
      inner join hj_exp_mapping as c
        on a.login_id = c.login_id
      inner join dwd.dwd_ab_exp_version_detail as d
        on c.exp_id = d.exp_id
       and c.exp_grp_id = d.exp_grp_id
       and a.event_tm >= d.exp_start_time
       and d.exp_end_time > a.event_tm
where a.dt >= date_add('${dt}', -7)
       and a.dt < date_add('${dt}', 1)
       and a.project_id = '5'
     group by c.exp_id
)
-- 海剧分支
-- 去重指标
, distinct_data_tmp_haiju as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , count(distinct exp_grp_users)      as divideTrafficNum
         , count(distinct strategy_hit_users) as strategyHitNum
         , count(distinct exposure_users)     as exposureNum
         , count(distinct click_users)        as clickNum
         , count(distinct watch_users)        as viewNum
         , count(distinct unlock_users)       as unlockNum
         , count(distinct pay_unlock_users)   as payUnlockNum
         , count(distinct adv_unlock_users)   as adv_unlock_users
         , count(distinct recharge_users)     as rechargePeopleNum
         , count(distinct consume_users)      as consumNum
      from dwm.dwm_ab_exp_distinct_stat_di as a
      join dwd.dwd_ab_exp_version_detail as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
    where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
-- 海阅分支
, distinct_data_tmp_hy as (
    select c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , null                                as divideTrafficNum
         , count(distinct a.strategy_hit_user) as strategyHitNum
         , count(distinct a.exposure_user)     as exposureNum
         , count(distinct a.click_user)        as clickNum
         , count(distinct a.watch_user)        as viewNum
         , count(distinct a.unlock_user)       as unlockNum
         , null                                as payUnlockNum
         , null                                as adv_unlock_users
         , null                                as rechargePeopleNum
         , null                                as consumNum
      from (select a.login_id as strategy_hit_user
                 , a.login_id as exposure_user
                 , null       as click_user
                 , null       as watch_user
                 , null       as unlock_user
                 , a.event_tm
              from ads.ads_sensors_production_itemexposure_view as a
             where a.dt >= date_add('${dt}', -7)
               and a.dt < date_add('${dt}', 1)
               and a.project_id = '5'

union all

            select a.login_id
                 , null
                 , a.login_id
                 , null
                 , null
                 , a.event_tm
              from ads.ads_sensors_production_itemclick_view as a
             where a.dt >= date_add('${dt}', -7)
               and a.dt < date_add('${dt}', 1)
               and a.project_id = '5'

union all

            select a.login_id
                 , null
                 , null
                 , a.login_id
                 , null
                 , a.event_tm
              from ads.ads_sensors_production_startreadingchapter_view as a
             where a.dt >= date_add('${dt}', -7)
               and a.dt < date_add('${dt}', 1)
               and a.activity_link is not null

union all

            select a.identity_login_id
                 , null
                 , null
                 , null
                 , a.identity_login_id
                 , a.event_tm
              from ads.ads_sensors_production_unlockchapter_view as a
             where a.dt >= date_add('${dt}', -7)
               and a.dt < date_add('${dt}', 1)
               and a.activity_link is not null
           ) as a
      inner join hj_exp_mapping as c
        on a.strategy_hit_user = c.login_id
      inner join dwd.dwd_ab_exp_version_detail as d
        on c.exp_id = d.exp_id
       and c.exp_grp_id = d.exp_grp_id
       and a.event_tm >= d.exp_start_time
       and d.exp_end_time > a.event_tm
     group by 1, 2, 3
)
-- 合并CTE
, distinct_data_tmp as (
    select *
      from distinct_data_tmp_haiju

union all

    select *
      from distinct_data_tmp_hy
)
-- 累加指标
, accumulate_data_tmp_haiju as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , sum(exp_cnt)               as exp_cnt
         , sum(clc_cnt)               as clc_cnt
         , sum(watch_episodes)        as viewEpisodeNum
         , sum(all_unlock_episodes)   as allUnlockEpisodeNum
         , sum(unlock_episodes)       as payUnlockEpisodeNum
         , sum(unlock_amount)         as unlock_amount
         , sum(recharge_amount)       as rechargeAmount
         , sum(recharge_amount_pre)   as rechargeAmount_pre
         , sum(total_adv_amount)      as total_adv_amount
         , sum(adv_amount)            as adv_amount
         , sum(third_h5_amount)       as third_h5_amount
         , sum(third_recharge_amount) as threePartiesAcount
         , sum(recharge_times)        as rechargeNum
         , sum(coin_consume)          as coin_consume
         , sum(gift_consume)          as gift_consume
         , sum(adv_unlock_times)      as adv_unlock_times
      from dwm.dwm_ab_exp_accumulation_stat_di as a
      join dwd.dwd_ab_exp_version_detail as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
    where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
-- 海阅分支
, accumulate_data_tmp_hy as (
    select c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , sum(case when a.event_type = 'exposure' then 1 end) as exp_cnt
         , sum(case when a.event_type = 'click' then 1 end) as clc_cnt
         , sum(case when a.event_type = 'watch' then 1 end) as viewEpisodeNum
         , sum(case when a.event_type = 'unlock' then 1 end) as allUnlockEpisodeNum
         , null             as payUnlockEpisodeNum
         , null             as unlock_amount
         , null             as rechargeAmount
         , null             as rechargeAmount_pre
         , null             as total_adv_amount
         , null             as adv_amount
         , null             as third_h5_amount
         , null             as threePartiesAcount
         , null             as rechargeNum
         , null             as coin_consume
         , null             as gift_consume
         , null             as adv_unlock_times
      from (select login_id
                 , event_tm
                 , 'exposure' as event_type
              from ads.ads_sensors_production_itemexposure_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union all

            select login_id
                 , event_tm
                 , 'click'  as event_type
              from ads.ads_sensors_production_itemclick_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union all

            select login_id
                 , event_tm
                 , 'watch'  as event_type
              from ads.ads_sensors_production_startreadingchapter_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and activity_link is not null

union all

            select identity_login_id as login_id
                 , event_tm
                 , 'unlock'          as event_type
              from ads.ads_sensors_production_unlockchapter_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and activity_link is not null
           ) as a
      inner join hj_exp_mapping as c
        on a.login_id = c.login_id
      inner join dwd.dwd_ab_exp_version_detail as d
        on c.exp_id = d.exp_id
       and c.exp_grp_id = d.exp_grp_id
       and a.event_tm >= d.exp_start_time
       and d.exp_end_time > a.event_tm
     group by 1, 2, 3
)
-- 合并CTE
, accumulate_data_tmp as (
    select *
      from accumulate_data_tmp_haiju

union all

    select *
      from accumulate_data_tmp_hy
)
, recharge_data_tmp_haiju as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , count(distinct case when a.exposure_pv > 0 then a.user_id end)                                              as exposure_uv
         , sum(case when a.recharge_amount > 0 then a.recharge_un end)                                                 as recharge_user
         , count(distinct case when a.create_order_user > 0 then a.user_id end)                                        as create_order_user
         , count(distinct case when a.exposure_pv > 0 then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.user_id, null) end) as l14_exposure_uv
         , count(distinct case when a.exposure_pv > 0 then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.user_id, null) end) as l30_exposure_uv
         , sum(case when a.recharge_amount > 0 then if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_un, 0) end) as l14_recharge_user
         , sum(case when a.recharge_amount > 0 then if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_un, 0) end) as l30_recharge_user
         , sum(a.recharge_amount)                                                                                      as recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.recharge_amount, 0))        as l14_recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.recharge_amount, 0))        as l30_recharge_amount
         , sum(a.signin_recharge_amount)                                                                               as signin_recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.signin_recharge_amount, 0)) as l14_signin_recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.signin_recharge_amount, 0)) as l30_signin_recharge_amount
         , sum(a.svip_recharge_amount)                                                                                 as svip_recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 14 day), b.end_time), a.svip_recharge_amount, 0))   as l14_svip_recharge_amount
         , sum(if(a.dt < least(date_add(date(start_time), interval 30 day), b.end_time), a.svip_recharge_amount, 0))   as l30_svip_recharge_amount
         , sum(a.normal_recharge_amount)                                                                               as normal_recharge_amount
      from dwm.dwm_ab_exp_recharge_data_di as a
      left join dwd.dwd_ab_exp_version_detail as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
    where a.dt <= date(b.exp_end_time)
     group by 1, 2, 3
)
-- 海阅分支
, recharge_data_tmp_hy as (
    select c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , count(distinct a.user_id) as exposure_uv
         , count(distinct case when e.recharge_amount > 0 then e.user_id end) as recharge_user
         , null                      as create_order_user
         , null                      as l14_exposure_uv
         , null                      as l30_exposure_uv
         , null                      as l14_recharge_user
         , null                      as l30_recharge_user
         , sum(e.recharge_amount)    as recharge_amount
         , null                      as l14_recharge_amount
         , null                      as l30_recharge_amount
         , null                      as signin_recharge_amount
         , null                      as l14_signin_recharge_amount
         , null                      as l30_signin_recharge_amount
         , null                      as svip_recharge_amount
         , null                      as l14_svip_recharge_amount
         , null                      as l30_svip_recharge_amount
         , null                      as normal_recharge_amount
      from (select dt
                 , login_id as user_id
              from ads.ads_sensors_production_rechargeexposure_view
             where project_id = 5
               and dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
             group by 1, 2
           ) as a
      inner join hj_exp_mapping as c
        on a.user_id = c.login_id
      inner join dwd.dwd_ab_exp_version_detail as d
        on c.exp_id = d.exp_id
       and c.exp_grp_id = d.exp_grp_id
       and a.dt >= date(d.exp_start_time)
       and date(d.exp_end_time) > a.dt
       and a.dt >= date(d.start_time)
       and date(d.end_time) > a.dt
      left join (select dt
                      , user_id
                      , sum(base_amount) / 100 as recharge_amount
                   from ads.ads_trade_user_payorder_view
                  where test_flag = 0
                    and dt >= date_add('${dt}', -7)
                    and dt < date_add('${dt}', 1)
                  group by 1, 2
                ) as e
        on a.user_id = e.user_id
       and a.dt = e.dt
     group by 1, 2, 3
)
-- 合并CTE
, recharge_data_tmp as (
    select *
      from recharge_data_tmp_haiju

union all

    select *
      from recharge_data_tmp_hy
)
-- 派生指标
, fuzha_data_tmp as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , round(b.rechargeAmount / a.strategyHitNum, 4)                                                                                                                                    as arpu
         , round(c.recharge_user / c.exposure_uv, 4)                                                                                                                                        as payRate
         , round(c.l14_recharge_user / c.l14_exposure_uv, 4)                                                                                                                                as l14_payRate
         , round(c.l30_recharge_user / c.l30_exposure_uv, 4)                                                                                                                                as l30_payRate
         , round( sum(c.recharge_user) over (partition by a.exp_id, a.exp_grp_id) / sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id) , 4 )                                     as payAllRate
         , sum(c.recharge_user) over (partition by a.exp_id, a.exp_grp_id)                                                                                                                  as payAllRateFenzi
         , sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)                                                                                                                    as payAllRateFenMu
         , round(b.threePartiesAcount / b.rechargeAmount, 4)                                                                                                                                as threePartiesPercent
         , a.rechargePeopleNum                                                                                                                                                              as payRateFenzi
         , a.strategyHitNum                                                                                                                                                                 as payRateFenMu
         , (b.rechargeAmount + b.adv_amount + b.third_h5_amount)                                                                                                                            as estimatedRevenue
         , round(b.rechargeAmount / a.rechargePeopleNum, 2)                                                                                                                                 as arppu
         , round(b.rechargeAmount / b.rechargeNum, 2)                                                                                                                                       as unitPrice
         , round(b.rechargeNum / a.rechargePeopleNum, 2)                                                                                                                                    as rechargeAvg
         , round((b.coin_consume + b.gift_consume) / consumNum, 2)                                                                                                                          as totalArppu
         , round(b.coin_consume / consumNum, 2)                                                                                                                                             as readCoinsArppu
         , round(1 - b.rechargeAmount / b.rechargeAmount_pre, 2)                                                                                                                            as amountRate
         , round((b.coin_consume + b.gift_consume) / a.strategyHitNum, 2)                                                                                                                   as readCoinsAndVoucherApru
         , round(a.consumNum / a.strategyHitNum, 4)                                                                                                                                         as consumeRate
         , round(b.adv_amount / a.strategyHitNum, 4)                                                                                                                                        as adverArpu
         , round(b.total_adv_amount / a.strategyHitNum, 4)                                                                                                                                  as totalAdverArpu
         , round(a.adv_unlock_users / a.strategyHitNum, 4)                                                                                                                                  as adverUnlockRate
         , a.adv_unlock_users                                                                                                                                                               as adverUnlockRateFenzi
         , a.strategyHitNum                                                                                                                                                                 as adverUnlockRateFenmu
         , round(b.adv_unlock_times / a.adv_unlock_users, 2)                                                                                                                                as adverUnlockEpisodeNum
         , ifnull(c.exposure_uv, 0)                                                                                                                                                         as exposure_uv
         , round(c.recharge_amount / c.exposure_uv, 4)                                                                                                                                      as oneExposureArpu
         , round(c.l14_recharge_amount / c.l14_exposure_uv, 4)                                                                                                                              as l14_oneExposureArpu
         , round(c.l30_recharge_amount / c.l30_exposure_uv, 4)                                                                                                                              as l30_oneExposureArpu
         , round( sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id) / sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id) , 4 )                                   as oneExposureAllArpu
         , sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)                                                                                                                as oneExposureAllArpuFenzi
         , sum(c.exposure_uv) over (partition by a.exp_id, a.exp_grp_id)                                                                                                                    as oneExposureAllArpuFenMu
         , round((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv, 4)                                                                                                        as oneExposureArpuDingYue
         , round(c.normal_recharge_amount / c.recharge_amount, 4)                                                                                                                           as oneRechargePercent
         , c.normal_recharge_amount                                                                                                                                                         as oneRechargePercentFenzi
         , c.recharge_amount                                                                                                                                                                as oneRechargePercentFenmu
         , round((signin_recharge_amount + svip_recharge_amount) / c.recharge_amount, 4)                                                                                                    as dingYueAmountPercent
         , round((l14_signin_recharge_amount + l14_svip_recharge_amount) / c.l14_recharge_amount, 4)                                                                                        as l14_dingYueAmountPercent
         , round((l30_signin_recharge_amount + l30_svip_recharge_amount) / c.l30_recharge_amount, 4)                                                                                        as l30_dingYueAmountPercent
         , (signin_recharge_amount + svip_recharge_amount)                                                                                                                                  as dingYueAmountPercentFenzi
         , c.recharge_amount                                                                                                                                                                as dingYueAmountPercentFenmu
         , round( sum((signin_recharge_amount + svip_recharge_amount)) over (partition by a.exp_id, a.exp_grp_id) / sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id) , 4 ) as dingYueAmountAllPercent
         , sum((signin_recharge_amount + svip_recharge_amount)) over (partition by a.exp_id, a.exp_grp_id)                                                                                  as dingYueAmountAllPercentFenzi
         , sum(c.recharge_amount) over (partition by a.exp_id, a.exp_grp_id)                                                                                                                as dingYueAmountAllPercentFenMu
         , round(c.create_order_user / c.exposure_uv, 4)                                                                                                                                    as orderCreateRate
         , round( (c.recharge_amount / c.exposure_uv) + ((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv) * 0.36 , 4 )                                                      as predictARPU
         , round( (c.l14_recharge_amount / c.l14_exposure_uv) + ((l14_signin_recharge_amount + l14_svip_recharge_amount) / c.l14_exposure_uv) * 0.36 , 4 )                                  as l14_predictARPU
         , round( (c.l30_recharge_amount / c.l30_exposure_uv) + ((l30_signin_recharge_amount + l30_svip_recharge_amount) / c.l30_exposure_uv) * 0.36 , 4 )                                  as l30_predictARPU
         , ifnull(c.recharge_user, 0)                                                                                                                                                       as buyersNum
         , ifnull(c.recharge_amount, 0)                                                                                                                                                     as buyAmount
         , ifnull(a.exposureNum, 0)                                                                                                                                                         as episodeExposureNum
         , round(a.clickNum / a.exposureNum, 6)                                                                                                                                             as clickCTR
         , round(b.clc_cnt / b.exp_cnt, 6)                                                                                                                                                  as ctr
         , round(b.unlock_amount / a.payUnlockNum, 4)                                                                                                                                       as unlockArppu
         , round(b.unlock_amount / a.exposureNum, 4)                                                                                                                                        as unlockArpu
         , round(a.unlockNum / nullif(a.exposureNum, 0), 6)                                                                                                                                 as unlockCvr
         , round(a.viewNum / nullif(a.exposureNum, 0), 6)                                                                                                                                   as viewCvr
         , round(b.allUnlockEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                                                                       as unlockedEpisodesPerExposedUser
         , round(b.viewEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                                                                            as viewEpisodesPerExposedUser
         , round(b.allUnlockEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                                                                       as unlockChapterPerExposedUser
      from distinct_data_tmp as a
      left join accumulate_data_tmp as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
      left join recharge_data_tmp as c
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
     , a.strategyHitNum                       as totalNumberGroup
     , a.divideTrafficNum                     as groupNum
     , a.divideTrafficNum                     as includeGroupNum
     , a.divideTrafficNum
     , a.strategyHitNum
     , c.exposure_uv
     , a.clickNum
     , a.viewNum
     , a.unlockNum
     , a.payUnlockNum
     , b.viewEpisodeNum
     , b.allUnlockEpisodeNum                  as unlockEpisodeNum
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
     , b.coin_consume                         as readCoinsConsumAmount
     , b.gift_consume                         as voucherConsumAmount
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
     , c.dingYueAmountAllPercentFenmu
     , c.orderCreateRate
     , c.predictARPU
     , c.l14_predictARPU
     , c.l30_predictARPU
     , c.buyersNum
     , c.buyAmount
     , a.exposureNum                          as episodeExposureNum
     , round(a.clickNum / a.exposureNum, 6)   as clickCTR
     , c.ctr
     , c.unlockArppu
     , c.unlockArpu
     , now()                                  as saveTime
     , now()                                  as updateTime
     , round(b.viewEpisodeNum / a.viewNum, 6) as watchEpisodeNumAvg
     , c.unlockCvr
     , c.viewCvr
     , c.unlockedEpisodesPerExposedUser
     , c.viewEpisodesPerExposedUser
     , c.unlockChapterPerExposedUser
     , b.exp_cnt                              as episodeExposurePv
     , b.allUnlockEpisodeNum                  as unlockChapterNum
  from distinct_data_tmp as a
  left join accumulate_data_tmp as b
    on a.exp_id = b.exp_id
   and a.exp_grp_id = b.exp_grp_id
   and a.exp_grp_ver_id = b.exp_grp_ver_id
  left join fuzha_data_tmp as c
    on a.exp_id = c.exp_id
   and a.exp_grp_id = c.exp_grp_id
   and a.exp_grp_ver_id = c.exp_grp_ver_id
  left join exp_user_tmp as d
    on a.exp_id = d.exp_id
  left join dwd.dwd_ab_exp_version_detail as e
    on a.exp_id = e.exp_id
   and a.exp_grp_id = e.exp_grp_id
   and a.exp_grp_ver_id = e.exp_grp_ver_id
where date(e.exp_end_time) >= '${dt}'
   and date(e.end_time) >= '${dt}'
;
