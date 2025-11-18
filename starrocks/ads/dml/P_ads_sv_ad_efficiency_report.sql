----------------------------------------------------------------
-- 程序功能： 广告效能【海剧】
-- 程序名： P_ads_sv_ad_efficiency_report
-- 目标表： ads.ads_sv_ad_efficiency_report
-- 负责人： xjc
-- 开发日期：2025-11-05
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_sv_ad_efficiency_report
-- 活跃表
with active as (
    select a1.dt
          ,a1.period_type
          ,a1.product_id
          ,a1.user_type
          ,a1.corever
          ,a1.mt
          ,a3.enum_name
          ,a1.reg_country
          ,a4.country
          ,a1.country_level
          ,a1.current_language2
          ,a2.remarks
          ,a1.user_id
      from (select *
              from dws.dws_user_short_video_wide_active_period_ed
             where dt >= '${bf_1_dt}'
           )    as a1
      left join dim.dim_dic    as a2
        on a1.current_language2 = a2.enum_id
       and a2.table_name = 'dim_producttype'
       and a2.dic_column = 'language_id'
      left join dim.dim_dic    as a3
        on a1.mt = a3.enum_id
       and a3.table_name = 'dim_user_accountinfo_df'
       and a3.dic_column = 'mt'
      left join dim.dim_country_dic    as a4
        on a1.reg_country = a4.code
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
-- 广告曝光数据
, ad_exposure as (
    select a1.dt
          ,a1.product_id
          ,coalesce(a2.cd_val_desc,'其他')    as ad_src
          ,a1.position_id
          ,a1.ad_type
          ,a1.event_strategy_id
          ,a1.login_id
          ,max(a1.main_strategy_id)           as main_strategy_id
          ,count(1)                           as pv
      from (select dt
                  ,product_id
                  ,ad_src
                  ,coalesce(ad_position_id1, ad_position_id)    as position_id
                  ,ad_type
                  ,event_strategy_id
                  ,login_id
                  ,main_strategy_id
              from ads.ads_sensors_cd_video_adpositionexposure_view    -- event=ADPositionExposure 资源位曝光 ods_log.ods_sensors_production_adpositionexposure project_id=8，只取海剧
             where dt >= '${bf_1_dt}'
             union all
            select dt
                  ,product_id
                  ,ad_source
                  ,coalesce(ad_position_id1, ad_position_id)    as position_id
                  ,ad_type
                  ,event_strategy_id
                  ,login_id
                  ,main_strategy_id
              from ads.ads_sensors_cd_video_adshow_view    -- event=ADShow 广告播放 ods_log.ods_sensors_production_adshow project_id=8，只取海剧
             where dt >= '${bf_1_dt}'
               and ad_type in(2, 4, 5)
               and ifnull(ad_position_id1, ad_position_id) != 9
           )    as a1
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.ad_src = a2.cd_val
     group by 1, 2, 3, 4, 5, 6, 7
)
-- 广告点击数据
, ad_click as (
    select a1.dt
          ,a1.product_id
          ,coalesce(a2.cd_val_desc,'其他')                     as ad_src
          ,coalesce(a1.ad_position_id1, a1.ad_position_id)    as position_id
          ,a1.ad_type
          ,a1.event_strategy_id
          ,a1.login_id
          ,count(1)                                           as pv
      from ads.ads_sensors_cd_video_adpositionclick_view    as a1    -- event=ADPositionClick 资源位点击  ods_log.ods_sensors_production_adpositionclick  project_id = 8
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.ad_src = a2.cd_val
     where dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6, 7
)
-- 广告观看完成
, ad_watchsuccess as (
    select a1.dt
          ,a1.product_id
          ,coalesce(a2.cd_val_desc,'其他')                     as ad_src
          ,coalesce(a1.ad_position_id1, a1.ad_position_id)    as position_id
          ,a1.ad_type
          ,a1.event_strategy_id
          ,a1.login_id
          ,count(1)                                           as pv
      from ads.ads_sensors_cd_video_adwatchsuccess_view    as a1    -- event=ADWatchSuccess 广告完播 ods_log.ods_sensors_production_adwatchsuccess  project_id = 8
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.ad_source = a2.cd_val
     where dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6, 7
)
-- 广告解锁     
, ad_unlock as (
    select a1.dt
          ,a1.product_id
          ,'其他'             as ad_src
          ,a2.unlock_type    as position_id
          ,a3.AdShowType     as ad_type
          ,a1.event_strategy_id
          ,a1.login_id
          ,count(1)          as pv
      from ods_log.ods_sensors_cd_video_unlockEpisode    as a1      -- event=unlockEpisode 解锁剧集事件
      left join ods.ods_tidb_short_video_series_ads_strategy    as a2
        on a1.event_strategy_id = a2.id
      left join ods.ods_tidb_video_tidb_tag_center_ads_position_map_da    as a3
        on a2.unlock_type = a3.AdPosition
     where a1.dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6, 7
)
-- 预估广告收益 神策数据源
, ad_revenue as (
    select a1.dt
          ,a1.product_id
          ,coalesce(a2.cd_val_desc,'其他')    as ad_src
          ,a1.positions
          ,a1.ad_show_type                   as ad_type
          ,a1.event_strategy_id
          ,a1.user_id
          ,sum(a1.amt)                       as amt
      from dws.dws_advertisement_user_position_amt_ed    as a1
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.ads_name = a2.cd_val
     where a1.dt >= '${bf_1_dt}'
       and a1.product_id = 6833
     group by 1, 2, 3, 4, 5, 6, 7
)
-- 半屏充值金额
, recharge_amt as (
    select a1.dt
          ,a1.product_id
          ,a1.period_type
          ,a1.user_type
          ,a1.corever
          ,case when lower(a1.mt) = 'ios' then 1
                when lower(a1.mt) = 'android' then 4
                else a1.mt
            end                                              as mt
          ,a1.put_language
          ,regexp_replace(a1.country_level, '[^0-9]', '')    as country_level
          ,a1.strategy_id
          ,a1.user_id
          ,sum(a1.recharge_amount)                           as recharge_amount
      from (select b1.dt
                  ,b1.product_id
                  ,b1.period_type
                  ,b1.user_type
                  ,b1.corever
                  ,b1.mt
                  ,b1.put_language
                  ,b1.country_level
                  ,b1.strategy_id
                  ,if(b2.strategy_code regexp '^HC', 'H5', b1.recharge_source)    as recharge_source
                  ,b1.user_id
                  ,b2.strategy_code
                  ,b1.recharge_amount
              from (select *
                      from ads.ads_bi_sv_recharge_user_detail_di    -- 海剧充值用户明细报表
                     where product_id = 6833
                       and dt >= '${bf_1_dt}'
                   )    as b1
              left join (select id
                               ,name
                               ,strategy_code
                               ,sort
                               ,null    as sort_popup
                               ,null    as sort_return
                           from ads.ads_sv_goods_strategy_view
                          union all
                         select Id
                               ,Name
                               ,max(StrategyCode)                       as strategy_code
                               ,null                                    as sort
                               ,max(if(action_type = 3, sort, null))    as sort_popup
                               ,max(if(action_type = 9, sort, null))    as sort_return
                           from ods.ods_tidb_short_video_center_activity    as c1
                           left join ads.ads_tidb_short_video_center_activity_position_view    as c2
                             on c1.Id = c2.center_activity_id
                          group by 1, 2
                        )    as b2
                on b1.strategy_id = b2.id
           )    as a1
     where recharge_source = '半屏'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
select a1.dt                            as dt                        -- 日期
      ,a1.period_type                   as period_type               -- 统计周期类型
      ,a1.product_id                    as product_id                -- 产品id
      ,a1.user_id                       as user_id                   -- 用户id
      ,a1.user_type                     as user_type                 -- 用户类型
      ,a1.corever                       as corever                  -- core
      ,a1.mt                            as mt                        -- mt
      ,a1.mt_name                       as mt_name                   -- mt名称
      ,a1.reg_country                   as reg_country               -- 注册国家缩写
      ,a1.country                       as country                   -- 注册国家
      ,a1.country_level                 as country_level             -- 国家等级
      ,a1.current_language2             as current_language2         -- 注册语言
      ,a1.current_language2_name        as current_language2_name    -- 注册语言名称
      ,a1.position_id                   as position_id               -- 广告位ID
      ,a1.ad_type                       as ad_type                   -- 广告类型ID
      ,a1.ad_position_type              as ad_position_type          -- 广告位类型名称
      ,a1.ad_src                        as ad_src                    -- 广告来源
      ,a1.event_strategy_id             as event_strategy_id         -- 策略id
      ,a1.main_strategy_id              as main_strategy_id          -- 主策略ID
      ,a1.exposure_id                   as exposure_id               -- 曝光用户id
      ,a1.exposure_pv                   as exposure_pv               -- 曝光用户pv
      ,a1.click_id                      as click_id                  -- 点击用户id
      ,a1.click_pv                      as click_pv                  -- 点击用户pv
      ,a1.watchsuccess_id               as watchsuccess_id           -- 观看成功用户id
      ,a1.watchsuccess_pv               as watchsuccess_pv           -- 观看成功用户pv
      ,a1.unlock_id                     as unlock_id                 -- 解锁用户id
      ,a1.unlock_pv                     as unlock_pv                 -- 解锁用户pv
      ,a1.amt                           as amt                       -- 广告收益
      ,a1.row_amt                       as row_amt                   -- 主策略收益倒序
      ,ifnull(a2.recharge_amount, 0)    as recharge_amount           -- 充值金额
      ,now()                            as etl_time                  -- etl清洗时间
  from (select b1.dt
              ,b1.period_type
              ,b1.product_id
              ,b1.user_id
              ,b1.user_type
              ,b1.corever
              ,b1.mt
              ,b1.enum_name    as mt_name
              ,b1.reg_country
              ,b1.country
              ,b1.country_level
              ,b1.current_language2
              ,b1.remarks      as current_language2_name
              ,b2.position_id
              ,b2.ad_type
              ,b2.ad_position_type
              ,b2.ad_src
              ,b2.event_strategy_id
              ,b2.main_strategy_id
              ,b2.exposure_id
              ,b2.exposure_pv
              ,b2.click_id
              ,b2.click_pv
              ,b2.watchsuccess_id
              ,b2.watchsuccess_pv
              ,b2.unlock_id
              ,b2.unlock_pv
              ,b2.amt
              ,if(b2.main_strategy_id is null
                 ,1
                 ,row_number() over (partition by b1.dt
                                                 ,b1.user_id
                                                 ,b2.main_strategy_id
                                         order by b2.amt desc
                                    )
                 )             as row_amt
              ,now()           as etl_time
          from active    as b1
          left join (select coalesce(c1.dt, c2.dt, c3.dt, c5.dt, c4.dt)                                               as dt
                           ,coalesce(c1.product_id, c2.product_id, c3.product_id, c5.product_id, c4.product_id)       as product_id
                           ,coalesce(c1.ad_src, c2.ad_src, c3.ad_src, c5.ad_src, c4.ad_src)                           as ad_src
                           ,coalesce(c1.position_id, c2.position_id, c3.position_id, c5.positions, c4.position_id)    as position_id
                           ,coalesce(c1.ad_type, c2.ad_type, c3.ad_type, c5.ad_type, c4.ad_type)                      as ad_type
                           ,case when coalesce(c1.position_id, c2.position_id, c3.position_id, c5.positions, c4.position_id) in (7, 11, 13, 19, 22) then '播放页'
                                 when coalesce(c1.position_id, c2.position_id, c3.position_id, c5.positions, c4.position_id) in (4, 5, 6) then '福利中心'
                                 when coalesce(c1.position_id, c2.position_id, c3.position_id, c5.positions, c4.position_id) in (8, 9, 18) then '其他'
                                 else coalesce(c1.position_id, c2.position_id, c3.position_id, c5.positions, c4.position_id)
                             end                                                                                      as ad_position_type
                           ,coalesce(c1.event_strategy_id
                                    ,c2.event_strategy_id
                                    ,c3.event_strategy_id
                                    ,c5.event_strategy_id
                                    ,c4.event_strategy_id)                                                            as event_strategy_id
                           ,coalesce(c1.login_id, c2.login_id, c3.login_id, c5.user_id, c4.login_id)                  as login_id
                           ,max(c1.main_strategy_id)                                                                  as main_strategy_id
                           ,max(c1.login_id)                                                                          as exposure_id
                           ,sum(ifnull(c1.pv, 0))                                                                     as exposure_pv
                           ,max(c2.login_id)                                                                          as click_id
                           ,sum(ifnull(c2.pv, 0))                                                                     as click_pv
                           ,max(c3.login_id)                                                                          as watchsuccess_id
                           ,sum(ifnull(c3.pv, 0))                                                                     as watchsuccess_pv
                           ,max(c4.login_id)                                                                          as unlock_id
                           ,sum(ifnull(c4.pv, 0))                                                                     as unlock_pv
                           ,sum(ifnull(c5.amt, 0))                                                                    as amt
                       from ad_exposure      as c1
                       full join ad_click    as c2
                         on c1.product_id = c2.product_id
                        and c1.login_id = c2.login_id
                        and c1.dt = c2.dt
                        and c1.position_id = c2.position_id
                        and c1.ad_type = c2.ad_type
                        and c1.event_strategy_id = c2.event_strategy_id
                        and c1.ad_src = c2.ad_src
                       full join ad_watchsuccess    as c3
                         on c1.product_id = c3.product_id
                        and c1.login_id = c3.login_id
                        and c1.dt = c3.dt
                        and c1.position_id = c3.position_id
                        and c1.ad_type = c3.ad_type
                        and c1.event_strategy_id = c3.event_strategy_id
                        and c1.ad_src = c3.ad_src
                       full join ad_unlock    as c4
                         on c1.product_id = c4.product_id
                        and c1.login_id = c4.login_id
                        and c1.dt = c4.dt
                        and c1.position_id = c4.position_id
                        and c1.ad_type = c4.ad_type
                        and c1.event_strategy_id = c4.event_strategy_id
                        and c1.ad_src = c4.ad_src
                       full join ad_revenue    as c5
                         on c1.product_id = c5.product_id
                        and c1.login_id = c5.user_id
                        and c1.dt = c5.dt
                        and c1.position_id = c5.positions
                        and c1.ad_type = c5.ad_type
                        and c1.event_strategy_id = c5.event_strategy_id
                        and c1.ad_src = c5.ad_src
                      group by 1, 2, 3, 4, 5, 6, 7, 8
                    )    as b2
            on b1.dt = b2.dt
           and b1.product_id = b2.product_id
           and b1.user_id = b2.login_id
       )    as a1
  left join recharge_amt    as a2
    on a1.dt = a2.dt
   and a1.main_strategy_id = a2.strategy_id
   and a1.user_id = a2.user_id
   and a1.row_amt = 1
   and a1.product_id = a2.product_id
   and a1.period_type = a2.period_type
   and a1.user_type = a2.user_type
   and a1.corever = a2.corever
   and a1.mt = a2.mt
   and a1.current_language2_name = a2.put_language
   and a1.country_level = a2.country_level
 order by ifnull(a2.recharge_amount, 0) desc
;
