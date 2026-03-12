----------------------------------------------------------------
-- 程序功能： 用户广告位转化明细
-- 程序名： P_ads_ad_user_space_conversion_detail
-- 目标表： ads.ads_ad_user_space_conversion_detail
-- 负责人： qhr/xjc
-- 开发日期： 2025-09-09
-- 版本号： v0.1.2
----------------------------------------------------------------

insert into ads.ads_ad_user_space_conversion_detail
-- 统计各事件用户pv、金额
with event_detail as (
    -- 原始广告位曝光
    select dt
          ,login_id
          ,ad_position_id
          ,if(ad_position_id in ('19','63','5','61','23','29')
             ,programme_id
             ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'其他'                               as ad_src
          ,'exposure'                          as event
          ,'ad'                                as ad_type
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_ad_position_exposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and ad_position_id is not null
     group by 1,2,3,4,5,6
     union all
    -- 广告展示成功事件
    select dt
          ,coalesce(login_id, identity_login_id)    as login_id
          ,ad_position_id
          ,if(ad_position_id in ('19','63','5','61','23','29')
         ,programme_id
         ,coalesce(ad_strategy_id,programme_id,'-99')
           )                                        as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')         as main_strategy_id
          ,coalesce(ad_source,'其他')                as ad_src
          ,'ad_show'                                as event
          ,'ad'                                     as ad_type
          ,count(1)                                 as pv
          ,0                                        as amount
      from ods_log.ods_sensors_production_adshow
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and ad_position_id is not null
       and project_id = 5  -- 海阅项目
     group by 1,2,3,4,5,6
     union all
    -- 福利中心H5广告曝光 (策略ID存方案）
    select dt
          ,login_id
          ,59                                   as ad_position_id
          ,coalesce(event_strategy_id,'-99')    as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')     as main_strategy_id
          ,ad_src                               as ad_src
          ,'exposure'                           as event
          ,'task'                               as ad_type
          ,count(1)                             as pv
          ,0                                    as amount
      from ads.ads_sensors_production_element_expose_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and element_id = '100772'
       and type in('121','123') 
     group by 1,2,3,4,5,6
     union all
    -- H5广告位广告曝光
    select dt
          ,login_id
          ,ad_position_id                      as ad_position_id
          ,if(ad_position_id in ('19','63','5','61','23','29')
             ,programme_id
             ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,ad_src                              as ad_src
          ,'exposure'                          as event
          ,'h5_ad'                             as ad_type
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_element_expose_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and element_id = '100356'
       and ad_position_id > 0
     group by 1,2,3,4,5,6
     union all
    -- 原始广告位点击
    select dt
          ,login_id 
          ,ad_position_id
          ,if(ad_position_id in ('19','63','5','61','23','29')
             ,programme_id
             ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'其他'                               as ad_src
          ,'click'                             as event
          ,'ad'                                as ad_type
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_adpositionclick_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and ad_position_id is not null
       and project_id = 5
     group by 1,2,3,4,5,6
     union all
    -- 广告位观看完成
    select dt
          ,login_id
          ,ad_position_id
          ,if(ad_position_id in ('19','63','5','61','23','29')
             ,programme_id
             ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'其他'                               as ad_src
          ,'vtc'                               as event
          ,'ad'                                as ad_type
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_ad_watch_success_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
     group by 1,2,3,4,5,6
     union all
    -- h5广告位观看完成
    select dt
          ,login_id
          ,ad_position_id
          ,if(ad_position_id in (19,63,5,61,23,29)
             ,programme_id
             ,if(task_id is null
                ,ad_strategy_id
                ,coalesce(event_strategy_id,programme_id)
                )
             )                                  as ad_strategy_id
          ,coalesce(main_strategy_id, '-99')    as main_strategy_id
          ,ad_src                               as ad_src
          ,'vtc'                                as event
          ,case when task_id is null then 'h5_ad'
                when task_id is not null then 'task'
            end                                 as ad_type
          ,count(1)                             as pv
          ,0                                    as amount
      from ads.ads_sensors_production_H5BackToApp_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and status = '任务成功'
     group by 1,2,3,4,5,6,7,8
     union all
    select dt
          ,user_id      as login_id
          ,positions    as ad_position_id
          ,case when positions in (19,63,5,61,23,29) then programme_id
                else if(event_strategy_id > 1
                       ,event_strategy_id
                       ,programme_id
                       )
            end         as ad_strategy_id
          ,if(main_strategy_id = 'null' or main_strategy_id is null
             ,'-99'
             ,main_strategy_id
             )          as main_strategy_id
          ,a2.cd_val    as ad_src
          ,'rev'        as event
          ,case when ad_show_type = '5' and positions = 59 then 'task'
                when ad_show_type = '5' and positions <> 59 then 'h5_ad'
                else 'ad'
            end         as ad_type
          ,sum(cnt)     as pv
          ,sum(amt)     as amount
      from dws.dws_advertisement_user_position_amt_ed    as a1
      left join dim.dim_pub_code_mapping_dict            as a2
        on a1.ads_name = a2.cd_val_desc
       and a2.app_plat = 'pub'
       and a2.cd_col = 'ad_src'
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
           and product_id <> 6833
     group by 1,2,3,4,5,6,7,8
)
-- 用户维度信息
, user_info as (
    select a1.dt
          ,a1.user_id
          ,period_type
          ,user_type
          ,a2.cd_val_desc                 as remarks
          ,case when country_level = 1 then 'T1'
                when country_level = 2 then 'T2'
                else '-99'
            end                           as country_level
          ,case when lower(a3.cd_val_desc) = 'ios' then 1
                when lower(a3.cd_val_desc) = 'android' then 4
                else a3.cd_val_desc
            end                           as mt
          ,coalesce(a1.corever, '-99')    as corever
      from dws.dws_user_wide_active_period_ed    as a1
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.current_language2 = a2.cd_val
       and a2.app_plat = 'pub'
       and a2.cd_col = 'lang_cd'
      left join dim.dim_pub_code_mapping_dict    as a3
        on a1.mt = a3.cd_val
       and a3.app_plat = 'pub'
       and a3.cd_col = 'mt'
     where a1.dt >= '${bf_1_dt}'
       and a1.dt <= '${dt}'
     group by 1,2,3,4,5,6,7,8
)
select a1.dt
      ,ifnull(cast(a1.login_id as int),-99)    as user_id
      ,ifnull(a1.ad_position_id,-99)           as ad_position_id
      ,case when coalesce(a1.ad_strategy_id,'-99') in ('-99', '', '-1') then coalesce(a1.ad_strategy_id,'-99')
            else a1.ad_strategy_id
        end                                    as ad_strategy_id
      ,case when coalesce(a1.main_strategy_id,'-99') in ('-99', '', '-1') then coalesce(a1.main_strategy_id,'-99')
            else a1.main_strategy_id
        end                                    as main_strategy_id
      ,case when a1.ad_type = 'ad'    then '普通广告'
            when a1.ad_type = 'h5_ad' then 'h5广告'
            when a1.ad_type = 'task'  then '任务广告'
            else '-99'
        end                                    as ad_type
      ,ifnull(a2.period_type,'-99')            as period_type
      ,ifnull(a2.user_type,-99)                as user_type
      ,ifnull(a2.remarks,-99)                  as put_language
      ,ifnull(a2.country_level,-99)            as country_level
      ,ifnull(a2.mt,-99)                       as mt
      ,ifnull(a2.corever,-99)                  as corever
      ,sum(if(event = 'exposure',a1.pv,0))     as impression_pv
      ,sum(case when a1.event = 'click' then a1.pv
                when a1.event = 'rev' and a1.ad_type in ('task','h5_ad') then a1.pv
                else 0
            end
          )                                    as click_pv
      ,sum(if(a1.event = 'vtc',a1.pv,0))       as watch_completion_pv
      ,sum(if(a1.event = 'rev',a1.pv,0))       as ad_revenue_pv
      ,sum(a1.amount)                          as ad_revenue_amount
      ,now()                                   as etl_time
      ,ifnull(a3.cd_val_desc,'其他')            as ad_src
      ,sum(if(event = 'ad_show',a1.pv,0))      as ad_show_pv
  from event_detail                          as a1
  left join user_info                        as a2
    on a1.dt = a2.dt
   and a1.login_id = a2.user_id
  left join dim.dim_pub_code_mapping_dict    as a3
    on a1.ad_src = a3.cd_val
   and a3.app_plat = 'pub'
   and a3.cd_col = 'ad_src'
 group by 1,2,3,4,5,6,7,8,9,10,11,12,19
;