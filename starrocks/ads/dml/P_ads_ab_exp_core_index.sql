----------------------------------------------------------------
-- 程序功能： AB实验核心指标表
-- 程序名： P_ads_ab_exp_core_index
-- 目标表： ads.ads_ab_exp_core_index
-- 负责人： tyg
-- 开发日期：2026-06-25
----------------------------------------------------------------

insert into ads.ads_ab_exp_core_index
-- 去重指标
with distinct_data_tmp_haiju as (
    select '${dt}'                       as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1 as windowNum
         , ifnull( sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then bitmap_count(exp_grp_users) end) , 0 ) as divideTrafficNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then strategy_hit_users end) as strategyHitNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then exposure_users end) as exposureNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then click_users end) as clickNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then watch_users end) as viewNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_users end) as unlockNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then pay_unlock_users end) as payUnlockNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_unlock_users end) as adv_unlock_users
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_users end) as rechargePeopleNum
         , count(distinct case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then consume_users end) as consumNum
      from dwm.dwm_ab_exp_distinct_stat_di as a
      left join dim.dim_date as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 30 day)
    where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
-- 海阅分支
, hj_exp_mapping as (
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
, distinct_data_tmp_hy as (
    select '${dt}'                             as dt
         , c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , datediff('${dt}', a.dt) + 1         as windowNum
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
      from (select a.dt
                 , a.login_id as strategy_hit_user
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

            select a.dt
                 , a.login_id
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

            select a.dt
                 , a.login_id
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

            select a.dt
                 , a.identity_login_id
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
       and a.event_tm >= d.start_time
       and d.end_time > a.event_tm
     group by 1, 2, 3, 4, 5
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
    select '${dt}'                       as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1 as windowNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then exp_cnt end) as exp_cnt
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then clc_cnt end) as clc_cnt
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then watch_episodes end) as viewEpisodeNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then all_unlock_episodes end) as allUnlockEpisodeNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_episodes end) as payUnlockEpisodeNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then unlock_amount end) as unlock_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_amount end) as rechargeAmount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_amount_pre end) as rechargeAmount_pre
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then total_adv_amount end) as total_adv_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_amount end) as adv_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then third_h5_amount end) as third_h5_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then third_recharge_amount end) as threePartiesAcount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then recharge_times end) as rechargeNum
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then coin_consume end) as coin_consume
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then gift_consume end) as gift_consume
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then adv_unlock_times end) as adv_unlock_times
      from dwm.dwm_ab_exp_accumulation_stat_di as a
      left join dim.dim_date as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 30 day)
    where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
, accumulate_data_tmp_hy as (
    select '${dt}'                     as dt
         , c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , datediff('${dt}', a.dt) + 1 as windowNum
         , sum(case when a.event_type = 'exposure' then 1 end) as exp_cnt
         , sum(case when a.event_type = 'click' then 1 end) as clc_cnt
         , sum(case when a.event_type = 'watch' then 1 end) as viewEpisodeNum
         , sum(case when a.event_type = 'unlock' then 1 end) as allUnlockEpisodeNum
         , null                        as payUnlockEpisodeNum
         , null                        as unlock_amount
         , null                        as rechargeAmount
         , null                        as rechargeAmount_pre
         , null                        as total_adv_amount
         , null                        as adv_amount
         , null                        as third_h5_amount
         , null                        as threePartiesAcount
         , null                        as rechargeNum
         , null                        as coin_consume
         , null                        as gift_consume
         , null                        as adv_unlock_times
      from (select dt
                 , login_id
                 , event_tm
                 , 'exposure' as event_type
              from ads.ads_sensors_production_itemexposure_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union all

            select dt
                 , login_id
                 , event_tm
                 , 'click'  as event_type
              from ads.ads_sensors_production_itemclick_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and project_id = '5'

union all

            select dt
                 , login_id
                 , event_tm
                 , 'watch'  as event_type
              from ads.ads_sensors_production_startreadingchapter_view
             where dt >= date_add('${dt}', -7)
               and dt < date_add('${dt}', 1)
               and activity_link is not null

union all

            select dt
                 , identity_login_id as login_id
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
       and a.event_tm >= d.start_time
       and d.end_time > a.event_tm
     group by 1, 2, 3, 4, 5
)
, accumulate_data_tmp as (
    select *
      from accumulate_data_tmp_haiju

union all

    select *
      from accumulate_data_tmp_hy
)
, recharge_data_tmp_haiju as (
    select '${dt}'                       as dt
         , a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , datediff(a.dt, b.datestr) + 1 as windowNum
         , count(distinct case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.exposure_pv > 0 then a.user_id end) as exposure_uv
         , count(distinct case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.create_order_user > 0 then a.user_id end) as create_order_user
         , count(distinct case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) and a.recharge_amount > 0 then a.user_id end) as recharge_user
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end) as recharge_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.signin_recharge_amount end) as signin_recharge_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.svip_recharge_amount end) as svip_recharge_amount
         , sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.normal_recharge_amount end) as normal_recharge_amount
      from dwm.dwm_ab_exp_recharge_data_di as a
      left join dim.dim_date as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 30 day)
    where a.dt >= date_add('${dt}', -31)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
