----------------------------------------------------------------
-- 程序功能： 广告域-产品用户广告收益-小时统计
-- 程序名： P_dws_ad_product_user_income_h
-- 目标表： dws.dws_ad_product_user_income_h
-- 负责人： qhr
-- 开发日期： 2025-11-23
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into dws.dws_ad_product_user_income_h
-- 阅读及海剧-分广告类型、位置用户粒度广告展现收益表（海外短剧暂时没有分位置）
with ad_click_count as (
    -- 海阅每日H5点击
    select date_format(date_sub(a1.event_tm, interval 13 hour), '%Y-%m-%d %H')    as dt
          ,a1.app_product_id                                                      as product_id
          ,a1.login_id                                                            as user_id
          ,a1.app_core_ver                                                        as core
          ,a1.mt
          ,2                                                                      as system_type
          ,count(1)                                                               as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view    as a1
     where a1.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and a1.element_id = '100772'
       and a1.type = '121'
     group by 1,2,3,4,5
     union all
    select date_format(date_sub(a2.event_tm, interval 13 hour), '%Y-%m-%d %H')    as dt
          ,a2.app_product_id                                                      as product_id
          ,a2.login_id                                                            as user_id
          ,a2.app_core_ver                                                        as core
          ,a2.mt
          ,2                                                                      as system_type
          ,count(1)                                                               as ad_click_count
      from dwd.dwd_sensors_production_element_click_view          as a2
     where a2.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and a2.element_id = '100356'
       and a2.ad_position_id > 0
       and a2.app_product_id is not null
     group by 1,2,3,4,5
     union all
    -- 海剧每日H5点击
    select date_format(date_sub(a3.event_tm, interval 13 hour), '%Y-%m-%d %H')    as dt
          ,a3.product_id                                                          as product_id
          ,a3.user_id                                                             as user_id
          ,a3.core                                                                as core
          ,a3.mt
          ,1                                                                      as system_type
          ,count(1)                                                               as ad_click_count
      from dwd.dwd_sensors_production_adpositionclick_view          as a3
      left join dim.dim_sv_ads_position_view                        as a4
        on a3.ad_position_id = a4.ad_position
     where a3.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and a3.ad_type = 6
       and a3.product_id = 6833
     group by 1,2,3,4,5
     union all
    -- 三方
    select date_format(date_sub(a5.event_tm, interval 13 hour), '%Y-%m-%d %H')    as dt
          ,6833                                                                   as product_id
          ,a5.login_id                                                            as user_id
          ,a5.corever                                                             as core
          ,a5.mt
          ,1                                                                      as system_type
          ,count(1)                                                               as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view      as a5
     where a5.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and a5.task_type in('9', '浏览第三方页面')
       and a5.app_product_id is null
     group by 1,2,3,4,5
)
-- 统计每日H5总收益
, avg_click_amount as (
    select a1.dt
          ,a1.system_type
          ,sum(a1.ad_click_count)                                   as ad_click_count
          ,sum(a2.revenue_share)                                    as ad_amt
          ,round(sum(a2.revenue_share)/sum(a1.ad_click_count),4)    as ad_avg_click_amt
      from (select b1.dt
                  ,b1.system_type
                  ,sum(b1.ad_click_count)                                                  as ad_click_count
              from ad_click_count                                                          as b1
             group by 1, 2
           )                                                                               as a1
      left join (select date_format(date_sub(b2.day, interval 13 hour), '%Y-%m-%d %H')     as dt
                       ,b2.system_type
                       ,sum(b2.revenue_share)                                              as revenue_share
                   from dim.dim_sv_ad_advertise_info_view                                  as b2
                  where b2.day >= date_add('${bf_1_dt}', interval 13 hour)
                  group by 1, 2
                  union all
                 select date_format(date_sub(b3.Date, interval 13 hour), '%Y-%m-%d %H')    as dt
                       ,b4.system_type
                       ,sum(b3.SubNetRevenue)                                              as revenue_share
                   from ods.ods_tidb_mobkingaddata                                         as b3
                   left join dim.dim_ad_mobking_appid                                      as b4
                     on b3.Appid=b4.app_id
                  where b3.Date >= date_add('${bf_1_dt}', interval 13 hour)
                  group by 1, 2
                )                                                                          as a2
        on a1.dt = a2.dt
       and a1.system_type = a2.system_type
    group by 1, 2
)
, user_info_tmp as (
    select a1.product_id
          ,a1.user_id
          ,case when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3311 then 6
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3322 then 5
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3333 then 2
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3366 then 3
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3371 then 7
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3388 then 4
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3501 then 11
                when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3511 then 12
                else a1.current_language2
            end    as currentlanguage2
      from (select b1.product_id
                  ,b1.user_id
                  ,b1.current_language2
              from dim.dim_short_video_user_accountinfo    as b1    -- 海剧用户信息
             union all
            select 6883          as product_id
                  ,b2.account    as user_id
                  ,b2.current_language2
              from dim.dim_video_cn_accountinfo_view       as b2    -- 国剧用户信息
             union all
            select b3.product_id
                  ,b3.id         as user_id
                  ,b3.current_language2
             from dim.dim_user_account_info_view           as b3    -- 海阅用户信息
           )                                               as a1
)
select a1.dt                             as dt
      ,a1.product_id                     as product_id
      ,ifnull(a1.corever, a2.corever)    as corever
      ,ifnull(a1.mt, a2.mt)              as mt
      ,a1.user_id                        as user_id
      ,sum(a1.amount)                    as amount
      ,now()                             as etl_tm
  from (select date_format(date_sub(b1.create_tm,interval 13 hour), '%Y-%m-%d %H')    as dt
              ,b1.product_id
              ,b1.corever
              ,b1.mt
              ,b1.user_id
              ,sum(b1.ad_position_amt)                                                as amount
          from dwd.dwd_advertisement_user_position_amt_p_di    as b1
         where b1.create_tm >= date_add('${bf_1_dt}', interval 13 hour)
         group by 1,2,3,4,5
         union all
        -- 新增position_id=59 的数据
        select b2.dt
              ,b2.product_id
              ,b2.core
              ,case when lower(b2.mt) = 'ios' then 1
                    when lower(b2.mt) = 'android' then 4
                    else b2.mt
                end                                                                   as mt
              ,b2.user_id
              ,sum(b2.ad_click_count)*max(b3.ad_avg_click_amt)                        as amount
          from ad_click_count                                  as b2
          left join avg_click_amount                           as b3
            on b2.dt = b3.dt
           and b2.system_type = b3.system_type
          left join user_info_tmp                              as b4
            on b2.product_id = b4.product_id
           and b2.user_id = b4.user_id
         where b2.user_id is not null
         group by 1,2,3,4,5
       )                                                       as a1
  left join (select b5.product_id
                   ,b5.id
                   ,b5.corever
                   ,b5.mt
               from dim.dim_user_account_info_view             as b5
              union all
             select b6.product_id
                   ,b6.user_id
                   ,b6.corever
                   ,b6.mt
               from dim.dim_short_video_user_accountinfo       as b6
            )                                                  as a2
    on a1.product_id = a2.product_id
   and a1.user_id = a2.id
 group by 1, 2, 3, 4, 5
;