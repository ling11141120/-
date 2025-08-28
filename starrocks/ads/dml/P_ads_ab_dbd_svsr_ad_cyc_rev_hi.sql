----------------------------------------------------------------
-- 程序功能： AB测试-运营看板-海剧海阅广告周期收益表
-- 程序名： P_ads_ab_dbd_svsr_ad_cyc_rev_hi
-- 目标表： ads.ads_ab_dbd_svsr_ad_cyc_rev
-- 负责人： qhr
-- 开发日期： 2023-08-11
----------------------------------------------------------------

insert into ads.ads_ab_dbd_svsr_ad_cyc_rev
with svsr_ad_amt as (
    select a1.dt                                                   as dt
          ,coalesce(a1.corever, -99)                               as core
          ,3                                                       as product_id    -- 海剧
          ,a1.user_id                                              as user_id
          ,datediff(a2.dt, a1.dt)                                  as diff_dt_num
          ,coalesce(a2.amt,0)                                      as ad_amt
      from dws.dws_user_short_video_wide_active_period_ed          as a1
      left join ads.ads_sv_ad_efficiency_report_west5              as a2    -- 海剧广告效率表(西5区)
        on a2.dt between date_sub('${dt}', interval 120 day) and '${dt}'
       and a2.product_id = 6833
       and a2.period_type = 'ctt'
       and a2.dt between a1.dt and date_add(a1.dt, interval 120 day)
       and a1.user_id = a2.user_id
       and a1.corever = a2.corever
     where a1.dt between date_sub('${dt}', interval 120 day) and '${dt}'
       and a1.period_type = 'ctt'
       and a1.product_id = 6833
       and a1.user_type = 'D0'
     union all
    select a3.dt                                                   as dt
          ,coalesce(a3.corever, -99)                               as core
          ,1                                                       as product_id    -- 海阅
          ,a3.user_id                                              as user_id
          ,datediff(a4.dt, a3.dt)                                  as diff_dt_num
          ,coalesce(a4.ad_revenue_amount,0)                        as ad_amt
      from dws.dws_user_wide_active_period_ed                      as a3
      left join ads.ads_ad_user_space_conversion_detail            as a4
        on a4.dt between date_sub('${dt}', interval 120 day) and '${dt}'
       and a4.period_type = 'ctt'
       and a4.dt between a3.dt and date_add(a3.dt, interval 120 day)
       and a3.user_id = a4.user_id
     where a3.dt between date_sub('${dt}', interval 120 day) and '${dt}'
       and a3.period_type = 'ctt'
       and a3.user_type = 'D0'
)
select a1.dt
      ,a1.core
      ,a1.product_id
      ,'ctt'                                                               as period_type
      ,sum(case when a1.diff_dt_num = 0 then a1.ad_amt else null end)    as day0_amount_byad
      ,case when sum(case when a1.diff_dt_num = 1 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 1 then a1.ad_amt else null end)
        end                                                              as day1_amount_byad
      ,case when sum(case when a1.diff_dt_num = 2 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 2 then a1.ad_amt else null end)
        end                                                              as day2_amount_byad
      ,case when sum(case when a1.diff_dt_num = 3 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 3 then a1.ad_amt else null end)
        end                                                              as day3_amount_byad
      ,case when sum(case when a1.diff_dt_num = 7 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 7 then a1.ad_amt else null end)
        end                                                              as day7_amount_byad
      ,case when sum(case when a1.diff_dt_num = 15 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 15 then a1.ad_amt else null end)
        end                                                              as day15_amount_byad
      ,case when sum(case when a1.diff_dt_num = 21 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 21 then a1.ad_amt else null end)
        end                                                              as day21_amount_byad
      ,case when sum(case when a1.diff_dt_num = 30 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 30 then a1.ad_amt else null end)
        end                                                              as day30_amount_byad
      ,case when sum(case when a1.diff_dt_num = 45 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 45 then a1.ad_amt else null end)
        end                                                              as day45_amount_byad
      ,case when sum(case when a1.diff_dt_num = 60 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 60 then a1.ad_amt else null end)
        end                                                              as day60_amount_byad
      ,case when sum(case when a1.diff_dt_num = 90 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 90 then a1.ad_amt else null end)
        end                                                              as day90_amount_byad
      ,case when sum(case when a1.diff_dt_num = 120 then a1.ad_amt else null end) is null then null
            else sum(case when a1.diff_dt_num <= 120 then a1.ad_amt else null end)
        end                                                              as day120_amount_byad
  from svsr_ad_amt                                                       as a1
 group by 1, 2, 3, 4
;