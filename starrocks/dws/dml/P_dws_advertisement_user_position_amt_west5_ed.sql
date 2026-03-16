----------------------------------------------------------------
-- 程序功能： 阅读及海剧用户广告展现位置收益表_西五区
-- 程序名： dws_advertisement_user_position_amt_west5_ed
-- 目标表： dws.dws_advertisement_user_position_amt_west5_ed
-- 负责人： roger/xjc
-- 开发日期：2025/12/11
-- 版本号： v0.1
----------------------------------------------------------------

delete from  dws.dws_advertisement_user_position_amt_west5_ed where dt>='${bf_1_dt}' and dt<='${dt}';

insert into dws.dws_advertisement_user_position_amt_west5_ed
-- 统计每日H5点击
with ad_click_count as (
    select date(date_add(event_tm,interval -13 hour))   as dt
          ,a1.app_product_id                            as product_id
          ,a1.login_id                                  as user_id
          ,a1.app_core_ver                              as core
          ,a1.mt
          ,a1.appver
          ,5                                            as ad_show_type
          ,59                                           as positions
          ,a1.ad_src                                    as ads_src
          ,null                                         as main_strategy_id
          ,null                                         as event_strategy_id
          ,a1.event_strategy_id                         as programme_id
          ,if(a1.app_core_ver=4 and a1.ad_src=7,3,2)    as system_type
          ,count(1)                                     as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view    as a1
     where dt >= date(date_sub('${bf_1_dt}', interval 1 day))
       and dt <= '${dt}'
       and date(date_add(event_tm,interval -13 hour)) in ('${bf_1_dt}', '${dt}')    -- 取西五区的时间数据
       and element_id = '100772'
       and type in('121', '123')
       and ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    select date(date_add(event_tm,interval -13 hour))   as dt
          ,a1.app_product_id                            as product_id
          ,a1.login_id                                  as user_id
          ,a1.app_core_ver                              as core
          ,a1.mt
          ,a1.appver
          ,5                                            as ad_show_type
          ,a1.ad_position_id                            as positions
          ,a1.ad_src                                    as ads_src
          ,a1.main_strategy_id
          ,a1.ad_strategy_id                            as event_strategy_id
          ,a1.programme_id                              as programme_id
          ,if(a1.app_core_ver=4 and a1.ad_src=7,3,2)    as system_type
          ,count(1)                                     as ad_click_count
      from dwd.dwd_sensors_production_element_click_view    as a1
     where dt >= date(date_sub('${bf_1_dt}', interval 1 day))
       and dt <= '${dt}'
       and date(date_add(event_tm,interval -13 hour)) in ('${bf_1_dt}', '${dt}')
       and element_id = '100356'
       and ad_position_id > 0
       and app_product_id is not null
       and ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    -- 海剧每日H5点击
    select date(date_add(event_tm,interval -13 hour))    as dt
          ,a1.product_id
          ,a1.user_id
          ,a1.core
          ,a1.mt
          ,a1.appver
          ,a1.ad_type                                    as ad_show_type
          ,a2.ad_position                                as positions
          ,a1.ad_src                                     as ads_src
          ,a1.main_strategy_id
          ,a1.event_strategy_id
          ,a1.programme_id
          ,if(a1.core=4 and a1.ad_src=7,3,1)             as system_type
          ,count(1)                                      as ad_click_count
      from dwd.dwd_sensors_production_adpositionclick_view    as a1
      left join dim.dim_sv_ads_position_view                  as a2
        on a1.ad_position_id = a2.ad_position
     where a1.dt >= date(date_sub('${bf_1_dt}', interval 1 day))
       and a1.dt <= '${dt}'
       and date(date_add(event_tm,interval -13 hour)) in ('${bf_1_dt}', '${dt}')
       and a1.ad_type = 6
       and a1.product_id = 6833
       and ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    select date(date_add(event_tm,interval -13 hour))    as dt
          ,6833                                          as product_id
          ,login_id                                      as user_id
          ,corever                                       as core
          ,mt
          ,appver
          ,6                                             as ad_show_type
          ,null                                          as positions
          ,a1.ad_src                                     as ads_src
          ,null                                          as main_strategy_id
          ,event_strategy_id
          ,null                                          as programme_id
          ,if(a1.corever=4 and a1.ad_src=7,3,1)          as system_type
          ,count(1)                                      as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view    as a1
     where dt >= date(date_sub('${bf_1_dt}', interval 1 day))
       and dt <= '${dt}'
       and date(date_add(event_tm,interval -13 hour)) in ('${bf_1_dt}', '${dt}')
       and task_type in('9', '浏览第三方页面')
       and app_product_id is null
       and length(ad_src)>=1
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
-- 统计每日H5点击平均收益
, avg_click_amount as (
    select a1.dt
          ,a1.system_type
          ,a2.ads_name
          ,sum(a1.ad_click_count)                                   as ad_click_count
          ,sum(a2.revenue_share)                                    as ad_amt
          ,round(sum(a2.revenue_share)/sum(a1.ad_click_count),9)    as ad_avg_click_amt
      from (select dt
                  ,a1.system_type
                  ,a2.cd_val_desc         as ads_name
                  ,sum(ad_click_count)    as ad_click_count
              from ad_click_count                        as a1
              left join dim.dim_pub_code_mapping_dict    as a2
                on a1.ads_src=a2.cd_val
               and a2.app_plat='pub'
               and a2.cd_col='ad_src'
             group by 1,2,3
           )         as a1
      left join (select date(day)                 as dt
                       ,system_type
                       ,'Starmobi'                as ads_name
                       ,sum(revenue_share)        as revenue_share
                   from dim.dim_sv_ad_advertise_info_view
                  where date(day) in ('${bf_1_dt}', '${dt}')
                  group by 1, 2,3
                  union all
                 select Date as dt
                       ,case when ProjectType = 0 then 2
                             else ProjectType
                         end                      as system_type
                       ,'MobKing'                 as ads_name
                       ,sum(SubNetRevenue)        as revenue_share
                   from ods.ods_tidb_mobkingaddata
                  where Date in ('${bf_1_dt}', '${dt}')
                  group by 1,2,3
                  union all
                 select Date as dt
                        ,case when UrlName='moboreels' then 1
                              when UrlName='moboreader' then 2
                              else null
                          end               as system_type
                        ,'pengpai'          as ads_name
                        ,sum(RevenueNet)    as revenue_share
                   from ods.ods_tidb_SurgeAdData
                  where UrlName in('moboreels','moboreader')
                    and Date in ('${bf_1_dt}', '${dt}')
                  group by 1,2,3
                  union all
                 select dt
                       ,system_type
                       ,'Starmobi_2'    as ads_name
                       ,income          as revenue_share
                   from (select date(day)         as dt
                               ,system_type
                               ,sum(ecpm)         as ecpm
                               ,sum(income)       as income
                               ,sum(page_view)    as page_view
                           from ods.ods_tidb_short_video_log_firefly_income_report
                         group by 1,2
                        )     as c1
                  where dt in ('${bf_1_dt}', '${dt}')
                  union all
                 select dt
                       ,case when ProjectType = 1 then 2
                             when ProjectType = 2 then 1
                             else ProjectType
                         end                as system_type
                       ,'synjoy'            as ads_name
                       ,sum(revenue)*0.8    as revenue_share
                   from ods.ods_tidb_readernovel_tidb_xx_synjoyaddata
                  where dt in ('${bf_1_dt}', '${dt}')
                  group by 1,2,3
                  union all
                 select dt                 as dt
                       ,case when ProjectType = 1 then 2
                             when ProjectType = 2 then 1
                             else ProjectType
                         end               as system_type
                       ,'Bees'             as ads_name
                       ,sum(netrevenue)    as revenue_share
                   from ods.ods_tidb_readernovel_tidb_xx_beesadsdata
                  where dt>='${bf_1_dt}'
                    and dt<='${dt}'
                  group by 1,2,3
                  union all
                 select dt             as dt
                       ,case when projecttype = 1 then 2
                             when projecttype = 2 then 1
                             else projecttype
                         end           as system_type
                      ,'adjoe'         as ads_name
                      ,sum(revenue)    as revenue_share
                   from ods.ods_tidb_readernovel_tidb_xx_adjoedata
                  where dt>='${bf_1_dt}'
                    and dt<='${dt}'
                  group by 1,2,3
                )    as a2
        on a1.dt=a2.dt
       and a1.system_type = a2.system_type
       and a1.ads_name = a2.ads_name
     group by 1,2,3
)
,user_info_tmp as (
    select a1.product_id
          ,a1.user_id
          ,case when (current_language2 is null or current_language2=0)and product_id=3311 then 6
                when (current_language2 is null or current_language2=0)and product_id=3322 then 5
                when (current_language2 is null or current_language2=0)and product_id=3333 then 2
                when (current_language2 is null or current_language2=0)and product_id=3366 then 3
                when (current_language2 is null or current_language2=0)and product_id=3371 then 7
                when (current_language2 is null or current_language2=0)and product_id=3388 then 4
                when (current_language2 is null or current_language2=0)and product_id=3501 then 11
                when (current_language2 is null or current_language2=0)and product_id=3511 then 12
                else current_language2
            end               as currentlanguage2
      from (select product_id
                  ,user_id
                  ,current_language2
              from dim.dim_short_video_user_accountinfo
             union all
            select 6883       as product_id
                  ,account    as user_id
                  ,current_language2
              from dim.dim_video_cn_accountinfo_view
             union all
            select product_id
                  ,id         as user_id
                  ,current_language2
              from dim.dim_user_account_info_view
           )    as a1
)
select a1.dt                                       as dt                   -- 事件时间
      ,a1.product_id                               as product_id           -- 产品id
      ,a1.user_id                                  as user_id              -- 用户id
      ,a1.core                                     as corever              -- core
      ,a1.mt                                       as mt                   -- 终端
      ,case when a1.product_id = 6833 and a1.positions = 12 then 'Starmobi-H5'
            when a1.product_id <> 6833 and a1.positions = 59 then 'Starmobi-H5'
            else a2.currentlanguage2
        end                                        as current_language2    -- 投放语言
      ,a1.appver                                   as appver               -- 版本号
      ,a1.ad_show_type                             as ad_show_type         -- 广告类型
      ,a1.positions                                as positions            -- 广告位置
      ,a1.ads_name                                 as ads_name             -- 广告来源-广告平台,adomob,topon,max
      ,a1.ads_source                               as ads_source           -- admob广告源,可通过这个反推是哪家具体的广告
      ,a1.main_strategy_id                         as main_strategy_id     -- 主策略id
      ,a1.event_strategy_id                        as event_strategy_id    -- 策略id
      ,a1.programme_id                             as programme_id         -- 频道方案ID
      ,max(case when rk_asc=1 then amount end)     as fst_amt              -- 首次广告收益
      ,max(case when rk_desc=1 then amount end)    as lst_amt              -- 末次广告收益
      ,count(1)                                    as cnt                  -- 次数
      ,sum(amount)                                 as amt                  -- 广告收益
      ,now()                                       as etl_tm               -- 清洗时间
  from (select date(date_add(b1.create_tm,interval -13 hour)) as dt
              ,b1.product_id
              ,b1.user_id
              ,b1.corever                                     as core
              ,b1.mt
              ,b1.appver
              ,b1.create_tm
              ,b1.ad_unit
              ,b1.ad_show_type
              ,b1.position_id                                 as positions
              ,b1.ad_position_amt                             as amount
              ,b1.ads_name
              ,coalesce(b2.ads_source_abbr, b1.ads_source)    as ads_source
              ,b1.main_strategy_id
              ,b1.event_strategy_id
              ,b1.programme_id
              ,row_number() over (partition by date(date_add(b1.create_tm,interval -13 hour))
                                              ,b1.product_id
                                              ,b1.user_id
                                              ,b1.corever
                                              ,b1.mt
                                              ,b1.appver
                                              ,b1.ad_show_type
                                              ,b1.position_id
                                              ,b1.ads_name
                                              ,b1.main_strategy_id
                                              ,b1.event_strategy_id
                                              ,b1.programme_id
                                              ,b1.create_tm
                                              ,b1.ad_unit
                                      order by b1.create_tm
                                              ,b1.ad_unit
                                  )                           as rk_asc
              ,row_number() over (partition by date(date_add(b1.create_tm,interval -13 hour))
                                              ,b1.product_id
                                              ,b1.user_id
                                              ,b1.corever
                                              ,b1.mt
                                              ,b1.appver
                                              ,b1.ad_show_type
                                              ,b1.position_id
                                              ,b1.ads_name
                                              ,b1.main_strategy_id
                                              ,b1.event_strategy_id
                                              ,b1.programme_id
                                              ,b1.create_tm
                                              ,b1.ad_unit
                                      order by b1.create_tm desc
                                              ,b1.ad_unit   desc
                                 )                          as rk_desc
        from dwd.dwd_advertisement_user_position_amt_p_di           as b1
        left join dim.dim_ads_source_abbr                           as b2
          on b1.ads_name = b2.ads_name
         and b1.ads_source = b2.ads_source
       where b1.dt >= date(date_sub('${bf_1_dt}', interval 1 day))
         and b1.dt <= '${dt}'
         and date(date_add(b1.create_tm,interval -13 hour)) in ('${bf_1_dt}', '${dt}')    -- 取西五区的时间数据
     )                       as a1
  left join user_info_tmp    as a2
    on a1.product_id = a2.product_id
   and a1.user_id = a2.user_id
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
 union all
select a1.dt                                              as dt                   -- 事件时间
      ,a1.product_id                                      as product_id           -- 产品id
      ,a1.user_id                                         as user_id              -- 用户id
      ,a1.core                                            as core                 -- core
      ,case when lower(a1.mt)='ios' then 1
            when lower(a1.mt)='android' then 4
            else a1.mt
        end                                               as mt                   -- 终端
      ,a4.currentlanguage2                                as current_language2    -- 投放语言
      ,a1.appver                                          as appver               -- 版本号
      ,a1.ad_show_type                                    as ad_show_type         -- 广告类型
      ,a1.positions                                       as positions            -- 广告位置
      ,a3.ads_name                                        as ads_name             -- 广告来源-广告平台,adomob,topon,max
      ,null                                               as ads_source           -- 广告来源
      ,a1.main_strategy_id                                as main_strategy_id     -- 主策略id
      ,a1.event_strategy_id                               as event_strategy_id    -- 策略id
      ,a1.programme_id                                    as programme_id         -- 频道方案ID
      ,null                                               as fst_amt              -- 首次广告收益
      ,null                                               as lst_amt              -- 末次广告收益
      ,sum(a1.ad_click_count)                             as cnt                  -- 次数
      ,sum(a1.ad_click_count)*max(a3.ad_avg_click_amt)    as amt                  -- 广告收益
      ,now()                                              as etl_tm               -- 清洗时间
  from ad_click_count                        as a1
  left join dim.dim_pub_code_mapping_dict    as a2
    on a1.ads_src=a2.cd_val
   and a2.app_plat='pub'
   and a2.cd_col='ad_src'
  left join avg_click_amount                 as a3
    on a1.dt = a3.dt
   and a1.system_type = a3.system_type
   and a2.cd_val_desc=a3.ads_name
  left join user_info_tmp                    as a4
    on a1.product_id = a4.product_id
   and a1.user_id = a4.user_id
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
;