, recharge_data_tmp_hy as (
    select '${dt}'                     as dt
         , c.exp_id
         , c.exp_grp_id
         , d.exp_grp_ver_id
         , datediff('${dt}', a.dt) + 1 as windowNum
         , count(distinct a.user_id)   as exposure_uv
         , null                        as create_order_user
         , count(distinct case when e.recharge_amount > 0 then e.user_id end) as recharge_user
         , sum(e.recharge_amount)      as recharge_amount
         , null                        as signin_recharge_amount
         , null                        as svip_recharge_amount
         , null                        as normal_recharge_amount
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
     group by 1, 2, 3, 4, 5
)
, recharge_data_tmp as (
    select *
      from recharge_data_tmp_haiju

union all

    select *
      from recharge_data_tmp_hy
)
, fuzha_data_tmp as (
    select a.exp_id
         , a.exp_grp_id
         , a.exp_grp_ver_id
         , a.windowNum
         , round(b.rechargeAmount / a.strategyHitNum, 4)                                                                               as arpu
         , round(c.recharge_user / c.exposure_uv, 4)                                                                                   as payRate
         , c.recharge_user                                                                                                             as payRateFenzi
         , c.exposure_uv                                                                                                               as payRateFenMu
         , (b.rechargeAmount + b.adv_amount + b.third_h5_amount)                                                                       as estimatedRevenue
         , round(b.rechargeAmount / a.rechargePeopleNum, 2)                                                                            as arppu
         , round(b.rechargeAmount / b.rechargeNum, 2)                                                                                  as unitPrice
         , round(b.rechargeNum / a.rechargePeopleNum, 2)                                                                               as rechargeAvg
         , round((b.coin_consume + b.gift_consume) / consumNum, 2)                                                                     as totalArppu
         , round(b.coin_consume / consumNum, 2)                                                                                        as readCoinsArppu
         , round(b.threePartiesAcount / rechargeAmount, 2)                                                                             as threePartiesPercent
         , round(1 - b.rechargeAmount / b.rechargeAmount_pre, 2)                                                                       as amountRate
         , round((b.coin_consume + b.gift_consume) / a.strategyHitNum, 2)                                                              as readCoinsAndVoucherApru
         , round(a.consumNum / a.strategyHitNum, 4)                                                                                    as consumeRate
         , round(b.adv_amount / a.strategyHitNum, 4)                                                                                   as adverArpu
         , round(b.total_adv_amount / a.strategyHitNum, 4)                                                                             as totalAdverArpu
         , round(a.adv_unlock_users / a.strategyHitNum, 4)                                                                             as adverUnlockRate
         , a.adv_unlock_users                                                                                                          as adverUnlockRateFenzi
         , a.strategyHitNum                                                                                                            as adverUnlockRateFenmu
         , round(b.adv_unlock_times / a.adv_unlock_users, 2)                                                                           as adverUnlockEpisodeNum
         , ifnull(c.exposure_uv, 0)                                                                                                    as exposure_uv
         , ifnull(c.recharge_user, 0)                                                                                                  as recharge_user
         , c.recharge_amount
         , round(c.recharge_amount / c.exposure_uv, 4)                                                                                 as oneExposureArpu
         , round((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv, 4)                                                   as oneExposureArpuDingYue
         , round(c.normal_recharge_amount / c.recharge_amount, 4)                                                                      as oneRechargePercent
         , c.normal_recharge_amount                                                                                                    as oneRechargePercentFenzi
         , c.recharge_amount                                                                                                           as oneRechargePercentFenmu
         , round((signin_recharge_amount + svip_recharge_amount) / c.recharge_amount, 4)                                               as dingYueAmountPercent
         , (signin_recharge_amount + svip_recharge_amount)                                                                             as dingYueAmountPercentFenzi
         , c.recharge_amount                                                                                                           as dingYueAmountPercentFenmu
         , round(c.create_order_user / c.exposure_uv, 4)                                                                               as orderCreateRate
         , ifnull(c.create_order_user, 0)                                                                                              as orderCreateRateFenzi
         , ifnull(c.exposure_uv, 0)                                                                                                    as orderCreateRateFenmu
         , round( (c.recharge_amount / c.exposure_uv) + ((signin_recharge_amount + svip_recharge_amount) / c.exposure_uv) * 0.36 , 4 ) as predictARPU
         , ifnull(c.recharge_user, 0)                                                                                                  as buyersNum
         , ifnull(c.recharge_amount, 0)                                                                                                as buyAmount
         , ifnull(a.exposureNum, 0)                                                                                                    as episodeExposureNum
         , round(a.clickNum / a.exposureNum, 6)                                                                                        as clickCTR
         , round(b.clc_cnt / b.exp_cnt, 6)                                                                                             as ctr
         , round(b.unlock_amount / a.payUnlockNum, 4)                                                                                  as unlockArppu
         , round(b.unlock_amount / a.exposureNum, 4)                                                                                   as unlockArpu
         , round(a.unlockNum / nullif(a.exposureNum, 0), 6)                                                                            as unlockCvr
         , a.unlockNum                                                                                                                 as unlockCvrFenzi
         , a.exposureNum                                                                                                               as unlockCvrFenmu
         , round(a.viewNum / nullif(a.exposureNum, 0), 6)                                                                              as viewCvr
         , a.viewNum                                                                                                                   as viewCvrFenzi
         , a.exposureNum                                                                                                               as viewCvrFenmu
         , round(b.allUnlockEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                  as unlockedEpisodesPerExposedUser
         , round(b.viewEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                       as viewEpisodesPerExposedUser
         , round(b.allUnlockEpisodeNum / nullif(a.exposureNum, 0), 6)                                                                  as unlockChapterPerExposedUser
      from distinct_data_tmp as a
      left join accumulate_data_tmp as b
        on a.exp_id = b.exp_id
       and a.exp_grp_id = b.exp_grp_id
       and a.exp_grp_ver_id = b.exp_grp_ver_id
       and a.windowNum = b.windowNum
      left join recharge_data_tmp as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
       and a.windowNum = c.windowNum
)
-- 实验总人数
, exp_user_tmp as (
    select a.exp_id
         , count(distinct exp_grp_users) as totalNumber
      from dwm.dwm_ab_exp_distinct_stat_di as a
      join ods.syncbi_ab_experiment as b
        on a.exp_id = b.id
       and a.dt < b.end_time
where a.dt >= '${dt}'
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
where a.dt >= '${dt}'
       and a.project_id = '5'
     group by c.exp_id
)
select a.exp_id
     , a.exp_grp_id
     , '${dt}'                                                                                                                                                                                                                      as dt
     , b.project_id
     , a.exp_grp_ver_id
     , a.windowNum                                                                                                                                                                                                                  as windowNum
     , b.exp_name
     , b.exp_grp_name
     , b.exp_grp_type
     , c.totalNumber
     , a.strategyHitNum                                                                                                                                                                                                             as totalNumberGroup
     , a.divideTrafficNum                                                                                                                                                                                                           as groupNum
     , a.divideTrafficNum                                                                                                                                                                                                           as includeGroupNum
     , a.divideTrafficNum                                                                                                                                                                                                           as divideTrafficNum
     , a.strategyHitNum
     , f.exposure_uv
     , a.clickNum
     , a.viewNum
     , a.unlockNum
     , a.payUnlockNum
     , e.viewEpisodeNum
     , e.allUnlockEpisodeNum                                                                                                                                                                                                        as unlockEpisodeNum
     , e.payUnlockEpisodeNum
     , f.estimatedRevenue
     , f.arpu
     , f.payRate
     , f.payRateFenzi
     , f.payRateFenMu
     , round( sum(f.payRateFenzi) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) / sum(f.payRateFenMu) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) , 4)                            as payAllRate
     , sum(f.payRateFenzi) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                                    as payAllRateFenzi
     , sum(f.payRateFenMu) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                                    as payAllRateFenMu
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
     , round( sum(f.recharge_amount) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) / sum(f.exposure_uv) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) , 4 )                         as oneExposureAllArpu
     , sum(f.recharge_amount) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                                 as oneExposureAllArpuFenzi
     , sum(f.exposure_uv) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                                     as oneExposureAllArpuFenmu
     , f.oneExposureArpuDingYue
     , f.oneRechargePercent
     , f.oneRechargePercentFenzi
     , f.oneRechargePercentFenmu
     , f.dingYueAmountPercent
     , f.dingYueAmountPercentFenzi
     , f.dingYueAmountPercentFenmu
     , round( sum(f.dingYueAmountPercentFenzi) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) / sum(f.dingYueAmountPercentFenmu) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum) , 4 ) as dingYueAmountAllPercent
     , sum(f.dingYueAmountPercentFenzi) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                       as dingYueAmountAllPercentFenzi
     , sum(f.dingYueAmountPercentFenmu) over (partition by a.exp_id, a.exp_grp_id, b.project_id, a.windowNum)                                                                                                                       as dingYueAmountAllPercentFenmu
     , f.orderCreateRate
     , f.orderCreateRateFenzi
     , f.orderCreateRateFenmu
     , f.predictARPU
     , f.buyersNum
     , f.buyAmount
     , a.exposureNum                                                                                                                                                                                                                as episodeExposureNum
     , round(a.clickNum / a.exposureNum, 6)                                                                                                                                                                                         as clickCTR
     , f.ctr
     , f.unlockArppu
     , f.unlockArpu
     , now()                                                                                                                                                                                                                        as saveTime
     , now()                                                                                                                                                                                                                        as updateTime
     , b.start_time
     , b.end_time
     , round(e.viewEpisodeNum / a.viewNum, 6)                                                                                                                                                                                       as watchEpisodeNumAvg
     , f.unlockCvr
     , f.unlockCvrFenzi
     , f.unlockCvrFenmu
     , f.viewCvr
     , f.viewCvrFenzi
     , f.viewCvrFenmu
     , f.unlockedEpisodesPerExposedUser
     , f.viewEpisodesPerExposedUser
     , f.unlockChapterPerExposedUser
     , e.exp_cnt                                                                                                                                                                                                                    as episodeExposurePv
     , e.allUnlockEpisodeNum                                                                                                                                                                                                        as unlockChapterNum
  from distinct_data_tmp as a
  -- 海剧分支
  left join dwd.dwd_ab_exp_version_detail as b
    on a.exp_id = b.exp_id
   and a.exp_grp_id = b.exp_grp_id
   and a.exp_grp_ver_id = b.exp_grp_ver_id
  left join exp_user_tmp as c
    on a.exp_id = c.exp_id
  left join accumulate_data_tmp as e
    on a.exp_id = e.exp_id
   and a.exp_grp_id = e.exp_grp_id
   and a.exp_grp_ver_id = e.exp_grp_ver_id
   and a.windowNum = e.windowNum
  left join fuzha_data_tmp as f
    on a.exp_id = f.exp_id
   and a.exp_grp_id = f.exp_grp_id
   and a.exp_grp_ver_id = f.exp_grp_ver_id
   and a.windowNum = f.windowNum
where date(b.end_time) >= '${dt}'
   and date(b.exp_end_time) >= '${dt}'
;
