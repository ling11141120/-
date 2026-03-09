----------------------------------------------------------------
-- 程序功能： AB实验明细表
-- 程序名： P_ads_ab_exp_detail
-- 目标表： ads.ads_ab_exp_detail
-- 负责人： 
-- 开发日期： 2026-03-09
----------------------------------------------------------------

insert into tmp.ads_ab_exp_detail
-- 实验总人数
with exp_user_tmp as (
    select a.exp_id                                             -- 实验ID
         , count(distinct exp_grp_users)      as totalNumber    -- 实验总人数
      from dwm.dwm_ab_exp_distinct_stat_di    as a
      join ods.syncbi_ab_experiment           as b
        on a.exp_id = b.id
       and a.dt < b.end_time
     where a.dt >= '${dt}'
     group by 1
)
-- 去重指标
, distinct_data_tmp as (
    select a.exp_id                                                                                                                                        -- 实验ID
         , a.exp_grp_id                                                                                                                                    -- 实验组ID
         , a.exp_grp_ver_id                                                                                                                                -- 实验组ID
         , datediff(a.dt, b.datestr) + 1                                                                                            as windowNum
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then bitmap_count(exp_grp_users) end), 0)         as divideTrafficNum    -- 分流人数
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then bitmap_count(strategy_hit_users) end), 0)    as strategyHitNum      -- 策略命中人数
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then bitmap_count(watch_users) end), 0)           as viewNum             -- 观看人数
      from dwm.dwm_ab_exp_distinct_stat_di a
      left join dim.dim_date b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 7 day)
     where a.dt >= date_add('${dt}', -8)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4
)
, user_data_tmp as (
    select a.exp_id                                                                                                                          -- 实验ID
         , a.exp_grp_id                                                                                                                      -- 实验组ID
         , a.exp_grp_ver_id                                                                                                                  -- 实验组ID
         , user_id                                                                                                                           -- 用户ID
         , datediff(a.dt, b.datestr) + 1                                                                              as windowNum
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0)     as arpu                -- arpu
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.total_adv_amount end), 0)    as total_adv_amount    -- 总广告收入
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.adv_amount end), 0)          as adv_amount          -- 广告收入
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.adv_unlock_times end), 0)    as adv_unlock_times    -- 广告解锁剧集次数
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.unlock_amount end), 0)       as unlock_amount       -- 解锁数量
         , ifnull(sum(case when date ('${dt}') - a.dt <= datediff(a.dt, b.datestr) then watch_episodes end), 0)       as viewEpisodeNum      -- 观看集数
      from dwm.dwm_ab_exp_user_accumulation_stat_di as a
      left join dim.dim_date                        as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 7 day)
     where a.dt >= date_add('${dt}', -8)
       and a.dt < date_add('${dt}', 1)
     group by 1, 2, 3, 4, 5
)
, exp_core_index_detail as (
    select a.user_id                       as userId
         , a.exp_id                        as experimentId
         , a.exp_grp_id                    as experimentGroupId
         , '${dt}'                         as dt
         , d.project_id                    as projectId
         , a.exp_grp_ver_id                as trackficVersion
         , a.windowNum
         , d.exp_name
         , d.exp_grp_name
         , d.exp_grp_type                  as experimentType
         , b.totalNumber
         , c.strategyHitNum
         , a.arpu
         , a.adv_amount                    as adverArpu
         , a.total_adv_amount              as totalAdverArpu
         , a.adv_unlock_times              as adverUnlockEpisodeNum
         , a.unlock_amount
         , a.viewEpisodeNum / c.viewNum    as watchEpisodeNumAvg
      from user_data_tmp                    as a
      join exp_user_tmp                     as b
        on a.exp_id = b.exp_id
      join distinct_data_tmp                as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
      join dwd.dwd_ab_exp_version_detail    as d
        on a.exp_id = d.exp_id
       and a.exp_grp_id = d.exp_grp_id
       and a.exp_grp_ver_id = d.exp_grp_ver_id
     where date(d.exp_end_time) >= '${dt}'
       and date(d.end_time) >= '${dt}'
)
, recharge_index_detail as (
    select a.exp_id                                                                                                                                                                 as experimentId                  -- 实验ID
         , a.exp_grp_id                                                                                                                                                             as experimentGroupId             -- 实验组ID
         , '${dt}'                                                                                                                                                                  as dt
         , c.project_id                                                                                                                                                             as projectId                     -- 项目id
         , c.exp_grp_type                                                                                                                                                           as experimentType                -- 实验类型
         , a.exp_grp_ver_id                                                                                                                                                         as trackficVersion               -- 流量版本
         , datediff(a.dt, b.datestr) + 1                                                                                                                                            as windowNum
         , ifnull(avg(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0)                                                                   as oneExposureArpuMean           -- 单人曝光ARPU均值
         , ifnull(variance(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0)                                                              as oneExposureArpuVar            -- oneExposureArpuVar
         , ifnull(avg(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.signin_recharge_amount + a.svip_recharge_amount end), 0)                                   as oneExposureArpuDingYueMean    -- 单人曝光ARPU(订阅)均值
         , ifnull(variance(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.signin_recharge_amount + a.svip_recharge_amount end), 0)                              as oneExposureArpuDingYueVar     -- 单人曝光ARPU(订阅)方差
         , ifnull(avg(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount + (a.signin_recharge_amount + a.svip_recharge_amount) * 0.36 end), 0)      as predictARPUMean               -- 预估ARPU均值
         , ifnull(variance(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount + (a.signin_recharge_amount + a.svip_recharge_amount) * 0.36 end), 0) as predictARPUVar                -- 预估ARPU方差
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_un end), 0)                                                                       as buyersNum                     -- 购买人数
         , ifnull(sum(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0)                                                                   as buyAmount                     -- 购买金额
      from dwm.dwm_ab_exp_recharge_data_di    as a
      left join dim.dim_date                  as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 7 day)
      left join dwd.dwd_ab_exp_version_detail as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
     where a.dt >= date_add('${dt}', -8)
       and a.dt < date_add('${dt}', 1)
       and date(c.exp_end_time) >= '${dt}'
       and date(c.end_time) >= '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7
)
, recharge_index_detail_all as (
    select a.exp_id                                                                                                    as experimentId            -- 实验ID
         , a.exp_grp_id                                                                                                as experimentGroupId       -- 实验组ID
         , '${dt}'                                                                                                     as dt
         , c.project_id                                                                                                as projectId               -- 项目id
         , c.exp_grp_type                                                                                              as experimentType          -- 实验类型
         , datediff(a.dt, b.datestr) + 1                                                                               as windowNum
         , ifnull(avg(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0)      as oneExposureAllArpuMean
         , ifnull(variance(case when date('${dt}') - a.dt <= datediff(a.dt, b.datestr) then a.recharge_amount end), 0) as oneExposureAllArpuVar
      from dwm.dwm_ab_exp_recharge_data_di    as a
      left join dim.dim_date                  as b
        on a.dt >= b.datestr
       and b.datestr >= date_sub(a.dt, interval 7 day)
      left join dwd.dwd_ab_exp_version_detail as c
        on a.exp_id = c.exp_id
       and a.exp_grp_id = c.exp_grp_id
       and a.exp_grp_ver_id = c.exp_grp_ver_id
     where a.dt >= date_add('${dt}', -8)
       and a.dt < date_add('${dt}', 1)
       and date(c.exp_end_time) >= '${dt}'
       and date(c.end_time) >= '${dt}'
     group by 1, 2, 3, 4, 5, 6
)
select dt
     , experimentId
     , experimentGroupId
     , projectId
     , experimentType
     , trackficVersion
     , windowNum
     , max(totalNumberGroup)              as totalNumberGroup
     , max(arpuMean)                      as arpuMean
     , max(arpuVar)                       as arpuVar
     , max(adverArpuMean)                 as adverArpuMean
     , max(adverArpuVar)                  as adverArpuVar
     , max(totalAdverArpuMean)            as totalAdverArpuMean
     , max(totalAdverArpuVar)             as totalAdverArpuVar
     , max(adverUnlockEpisodeNumMean)     as adverUnlockEpisodeNumMean
     , max(adverUnlockEpisodeNumVar)      as adverUnlockEpisodeNumVar
     , max(oneExposureArpuMean)           as oneExposureArpuMean
     , max(oneExposureArpuVar)            as oneExposureArpuVar
     , max(oneExposureAllArpuMean)        as oneExposureAllArpuMean
     , max(oneExposureAllArpuVar)         as oneExposureAllArpuVar
     , max(oneExposureArpuDingYueMean)    as oneExposureArpuDingYueMean
     , max(oneExposureArpuDingYueVar)     as oneExposureArpuDingYueVar
     , max(predictARPUMean)               as predictARPUMean
     , max(predictARPUVar)                as predictARPUVar
     , max(buyersNum)                     as buyersNum
     , max(buyAmount)                     as buyAmount
     , max(unlockArppuMean)               as unlockArppuMean
     , max(unlockArppuVar)                as unlockArppuVar
     , max(unlockArppuMean)               as unlockArpuMean
     , max(unlockArppuVar)                as unlockArpuVar
     , now()                              as saveTime
     , now()                              as updateTime
     , max(watchEpisodeNumAvgMean)        as watchEpisodeNumAvgMean
     , max(watchEpisodeNumAvgVar)         as watchEpisodeNumAvgVar
  from (select dt
             , experimentId
             , experimentGroupId
             , projectId
             , experimentType
             , trackficVersion
             , windowNum
             , count(distinct userId)             as totalNumberGroup
             , avg(arpu)                          as arpuMean
             , variance(arpu)                     as arpuVar
             , avg(adverArpu)                     as adverArpuMean
             , variance(adverArpu)                as adverArpuVar
             , avg(totalAdverArpu)                as totalAdverArpuMean
             , variance(totalAdverArpu)           as totalAdverArpuVar
             , avg(adverUnlockEpisodeNum)         as adverUnlockEpisodeNumMean
             , variance(adverUnlockEpisodeNum)    as adverUnlockEpisodeNumVar
             , 0                                  as oneExposureArpuMean
             , 0                                  as oneExposureArpuVar
             , 0                                  as oneExposureAllArpuMean
             , 0                                  as oneExposureAllArpuVar
             , 0                                  as oneExposureArpuDingYueMean
             , 0                                  as oneExposureArpuDingYueVar
             , 0                                  as predictARPUMean
             , 0                                  as predictARPUVar
             , 0                                  as buyersNum
             , 0                                  as buyAmount
             , avg(unlock_amount)                 as unlockArppuMean
             , variance(unlock_amount)            as unlockArppuVar
             , avg(watchEpisodeNumAvg)            as watchEpisodeNumAvgMean
             , variance(watchEpisodeNumAvg)       as watchEpisodeNumAvgVar
          from exp_core_index_detail
         group by 1, 2, 3, 4, 5, 6, 7
         union all
        select a.dt
             , a.experimentId
             , a.experimentGroupId
             , a.projectId
             , a.experimentType
             , a.trackficVersion
             , a.windowNum
             , 0                                  as totalNumberGroup
             , 0                                  as arpuMean
             , 0                                  as arpuVar
             , 0                                  as adverArpuMean
             , 0                                  as adverArpuVar
             , 0                                  as totalAdverArpuMean
             , 0                                  as totalAdverArpuVar
             , 0                                  as adverUnlockEpisodeNumMean
             , 0                                  as adverUnlockEpisodeNumVar
             , a.oneExposureArpuMean
             , a.oneExposureArpuVar
             , b.oneExposureAllArpuMean
             , b.oneExposureAllArpuVar
             , a.oneExposureArpuDingYueMean
             , a.oneExposureArpuDingYueVar
             , a.predictARPUMean
             , a.predictARPUVar
             , a.buyersNum
             , a.buyAmount
             , 0                                  as unlockArppuMean
             , 0                                  as unlockArppuVar
             , 0                                  as watchEpisodeNumAvgMean
             , 0                                  as watchEpisodeNumAvgVar
          from recharge_index_detail             as a
          left join recharge_index_detail_all    as b
            on a.dt = b.dt
           and a.experimentId = b.experimentId
           and a.experimentGroupId = b.experimentGroupId
           and a.projectId = b.projectId
           and a.experimentType = b.experimentType
           and a.windowNum = b.windowNum
       ) a
 where dt = '${dt}'
 group by 1, 2, 3, 4, 5, 6, 7
;