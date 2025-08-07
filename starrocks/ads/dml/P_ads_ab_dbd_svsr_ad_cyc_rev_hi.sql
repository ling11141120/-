----------------------------------------------------------------
-- 目标表： ads.ads_ab_dbd_svsr_ad_cyc_rev
-- 功能： AB测试-运营看板-海剧海阅广告周期收益表
-- 更新方式： 当日-按小时增量更新
-- 负责人： qhr
-- 开发日期： 2023-08-06
----------------------------------------------------------------

with base1 as (
    select dt
          ,coalesce(corever, -99)       as core
          ,coalesce(period_type, '-99') as period_type
          ,sum(coalesce(amt,0))         as amt
      from ads.ads_sv_ad_efficiency_report
     where dt between date_sub('${dt}', interval 120 day) and '${dt}'
     group by dt, corever, period_type
)
, base2 as (
    select dt
          ,case when corever = '-99' or corever = '其他' or corever is null then -99
                else cast(corever as int)
            end                                  as core
          ,coalesce(period_type, '-99')          as period_type
          ,sum(coalesce(ad_revenue_amount,0))    as amt
      from ads.ads_ad_user_space_conversion_detail
     where dt between date_sub('${dt}', interval 120 day) and '${dt}'
     group by dt, corever, period_type
)
, union_base as (
    select dt, core, 3 as project_id, period_type, amt from base1
     union all
    select dt, core, 1 as project_id, period_type, amt from base2
)
insert into ads.ads_ab_dbd_svsr_ad_cyc_rev
select '${dt}'                                                                         as dt
      ,core                                                                            as core
      ,project_id                                                                      as project_id
      ,period_type                                                                     as period_type
      ,sum(case when dt = '${dt}' then amt else 0 end)                                 as day0_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 1 day)   then amt else 0 end)    as day1_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 2 day)   then amt else 0 end)    as day2_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 3 day)   then amt else 0 end)    as day3_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 7 day)   then amt else 0 end)    as day7_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 15 day)  then amt else 0 end)    as day15_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 21 day)  then amt else 0 end)    as day21_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 30 day)  then amt else 0 end)    as day30_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 45 day)  then amt else 0 end)    as day45_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 60 day)  then amt else 0 end)    as day60_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 90 day)  then amt else 0 end)    as day90_amount_byad
      ,sum(case when dt >= date_sub('${dt}', interval 120 day) then amt else 0 end)    as day120_amount_byad
  from union_base
 group by core, project_id, period_type
;