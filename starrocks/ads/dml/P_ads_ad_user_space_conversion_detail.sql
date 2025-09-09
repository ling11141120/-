----------------------------------------------------------------
-- 程序功能： 用户广告位转化明细
-- 程序名： P_ads_ad_user_space_conversion_detail
-- 目标表： ads.ads_ad_user_space_conversion_detail
-- 负责人： qhr
-- 开发日期： 2025-09-09
-- 版本号： v0.0.2
----------------------------------------------------------------

insert into ads.ads_ad_user_space_conversion_detail
with z1 as (
    -- 原始广告位曝光
    select dt
          ,login_id
          ,ad_position_id
          ,if( ad_position_id in ('19','63','5','61','23','29')
              ,programme_id
              ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'exposure'                          as event      -- 曝光
          ,'ad'                                as ad_type    -- 普通广告
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_ad_position_exposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and ad_position_id is not null
     group by 1,2,3,4,5
     union all
    -- 福利中心H5广告曝光 (策略ID存方案）
    select dt
          ,login_id
          ,59                                   as ad_position_id
          ,coalesce(event_strategy_id,'-99')    as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')     as main_strategy_id
          ,'exposure'                           as event      -- 曝光
          ,'task'                               as ad_type    -- 任务
          ,count(1)                             as pv
          ,0                                    as amount
      from ads.ads_sensors_production_element_expose_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and element_id = '100772'
       and type = '121'
     group by 1,2,3,4,5
     union all
    -- H5广告位广告曝光
    select dt
          ,login_id
          ,ad_position_id                     as ad_position_id
          ,if( ad_position_id in ('19','63','5','61','23','29')
              ,programme_id
              ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'exposure'                          as event      -- 曝光
          ,'h5_ad'                             as ad_type    -- H5广告
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_element_expose_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and element_id = '100356'
       and ad_position_id > 0
     group by 1,2,3,4,5
     union all
    -- 原始广告位点击
    select dt
          ,login_id 
          ,ad_position_id
          ,if( ad_position_id in ('19','63','5','61','23','29')
              ,programme_id
              ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                 as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'click'                             as event      -- 点击
          ,'ad'                                as ad_type    -- 普通广告
          ,count(1)                            as pv
          ,0                                   as amount
      from ads.ads_sensors_production_adpositionclick_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and ad_position_id is not null
       and project_id = 5
     group by 1,2,3,4,5
     union all
    -- 广告位观看完成
    select dt
          ,login_id
          ,ad_position_id
          ,if( ad_position_id in ('19','63','5','61','23','29')
              ,programme_id
              ,coalesce(ad_strategy_id,programme_id,'-99')
             )                                as ad_strategy_id
          ,coalesce(main_strategy_id,'-99')    as main_strategy_id
          ,'vtc'                              as event    -- 观看完成
          ,'ad'                               as ad_type   -- 普通广告
          ,count(1)                           as pv
          ,0                                  as amount
      from ads.ads_sensors_production_ad_watch_success_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
     group by 1,2,3,4,5
     union all
    -- h5广告位观看完成
    select dt
          ,login_id
          ,ad_position_id
          ,if( ad_position_id in (19,63,5,61,23,29)
              ,programme_id
              ,if( task_id is null
                  ,ad_strategy_id
                  ,coalesce(event_strategy_id,programme_id)
                 )
             )                                  as ad_strategy_id
          ,coalesce(main_strategy_id, '-99')    as main_strategy_id
          ,'vtc'                                as event    -- 观看完成
          ,case when task_id is null then 'h5_ad'
                when task_id is not null then 'task'
            end                                 as ad_type
          ,count(1)                             as pv
          ,0                                    as amount
      from ads.ads_sensors_production_H5BackToApp_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and status = '任务成功'
     group by 1,2,3,4,5,6,7
     union all
    select dt
          ,user_id      as login_id
          ,positions    as ad_position_id
          ,case when positions in (19,63,5,61,23,29) then programme_id
                else if(event_strategy_id > 1,event_strategy_id,programme_id)
            end         as ad_strategy_id
          ,if( main_strategy_id = 'null' or main_strategy_id is null
              ,'-99'
              ,main_strategy_id
             )          as main_strategy_id
          ,'rev'        as event    -- 收益
          ,case when ad_show_type = '5' and  positions  = 59 then 'task'
                when ad_show_type = '5' and  positions <> 59 then 'h5_ad'
                else 'ad'
            end         as ad_type
          ,sum(cnt)     as pv
          ,sum(amt)     as amount
      from dws.dws_advertisement_user_position_amt_ed
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id <> 6833
     group by 1,2,3,4,5,6,7
)
,z2 as (
    select t1.dt
          ,t1.user_id
          ,period_type
          ,user_type
          ,dic_lang.remarks
          ,case when country_level = 1 then 'T1'
                when country_level = 2 then 'T2'
                else '-99'
            end                           as country_level
          ,case when lower(dic_mt.enum_name) = 'ios' then 1
                when lower(dic_mt.enum_name) = 'android' then 4
                else dic_mt.enum_name
            end                           as mt
          ,coalesce(t1.corever, '-99')    as corever
      from dws.dws_user_wide_active_period_ed    as t1
      left join dim.dim_dic dic_lang
        on t1.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join dim.dim_dic                      as dic_mt
        on t1.mt = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
      left join dim.dim_country_dic              as b
        on t1.reg_country = b.code
     where t1.dt >= '${bf_1_dt}'
       and t1.dt <= '${dt}'
     group by 1,2,3,4,5,6,7,8
)
select z1.dt
      ,ifnull(cast(z1.login_id as int),-99)    as user_id
      ,ifnull(z1.ad_position_id,-99)           as ad_position_id
      ,case when coalesce(z1.ad_strategy_id,'-99') in ('-99', '', '-1') then coalesce(z1.ad_strategy_id,'-99')
            else z1.ad_strategy_id
        end                                    as ad_strategy_id
      ,case when coalesce(z1.main_strategy_id,'-99') in ('-99', '', '-1') then coalesce(z1.main_strategy_id,'-99')
            else z1.main_strategy_id
        end                                    as main_strategy_id
      ,case when z1.ad_type = 'ad'    then '普通广告'
            when z1.ad_type = 'h5_ad' then 'h5广告'
            when z1.ad_type = 'task'  then '任务广告'
            else '-99'
        end                                    as ad_type
      ,ifnull(z2.period_type,'-99')            as period_type
      ,ifnull(z2.user_type,-99)                as user_type
      ,ifnull(z2.remarks,-99)                  as put_language
      ,ifnull(z2.country_level,-99)            as country_level
      ,ifnull(z2.mt,-99)                       as mt
      ,ifnull(z2.corever,-99)                  as corever
      ,sum(if(event = 'exposure',z1.pv,0))     as impression_pv
      ,sum(case when z1.event = 'click' then z1.pv
                when z1.event = 'rev' and z1.ad_type in ('task','h5_ad') then z1.pv
                else 0
            end
          )                                    as click_pv
      ,sum(if(z1.event = 'vtc' ,z1.pv,0))      as watch_completion_pv
      ,sum(z1.amount)                          as ad_revenue_amount
      ,now()                                   as etl_time
  from z1
  left join z2
    on z1.dt = z2.dt
   and z1.login_id = z2.user_id
 group by 1,2,3,4,5,6,7,8,9,10,11,12
;