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
    select a.dt
          ,a.period_type
          ,a.product_id
          ,a.user_type
          ,a.corever
          ,a.mt
          ,c.enum_name
          ,a.reg_country
          ,d.country
          ,a.country_level
          ,a.current_language2
          ,b.remarks
          ,a.user_id
      from (select *
              from dws.dws_user_short_video_wide_active_period_ed
             where dt >= '${bf_1_dt}'
           )   as a
      left join dim.dim_dic   as b
        on a.current_language2 = b.enum_id
       and b.table_name = 'dim_producttype'
       and b.dic_column = 'language_id'
      left join dim.dim_dic    as c
        on a.mt = c.enum_id
       and c.table_name = 'dim_user_accountinfo_df'
       and c.dic_column = 'mt'
      left join dim.dim_country_dic    as d
        on a.reg_country = d.code
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
-- 广告曝光数据
, ad_exposure as (
    select dt
          ,product_id
          ,position_id
          ,ad_type
          ,event_strategy_id
          ,login_id
          ,max(main_strategy_id)    as main_strategy_id
          ,count(1)                 as pv
      from (select dt
                  ,product_id
                  ,coalesce(ad_position_id1, ad_position_id)    as position_id
                  ,ad_type
                  ,event_strategy_id
                  ,login_id
                  ,main_strategy_id
              from ads.ads_sensors_cd_video_adpositionexposure_view
             where dt >= '${bf_1_dt}'
             union all
            select dt
                  ,product_id
                  ,coalesce(ad_position_id1, ad_position_id)    as position_id
                  ,ad_type
                  ,event_strategy_id
                  ,login_id
                  ,main_strategy_id
              from ads.ads_sensors_cd_video_adshow_view
             where dt >= '${bf_1_dt}'
               and ad_type in(2, 4, 5)
               and ifnull(ad_position_id1, ad_position_id) != 9
         )    as a
     group by 1, 2, 3, 4, 5, 6
)
-- 广告点击数据
, ad_click as (
    select a.dt
          ,a.product_id
          ,coalesce(a.ad_position_id1, a.ad_position_id)    as position_id
          ,ad_type
          ,a.event_strategy_id
          ,a.login_id
          ,count(1)                                         as pv
      from ads.ads_sensors_cd_video_adpositionclick_view    as a
     where dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6
)
-- 广告观看完成
, ad_watchsuccess as (
    select a.dt
          ,a.product_id
          ,coalesce(a.ad_position_id1, a.ad_position_id)    as position_id
          ,a.ad_type
          ,a.event_strategy_id
          ,a.login_id
          ,count(1)                                         as pv
      from ads.ads_sensors_cd_video_adwatchsuccess_view     as a
     where dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6
)
-- 广告解锁     
, ad_unlock as (
    select a.dt
          ,a.product_id
          ,b.unlock_type     as position_id
          ,c.AdShowType      as ad_type
          ,a.event_strategy_id
          ,a.login_id
          ,count(1)          as pv
      from ods_log.ods_sensors_cd_video_unlockEpisode                     as a
      left join ods.ods_tidb_short_video_series_ads_strategy              as b
        on a.event_strategy_id = b.id
      left join ods.ods_tidb_video_tidb_tag_center_ads_position_map_da    as c
        on b.unlock_type = c.AdPosition
     where dt >= '${bf_1_dt}'
     group by 1, 2, 3, 4, 5, 6
)
-- 预估广告收益 神策数据源
, ad_revenue as (
    select dt
          ,product_id
          ,positions
          ,ad_show_type         as ad_type
          ,event_strategy_id
          ,user_id
          ,sum(amt)             as amt
      from dws.dws_advertisement_user_position_amt_ed
     where dt >= '${bf_1_dt}'
       and product_id = 6833
     group by 1, 2, 3, 4, 5, 6
)
-- 半屏充值金额
, recharge_amt as (
    select a.dt
          ,a.product_id
          ,a.period_type
          ,a.user_type
          ,a.corever
          ,case when lower(a.mt) = 'ios' then 1
                when lower(a.mt) = 'android' then 4
                else mt
            end                                             as mt
          ,a.put_language
          ,regexp_replace(a.country_level, '[^0-9]', '')    as country_level
          ,a.strategy_id
          ,a.user_id
          ,sum(a.recharge_amount)                           as recharge_amount
      from (select a.dt
                  ,a.product_id
                  ,a.period_type
                  ,a.user_type
                  ,a.corever
                  ,a.mt
                  ,a.put_language
                  ,a.country_level
                  ,a.strategy_id
                  ,if(b.strategy_code regexp '^HC', 'H5', a.recharge_source)    as recharge_source
                  ,a.user_id
                  ,b.strategy_code
                  ,a.recharge_amount
              from (select *
                      from ads.ads_bi_sv_recharge_user_detail_di
                     where product_id = 6833
                       and dt >= '${bf_1_dt}'
                   ) a
              left join (select id
                               ,name
                               ,strategy_code
                               ,sort
                               ,null                                                           as sort_popup
                               ,null                                                           as sort_return
                           from ads.ads_sv_goods_strategy_view
                          union all
                         select Id
                               ,Name
                               ,max(StrategyCode)                                              as strategy_code
                               ,null as sort
                               ,max(if(action_type = 3, sort, null))                           as sort_popup
                               ,max(if(action_type = 9, sort, null))                           as sort_return
                           from ods.ods_tidb_short_video_center_activity                       as a
                           left join ads.ads_tidb_short_video_center_activity_position_view    as b
                             on a.Id = b.center_activity_id
                          group by 1, 2
                        )    as b
                on a.strategy_id = b.id
           )    as a
     where recharge_source = '半屏'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
select a.dt                             as dt                           -- 日期
      ,a.period_type                    as period_type                  -- 统计周期类型
      ,a.product_id                     as product_id                   -- 产品id
      ,a.user_id                        as user_id                      -- 用户id
      ,a.user_type                      as user_type                    -- 用户类型
      ,a.corever                        as  corever                     -- core
      ,a.mt                             as mt                           -- mt
      ,a.mt_name                        as mt_name                      -- mt名称
      ,a.reg_country                    as reg_country                  -- 注册国家缩写
      ,a.country                        as country                      -- 注册国家
      ,a.country_level                  as country_level                -- 国家等级
      ,a.current_language2              as current_language2            -- 注册语言
      ,a.current_language2_name         as current_language2_name       -- 注册语言名称
      ,a.position_id                    as position_id                  -- 广告位ID
      ,a.ad_type                        as ad_type                      -- 广告类型ID
      ,a.ad_position_type               as ad_position_type             -- 广告位类型名称
      ,a.event_strategy_id              as event_strategy_id            -- 策略id
      ,a.main_strategy_id               as main_strategy_id             -- 主策略ID
      ,a.exposure_id                    as exposure_id                  -- 曝光用户id
      ,a.exposure_pv                    as exposure_pv                  -- 曝光用户pv
      ,a.click_id                       as click_id                     -- 点击用户id
      ,a.click_pv                       as click_pv                     -- 点击用户pv
      ,a.watchsuccess_id                as watchsuccess_id              -- 观看成功用户id
      ,a.watchsuccess_pv                as watchsuccess_pv              -- 观看成功用户pv
      ,a.unlock_id                      as unlock_id                    -- 解锁用户id
      ,a.unlock_pv                      as unlock_pv                    -- 解锁用户pv
      ,a.amt                            as amt                          -- 广告收益
      ,a.row_amt                        as row_amt                      -- 主策略收益倒序
      ,ifnull(b.recharge_amount, 0)     as recharge_amount              -- 充值金额
      ,now()                            as etl_time                     -- etl清洗时间
  from (select a.dt
              ,a.period_type
              ,a.product_id
              ,a.user_id
              ,a.user_type
              ,a.corever
              ,a.mt
              ,a.enum_name              as mt_name
              ,a.reg_country
              ,a.country
              ,a.country_level
              ,a.current_language2
              ,a.remarks                as current_language2_name
              ,b.position_id
              ,b.ad_type
              ,b.ad_position_type
              ,b.event_strategy_id
              ,b.main_strategy_id
              ,b.exposure_id
              ,b.exposure_pv
              ,b.click_id
              ,b.click_pv
              ,b.watchsuccess_id
              ,b.watchsuccess_pv
              ,b.unlock_id
              ,b.unlock_pv
              ,b.amt
              ,if(b.main_strategy_id is null
                 ,1
                 ,row_number() over (partition by a.dt, a.user_id, b.main_strategy_id order by b.amt desc)
                 )                      as row_amt
              ,now()                    as etl_time
          from active                   as a
          left join (select coalesce(a.dt, b.dt, c.dt, d.dt, e.dt)                                                   as dt
                           ,coalesce(a.product_id, b.product_id, c.product_id, d.product_id, e.product_id)           as product_id
                           ,coalesce(a.position_id, b.position_id, c.position_id, d.positions, e.position_id)        as position_id
                           ,coalesce(a.ad_type, b.ad_type, c.ad_type, d.ad_type, e.ad_type)                          as ad_type
                           ,case when coalesce(a.position_id, b.position_id, c.position_id, d.positions, e.position_id) in (7, 11, 13, 19, 22) then '播放页'
                                 when coalesce(a.position_id, b.position_id, c.position_id, d.positions, e.position_id) in (4, 5, 6) then '福利中心'
                                 when coalesce(a.position_id, b.position_id, c.position_id, d.positions, e.position_id) in (8, 9, 18) then '其他'
                                 else coalesce(a.position_id, b.position_id, c.position_id, d.positions, e.position_id)
                             end                                                                                     as ad_position_type
                           ,coalesce(a.event_strategy_id
                                     ,b.event_strategy_id
                                     ,c.event_strategy_id
                                     ,d.event_strategy_id
                                     ,e.event_strategy_id)                                                           as event_strategy_id
                           ,coalesce(a.login_id, b.login_id, c.login_id, d.user_id, e.login_id)                      as login_id
                           ,max(a.main_strategy_id)                                                                  as main_strategy_id
                           ,max(a.login_id)                                                                          as exposure_id
                           ,sum(ifnull(a.pv, 0))                                                                     as exposure_pv
                           ,max(b.login_id)                                                                          as click_id
                           ,sum(ifnull(b.pv, 0))                                                                     as click_pv
                           ,max(c.login_id)                                                                          as watchsuccess_id
                           ,sum(ifnull(c.pv, 0))                                                                     as watchsuccess_pv
                           ,max(e.login_id)                                                                          as unlock_id
                           ,sum(ifnull(e.pv, 0))                                                                     as unlock_pv
                           ,sum(ifnull(d.amt, 0))                                                                    as amt
                       from ad_exposure       as a
                       full join ad_click     as b
                         on a.product_id = b.product_id
                        and a.login_id = b.login_id
                        and a.dt = b.dt
                        and a.position_id = b.position_id
                        and a.ad_type = b.ad_type
                        and a.event_strategy_id = b.event_strategy_id
                       full join ad_watchsuccess c
                         on a.product_id = c.product_id
                        and a.login_id = c.login_id
                        and a.dt = c.dt
                        and a.position_id = c.position_id
                        and a.ad_type = c.ad_type
                        and a.event_strategy_id = c.event_strategy_id
                       full join ad_unlock e
                         on a.product_id = e.product_id
                        and a.login_id = e.login_id
                        and a.dt = e.dt
                        and a.position_id = e.position_id
                        and a.ad_type = e.ad_type
                        and a.event_strategy_id = e.event_strategy_id
                       full join ad_revenue d
                         on a.product_id = d.product_id
                        and a.login_id = d.user_id
                        and a.dt = d.dt
                        and a.position_id = d.positions
                        and a.ad_type = d.ad_type
                        and a.event_strategy_id = d.event_strategy_id
                      group by 1, 2, 3, 4, 5, 6, 7
                    )    as b
            on a.dt = b.dt
           and a.product_id = b.product_id
           and a.user_id = b.login_id
       )                    as a
  left join recharge_amt    as b
    on a.dt = b.dt
   and a.main_strategy_id = b.strategy_id
   and a.user_id = b.user_id
   and a.row_amt = 1
   and a.product_id = b.product_id
   and a.period_type = b.period_type
   and a.user_type = b.user_type
   and a.corever = b.corever
   and a.mt = b.mt
   and a.current_language2_name = b.put_language
   and a.country_level = b.country_level
 order by ifnull(b.recharge_amount, 0) desc
;
