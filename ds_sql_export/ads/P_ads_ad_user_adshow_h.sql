----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_user_adshow_h
-- workflow_version : 2
-- create_user      : qhr
-- task_name        : P_ads_ad_user_adshow_h
-- task_version     : 2
-- update_time      : 2025-12-10 16:27:54
-- sql_path         : \starrocks\tbl_ads_ad_user_adshow_h\P_ads_ad_user_adshow_h
----------------------------------------------------------------
-- SQL语句
----------------------------------------------------------------
-- 程序功能： 广告域-用户广告展示-小时增量
-- 程序名： P_ads_ad_user_adshow_h
-- 目标表： ads.ads_ad_user_adshow_h
-- 负责人： qhr
-- 开发日期： 2025-12-09
-- 版本号： v0.0.0
----------------------------------------------------------------

delete from ads.ads_ad_user_adshow_h where dt >= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_ad_user_adshow_h
-- 统计每日H5点击
with ad_click_count as (
    select date_trunc('hour', date_sub(ctc.event_tm, interval 13 hour))    as dt
         , ctc.app_product_id                                              as product_id
         , ctc.login_id                                                    as user_id
         , ctc.app_core_ver                                                as core
         , ctc.mt                                                          as mt
         , ctc.appver                                                      as appver
         , 5                                                               as ad_show_type
         , 59                                                              as positions
         , ctc.ad_src                                                      as ad_src
         , null                                                            as main_strategy_id
         , null                                                            as event_strategy_id
         , ctc.event_strategy_id                                           as programme_id
         , 2                                                               as system_type
         , count(1)                                                        as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view             as ctc
     where ctc.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ctc.element_id = '100772'
       and ctc.type = '121'
       and ctc.ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    select date_trunc('hour', date_sub(ec.event_tm, interval 13 hour))    as dt
         , ec.app_product_id                                              as product_id
         , ec.login_id                                                    as user_id
         , ec.app_core_ver                                                as core
         , ec.mt                                                          as mt
         , ec.appver                                                      as appver
         , 5                                                              as ad_show_type
         ,ec.ad_position_id                                               as positions
         ,ec.ad_src                                                       as ad_src
         ,ec.main_strategy_id                                             as main_strategy_id
         ,ec.ad_strategy_id                                               as event_strategy_id
         ,ec.programme_id                                                 as programme_id
         ,2                                                               as system_type
         , count(1)                                                       as ad_click_count
      from dwd.dwd_sensors_production_element_click_view                  as ec
     where ec.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ec.element_id = '100356'
       and ec.ad_position_id > 0
       and ec.app_product_id is not null
       and ec.ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    -- 海剧每日H5点击
    select date_trunc('hour', date_sub(adpc.event_tm, interval 13 hour))    as dt
         , adpc.product_id                                                  as product_id
         , adpc.user_id                                                     as user_id
         , adpc.core                                                        as core
         , adpc.mt                                                          as mt
         , adpc.appver                                                      as appver
         , adpc.ad_type                                                     as ad_show_type
         , adpv.ad_position                                                 as positions
         , adpc.ad_src                                                      as ad_src
         , adpc.main_strategy_id                                            as main_strategy_id
         , adpc.event_strategy_id                                           as event_strategy_id
         , adpc.programme_id                                                as programme_id
         , 1                                                                as system_type
         , count(1)                                                         as ad_click_count
      from dwd.dwd_sensors_production_adpositionclick_view                  as adpc
      left join dim.dim_sv_ads_position_view                                as adpv
        on adpc.ad_position_id = adpv.ad_position
     where adpc.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and adpc.ad_type = 6
       and adpc.product_id = 6833
       and adpc.ad_src is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     union all
    select date_trunc('hour', date_sub(ctc.event_tm, interval 13 hour))    as dt
         , 6833                                                            as product_id
         , ctc.login_id                                                    as user_id
         , ctc.corever                                                     as core
         , ctc.mt                                                          as mt
         , ctc.appver                                                      as appver
         , 6                                                               as ad_show_type
         , null                                                            as positions
         , ctc.ad_src                                                      as ad_src
         , null                                                            as main_strategy_id
         , ctc.event_strategy_id                                           as event_strategy_id
         , null                                                            as programme_id
         , 1                                                               as system_type
         , count(1)                                                        as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view             as ctc
     where ctc.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ctc.task_type in ('9', '浏览第三方页面')
       and ctc.app_product_id is null
       and length(ctc.ad_src) >= 1
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
, user_info_tmp as (
    select a1.product_id
         , a1.user_id
         , case when (current_language2 is null or current_language2=0)and product_id=3311 then 6
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
            select 6883                 as product_id
                  ,account              as user_id
                  ,current_language2    as current_language2
              from dim.dim_video_cn_accountinfo_view
             union all
            select product_id           as product_id
                  ,id                   as user_id
                  ,current_language2    as current_language2
              from dim.dim_user_account_info_view
           )    as a1
)
select date_trunc('hour', date_sub(aupa.create_tm, interval 13 hour))    as dt                   -- 事件时间
     , aupa.product_id                                                   as product_id           -- 产品id
     , aupa.user_id                                                      as user_id              -- 用户id
     , aupa.corever                                                      as core                 -- core
     , aupa.mt                                                           as mt                   -- 终端
     , case when aupa.product_id = 6833 and aupa.position_id = 12 then 'Starmobi-H5'
            when aupa.product_id <> 6833 and aupa.position_id = 59 then 'Starmobi-H5'
            else uit.currentlanguage2
       end                                                               as current_language2    -- 投放语言
     , aupa.appver                                                       as appver
     , aupa.ad_show_type                                                 as ad_show_type         -- 广告类型
     , dic.cd_val_desc                                                   as ad_show_type_name    -- 广告类型名称
     , aupa.position_id                                                  as positions            -- 广告位置
     , aupa.ads_name                                                     as ads_name             -- 广告来源
     , coalesce(dasa.ads_source_abbr, aupa.ads_source)                   as ads_source           -- admob广告源
     , aupa.main_strategy_id                                             as main_strategy_id     -- 主策略id
     , aupa.event_strategy_id                                            as event_strategy_id    -- 策略id
     , aupa.programme_id                                                 as programme_id         -- 频道方案ID
     , count(1)                                                          as cnt                  -- 次数
     , now()                                                             as etl_tm               -- 清洗时间
  from dwd.dwd_advertisement_user_position_amt_p_di    as aupa
  left join user_info_tmp                              as uit
    on aupa.product_id = uit.product_id
   and aupa.user_id = uit.user_id
  left join dim.dim_pub_code_mapping_dict              as dic
    on aupa.ad_show_type = dic.cd_val
   and dic.app_plat = 'pub'
   and dic.cd_col = 'ad_show_type'
  left join dim.dim_ads_source_abbr                    as dasa
    on dasa.ads_name = aupa.ads_name
   and dasa.ads_source = aupa.ads_source
 where aupa.create_tm >= date_add('${bf_1_dt}', interval 13 hour)
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 union all
select acc.dt                     as dt                   -- 事件时间
     , acc.product_id             as product_id           -- 产品id
     , acc.user_id                as user_id              -- 用户id
     , acc.core                   as core                 -- core
     , case when lower(acc.mt) = 'ios' then 1
            when lower(acc.mt) = 'android' then 4
            else acc.mt
       end                        as mt                   -- 终端
     , uit.currentlanguage2       as current_language2    -- 投放语言
     , acc.appver                 as appver               -- 版本号
     , acc.ad_show_type           as ad_show_type         -- 广告类型
     , adType.cd_val_desc         as ad_show_type_name    -- 广告类型名称
     , acc.positions              as positions            -- 广告位置
     , adSrc.cd_val_desc          as ads_name             -- 广告来源
     , null                       as ads_source           -- 广告来源
     , acc.main_strategy_id       as main_strategy_id     -- 主策略id
     , acc.event_strategy_id      as event_strategy_id    -- 策略id
     , acc.programme_id           as programme_id         -- 频道方案ID
     , sum(acc.ad_click_count)    as cnt                  -- 次数
     , now()                      as etl_tm               -- 清洗时间
  from ad_click_count                        as acc
  left join user_info_tmp                    as uit
    on acc.product_id = uit.product_id
   and acc.user_id = uit.user_id
  left join dim.dim_pub_code_mapping_dict    as adType
    on acc.ad_show_type = adType.cd_val
   and adType.app_plat = 'pub'
   and adType.cd_col = 'ad_show_type'
  left join dim.dim_pub_code_mapping_dict    as adSrc
    on acc.ad_src = adSrc.cd_val
   and adSrc.app_plat = 'pub'
   and adSrc.cd_col = 'ad_src'
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
;
