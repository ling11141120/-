----------------------------------------------------------------
-- 程序功能： 阅读及海剧用户广告展现位置收益表
-- 程序名： P_dws_advertisement_user_position_amt_ed
-- 目标表： dws.dws_advertisement_user_position_amt_ed
-- 开发人： qhr
-- 开发日期： 
----------------------------------------------------------------

insert into dws.dws_advertisement_user_position_amt_ed
-- 统计每日H5点击
with ad_click_count as (
    select dt                                                 as dt
          ,app_product_id                                     as product_id
          ,login_id                                           as user_id
          ,app_core_ver                                       as core
          ,mt                                                 as mt
          ,appver                                             as appver
          ,5                                                  as ad_show_type
          ,59                                                 as positions
          ,'Starmobi'                                         as ads_name
          ,null                                               as main_strategy_id
          ,null                                               as event_strategy_id
          ,event_strategy_id                                  as programme_id
          ,2                                                  as system_type
          ,count(1)                                           as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view
     where dt>='${bf_1_dt}'
       and dt<='${dt}'
       and element_id = '100772'
       and type = '121'
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13
     union all
     select dt                                                as dt
           ,app_product_id                                    as product_id
           ,login_id                                          as user_id
           ,app_core_ver                                      as core
           ,mt                                                as mt
           ,appver                                            as appver
           ,5                                                 as ad_show_type
           ,ad_position_id                                    as positions
           ,'Starmobi'                                        as ads_name
           ,main_strategy_id                                  as main_strategy_id
           ,ad_strategy_id                                    as event_strategy_id
           ,programme_id                                      as programme_id
           ,2                                                 as system_type
           ,count(1)                                          as ad_click_count
       from dwd.dwd_sensors_production_element_click_view
      where dt>='${bf_1_dt}'
        and dt<='${dt}'
        and element_id = '100356'
        and ad_position_id >0
        and app_product_id is not null
      group by 1,2,3,4,5,6,7,8,9,10,11,12,13
      union all
    -- 海剧每日H5点击
    select a.dt                                               as dt
          ,a.product_id                                       as product_id
          ,a.user_id                                          as user_id
          ,a.core                                             as core
          ,a.mt                                               as mt
          ,a.appver                                           as appver
          ,a.ad_type                                          as ad_show_type
          ,b.ad_position                                      as positions
          ,b.ad_position_name                                 as ads_name
          ,a.main_strategy_id                                 as main_strategy_id
          ,a.event_strategy_id                                as event_strategy_id
          ,a.programme_id                                     as programme_id
          ,1                                                  as system_type
          ,count(1)                                           as ad_click_count
      from dwd.dwd_sensors_production_adpositionclick_view    as a
      left join dim.dim_sv_ads_position_view                  as b
        on a.ad_position_id = b.ad_position
     where dt>='${bf_1_dt}'
       and dt<='${dt}'
       and ad_type = 6
       and product_id = 6833
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13
     union all
    select a.dt                                                as dt
          ,6833                                                as product_id
          ,login_id                                            as user_id
          ,corever                                             as core
          ,a.mt                                                as mt
          ,a.appver                                            as appver
          ,6                                                   as ad_show_type
          ,null                                                as positions
          ,'H5'                                                as ads_name
          ,null                                                as main_strategy_id
          ,a.event_strategy_id                                 as event_strategy_id
          ,null                                                as programme_id
          ,1                                                   as system_type
          ,count(1)                                            as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view as a
     where dt>='${bf_1_dt}'
       and dt<='${dt}'
       and task_type in('9','浏览第三方页面')
       and app_product_id is null
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)
-- 统计每日H5总收益
, avg_click_amount as (
    select a.dt
          ,a.system_type
          ,b.ads_name
          ,sum(a.ad_click_count)                                  as ad_click_count
          ,sum(b.revenue_share)                                   as ad_amt
          ,round(sum(b.revenue_share)/sum(a.ad_click_count),9)    as ad_avg_click_amt
      from (select dt                                             as dt
                  ,system_type                                    as system_type
                  ,sum(ad_click_count)                            as ad_click_count
              from ad_click_count
             group by 1, 2
           )                                                      as a
      left join (select date(day)                                 as dt
                       ,system_type                               as system_type
                       ,'Starmobi'                                as ads_name
                       ,sum(revenue_share)*0.7                    as revenue_share
                   from dim.dim_sv_ad_advertise_info_view
                  where date(day)>='${bf_1_dt}'
                    and date(day)<='${dt}'
                  group by 1, 2, 3
                  union all
                 select a.Date                                    as dt
                       ,case when ProjectType=0 then 2
                             else ProjectType
                         end                                      as system_type
                       ,'MobKing'                                 as ads_name
                       ,sum(SubNetRevenue)*0.7                    as revenue_share
                   from ods.ods_tidb_mobkingaddata                as a
                  where Date>='${bf_1_dt}'
                    and Date<='${dt}'
                  group by 1, 2, 3
                  union all
                 select Date                                      as dt
                       ,case when UrlName='moboreels' then 1
                             when UrlName='moboreader' then 2
                          end                                     as system_type
                       ,'pengpai'                                 as ads_name
                       ,sum(RevenueNet)                           as revenue_share
                   from ods.ods_tidb_SurgeAdData
                  where UrlName in('moboreels','moboreader')
                    and Date>='${bf_1_dt}'
                    and Date<='${dt}'
                  group by 1, 2, 3
                  union all
                 select dt                                        as dt
                       ,system_type                               as system_type
                       ,'Starmobi_2'                              as ads_name
                       ,income                                    as revenue_share
                   from (select date(day)                         as dt
                               ,system_type
                               ,sum(ecpm)                         as ecpm
                               ,sum(income)                       as income
                               ,sum(page_view)                    as page_view
                           from ods.ods_tidb_short_video_log_firefly_income_report
                          group by 1, 2
                        )                                         as a
                  where dt>='${bf_1_dt}'
                    and dt<='${dt}'
                )                                                 as b
        on a.dt = b.dt
       and a.system_type = b.system_type
     group by 1, 2, 3
)
, user_info_tmp as (
    select a.product_id
          ,a.user_id
          ,case when (current_language2 is null or current_language2=0) and product_id=3311 then 6
                when (current_language2 is null or current_language2=0) and product_id=3322 then 5
                when (current_language2 is null or current_language2=0) and product_id=3333 then 2
                when (current_language2 is null or current_language2=0) and product_id=3366 then 3
                when (current_language2 is null or current_language2=0) and product_id=3371 then 7
                when (current_language2 is null or current_language2=0) and product_id=3388 then 4
                when (current_language2 is null or current_language2=0) and product_id=3501 then 11
                when (current_language2 is null or current_language2=0) and product_id=3511 then 12
                else current_language2
            end               as currentlanguage2
      from (
            -- 海外短剧用户信息
            select sacc.product_id
                  ,sacc.user_id
                  ,sacc.current_language2
              from dim.dim_short_video_user_accountinfo sacc
             union all
            -- 国内短剧用户信息
            select 6883       as product_id
                  ,account    as user_id
                  ,current_language2
              from dim.dim_video_cn_accountinfo_view
             union all
            select product_id
                  ,id         as user_id
                  ,current_language2
              from dim.dim_user_account_info_view
           ) a
)
select x.dt                                                 as dt
      ,x.product_id                                         as product_id
      ,x.user_id                                            as user_id
      ,x.core                                               as core
      ,x.mt                                                 as mt
      ,case when x.product_id = 6833 and x.positions = 12 then 'Starmobi-H5'
            when x.product_id <> 6833 and x.positions = 59 then 'Starmobi-H5'
            else acc.currentlanguage2
        end                                                 as current_language2
      ,x.appver                                             as appver
      ,x.ad_show_type                                       as ad_show_type
      ,x.positions                                          as positions
      ,x.ads_name                                           as ads_name
      ,x.ads_source                                         as ads_source
      ,x.main_strategy_id                                   as main_strategy_id
      ,x.event_strategy_id                                  as event_strategy_id
      ,x.programme_id                                       as programme_id
      ,max(case when rk_asc=1 then amount end)              as fst_amt
      ,max(case when rk_desc=1 then amount end)             as lst_amt
      ,count(1)                                             as cnt
      ,sum(amount)                                          as amt
      ,now()                                                as etl_tm
  from (select a.dt                                         as dt
              ,a.product_id                                 as product_id
              ,a.user_id                                    as user_id
              ,a.corever                                    as core
              ,a.mt                                         as mt
              ,a.appver                                     as appver
              ,a.create_tm                                  as create_tm
              ,a.ad_unit                                    as ad_unit
              ,a.ad_show_type                               as ad_show_type
              ,a.position_id                                as positions
              ,a.ad_position_amt                            as amount
              ,a.ads_name                                   as ads_name
              ,coalesce(b.ads_source_abbr, a.ads_source)    as ads_source
              ,a.main_strategy_id                           as main_strategy_id
              ,a.event_strategy_id                          as event_strategy_id
              ,a.programme_id                               as programme_id
              ,row_number() over (partition by a.dt
                                              ,a.product_id
                                              ,a.user_id
                                              ,a.corever
                                              ,a.mt
                                              ,a.appver
                                              ,a.ad_show_type
                                              ,a.position_id
                                              ,a.ads_name
                                              ,a.main_strategy_id
                                              ,a.event_strategy_id
                                              ,a.programme_id
                                              ,a.create_tm
                                              ,a.ad_unit
                                      order by a.create_tm
                                              ,a.ad_unit
                                )                           as rk_asc
              ,row_number() over (partition by a.dt
                                              ,a.product_id
                                              ,a.user_id
                                              ,a.corever
                                              ,a.mt
                                              ,a.appver
                                              ,a.ad_show_type
                                              ,a.position_id
                                              ,a.ads_name
                                              ,a.main_strategy_id
                                              ,a.event_strategy_id
                                              ,a.programme_id
                                              ,a.create_tm
                                              ,a.ad_unit
                                      order by a.create_tm desc
                                              ,a.ad_unit desc
                                 )                           as rk_desc
          from dwd.dwd_advertisement_user_position_amt_p_di  as a    --阅读及海外短剧广告预估收益明细宽表
          left join dim.dim_ads_source_abbr                  as b
            on a.ads_name = b.ads_name
           and a.ads_source = b.ads_source
         where dt>='${bf_1_dt}'
           and dt<='${dt}'
       )                                                     as x
  left join user_info_tmp                                    as acc
    on x.product_id=acc.product_id
   and x.user_id=acc.user_id
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
-- 新增position_id=59 的数据
 union all
select a.dt                                                  as dt
      ,a.product_id                                          as product_id
      ,a.user_id                                             as user_id
      ,a.core                                                as core
      ,case when lower(a.mt)='ios' then 1
            when lower(a.mt)='android' then 4
            else a.mt
        end                                                  as mt
      ,acc.currentlanguage2                                  as currentlanguage2
      ,a.appver                                              as appver
      ,a.ad_show_type                                        as ad_show_type
      ,a.positions                                           as positions
      ,b.ads_name                                            as ads_name
      ,null                                                  as ads_source
      ,a.main_strategy_id                                    as main_strategy_id
      ,a.event_strategy_id                                   as event_strategy_id
      ,a.programme_id                                        as programme_id
      ,null                                                  as fst_amt
      ,null                                                  as lst_amt
      ,sum(a.ad_click_count)                                 as cnt
      ,sum(a.ad_click_count)*max(b.ad_avg_click_amt)         as amt
      ,now()                                                 as etl_tm
  from ad_click_count                                        as a
  left join avg_click_amount                                 as b
    on a.dt = b.dt
   and a.system_type = b.system_type
  left join user_info_tmp                                    as acc
    on a.product_id=acc.product_id
   and a.user_id=acc.user_id
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
;