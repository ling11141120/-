----------------------------------------------------------------
-- 程序功能： 广告域-ADRequest/ADInvocation/ADShow/ADTrigger事件广告位置请求明细数据表
-- 程序名： P_dws_ad_srsv_ad_position_request_df
-- 目标表： dws.dws_ad_srsv_ad_position_request_df
-- 负责人： xjc
-- 开发日期： 2026-01-05
----------------------------------------------------------------

insert into dws.dws_ad_srsv_ad_position_request_df
with ad_position as (
    select id
          ,ad_show_type_name
          ,ad_show_type
          ,ad_position_name
          ,ad_position
          ,'8'    as project_id
          ,create_time
          ,update_time
      from dim.dim_sv_ads_position_view
     union all
    select id
          ,ad_show_type_name
          ,ad_show_type
          ,ad_position_name
          ,ad_position
          ,'5'    as project_id
          ,create_time
          ,update_time
      from dim.dim_sr_ads_position_view
)
, user_active_period as (
    select dt
          ,user_id
          ,period_type
          ,product_id
          ,current_language2
          ,reg_country
          ,'8'        as project_id
          ,corever    as core
      from dws.dws_user_short_video_wide_active_period_ed
     where dt='${bf_1_dt}'
     union all
    select dt
          ,user_id
          ,period_type
          ,product_id
          ,current_language2
          ,reg_country
          ,'5'        as project_id
          ,corever    as core
      from dws.dws_user_wide_active_period_ed
     where dt='${bf_1_dt}'
)
, union_result as (
    select a1.dt
          ,a1.id
          ,a1.login_id                                                                         as user_id
          ,'ADRequest'                                                                         as event_name
          ,ifnull(a1.ad_type, '-99')                                                           as ad_show_type
          ,a3.ad_show_type_name
          ,coalesce(a1.ad_position_id1,a1.ad_position_id,'-99')                                as ad_position_id
          ,a2.ad_position_name
          ,ifnull(a1.ad_id, '-99')                                                             as ad_id
          ,a4.core                                                                             as core
          ,cast((substring(app_id, 4, 3)) as int)                                              as sv_core
          ,cast((substring(appid, 4, 3)) as int)                                               as sr_core
          ,case
               when os in ('Android', 'HarmonyOS') then 4
               when os = 'iOS' then 1
               else -99
               end                                                                             as mt
          ,a4.current_language2                                                                as language_id
          ,a4.reg_country
          ,a1.project_id
          ,cast(substring_index(app_version, '.', 1) as unsigned) * 100
            +
           cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10
            +
           cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned)    as app_ver
          ,a1.request_result
          ,null                                                                                as request_duration
      from ods_log.ods_sensors_cd_video_adrequest    as a1
      left join ad_position                          as a2
        on coalesce(a1.ad_position_id1,a1.ad_position_id,'-99') = a2.ad_position
       and a1.project_id = a2.project_id
      left join (select ad_show_type_name
                       ,ad_show_type
                       ,project_id
                   from ad_position
                  group by 1, 2, 3
                )                                    as a3
        on a1.ad_type = a3.ad_show_type
       and a1.project_id = a3.project_id
      left join user_active_period                   as a4
        on a1.login_id = a4.user_id
       and a1.dt = a4.dt
       and a4.period_type = 'ctt'
       and a1.project_id = a4.project_id
     where a1.dt = '${bf_1_dt}'
     union all
    select a1.dt
          ,a1.id
          ,a1.login_id                                                                         as user_id
          ,'ADInvocation'                                                                      as event_name
          ,ifnull(a1.ad_type, '-99')                                                           as ad_show_type
          ,a3.ad_show_type_name
          ,coalesce(a1.ad_position_id1,a1.ad_position_id,'-99')                                as ad_position_id
          ,a2.ad_position_name
          ,ifnull(a1.ad_id, '-99')                                                             as ad_id
          ,a4.core                                                                             as core
          ,cast((substring(app_id, 4, 3)) as int)                                              as sv_core
          ,cast((substring(appid, 4, 3)) as int)                                               as sr_core
          ,case
               when os in ('Android', 'HarmonyOS') then 4
               when os = 'iOS' then 1
               else -99
               end                                                                             as mt
          ,a4.current_language2                                                                as language_id
          ,a4.reg_country
          ,a1.project_id
          ,cast(substring_index(app_version, '.', 1) as unsigned) * 100
            +
           cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10
            +
           cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned)    as app_ver
          ,null                                                                                as request_result
          ,null                                                                                as request_duration
      from ods_log.ods_sensors_production_adinvocation    as a1
      left join ad_position                               as a2
        on coalesce(a1.ad_position_id1,a1.ad_position_id,'-99') = a2.ad_position
       and a1.project_id = a2.project_id
      left join (select ad_show_type_name
                       ,ad_show_type
                       ,project_id
                   from ad_position
                  group by 1, 2, 3
                )                                         as a3
        on a1.ad_type = a3.ad_show_type
       and a1.project_id = a3.project_id
      left join user_active_period                        as a4
        on a1.login_id = a4.user_id
       and a1.dt = a4.dt
       and a4.period_type = 'ctt'
       and a1.project_id = a4.project_id
     where a1.dt = '${bf_1_dt}'
     union all
    select a1.dt
          ,a1.id
          ,a1.login_id                                                                         as user_id
          ,'ADShow'                                                                            as event_name
          ,ifnull(a1.ad_type, '-99')                                                           as ad_show_type
          ,a3.ad_show_type_name
          ,coalesce(a1.ad_position_id1,a1.ad_position_id,'-99')                                as ad_position_id
          ,a2.ad_position_name
          ,ifnull(a1.ad_id, '-99')                                                             as ad_id
          ,a4.core                                                                             as core
          ,cast((substring(app_id, 4, 3)) as int)                                              as sv_core
          ,cast((substring(appid, 4, 3)) as int)                                               as sr_core
          ,case
               when os in ('Android', 'HarmonyOS') then 4
               when os = 'iOS' then 1
               else -99
               end                                                                             as mt
          ,a4.current_language2                                                                as language_id
          ,a4.reg_country
          ,a1.project_id
          ,cast(substring_index(app_version, '.', 1) as unsigned) * 100
            +
           cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10
            +
           cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned)    as app_ver
          ,null                                                                                as request_result
          ,request_duration
      from ods_log.ods_sensors_production_adshow    as a1
      left join ad_position                         as a2
        on coalesce(a1.ad_position_id1,a1.ad_position_id,'-99') = a2.ad_position
       and a1.project_id = a2.project_id
      left join (select ad_show_type_name
                       ,ad_show_type
                       ,project_id
                   from ad_position
                  group by 1, 2, 3
                )                                   as a3
        on a1.ad_type = a3.ad_show_type
       and a1.project_id = a3.project_id
      left join user_active_period                  as a4
        on a1.login_id = a4.user_id
       and a1.dt = a4.dt
       and a4.period_type = 'ctt'
       and a1.project_id = a4.project_id
     where a1.dt = '${bf_1_dt}'
     union all
    select a1.dt
          ,a1.id
          ,a1.login_id                                                                         as user_id
          ,'ADTrigger'                                                                         as event_name
          ,ifnull(a1.ad_type, '-99')                                                           as ad_show_type
          ,a3.ad_show_type_name
          ,coalesce(a1.ad_position_id1,a1.ad_position_id,'-99')                                as ad_position_id
          ,a2.ad_position_name
          ,ifnull(a1.ad_id, '-99')                                                             as ad_id
          ,a4.core                                                                             as core
          ,cast((substring(app_id, 4, 3)) as int)                                              as sv_core
          ,cast((substring(appid, 4, 3)) as int)                                               as sr_core
          ,case
               when os in ('Android', 'HarmonyOS') then 4
               when os = 'iOS' then 1
               else -99
               end                                                                             as mt
          ,a4.current_language2                                                                as language_id
          ,a4.reg_country
          ,a1.project_id
          ,cast(substring_index(app_version, '.', 1) as unsigned) * 100
            +
           cast(substring_index(substring_index(app_version, '.', 2), '.', -1) as unsigned) * 10
            +
           cast(substring_index(substring_index(app_version, '.', 3), '.', -1) as unsigned)    as app_ver
          ,null                                                                                as request_result
          ,null                                                                                as request_duration
      from ods_log.ods_sensors_production_adtrigger   as a1
      left join ad_position                           as a2
        on coalesce(a1.ad_position_id1,a1.ad_position_id,'-99') = a2.ad_position
       and a1.project_id = a2.project_id
      left join (select ad_show_type_name
                       ,ad_show_type
                       ,project_id
                   from ad_position
                  group by 1, 2, 3
                )                                     as a3
        on a1.ad_type = a3.ad_show_type
       and a1.project_id = a3.project_id
      left join user_active_period                    as a4
        on a1.login_id = a4.user_id
       and a1.dt = a4.dt
       and a4.period_type = 'ctt'
       and a1.project_id = a4.project_id
     where a1.dt = '${bf_1_dt}'
)
select a1.dt                                            as dt                   -- 日期
      ,a1.event_name                                    as event_name           -- 事件名称
      ,a1.id                                            as id                   -- id
      ,a1.user_id                                       as user_id              -- 用户id
      ,if(a1.project_id=5 and a1.event_name='ADRequest'
         ,a2.ad_show_type
         ,a1.ad_show_type
         )                                              as ad_show_type         -- 广告展示类型
      ,case when a1.project_id=5 and a1.ad_position_id=8 then 'Banner'
            when a1.project_id=5 and a1.event_name='ADRequest' then a2.ad_show_type_name
            else a1.ad_show_type_name
        end                                             as ad_show_type_name    -- 广告展示类型名称
      ,a1.ad_position_id                                as ad_position_id       -- 广告位id
      ,a1.ad_position_name                              as ad_position_name     -- 广告位名称
      ,a1.ad_id                                         as ad_id                -- 广告id
      ,coalesce(a1.sv_core,a1.sr_core,a1.core,'-99')    as core                 -- core
      ,a1.mt                                            as mt                   -- mt
      ,coalesce(a1.language_id,'-99')                   as language_id          -- 语言id
      ,coalesce(a1.reg_country,-99)                     as reg_country          -- 注册国家
      ,coalesce(a1.project_id,-99)                      as project_id           -- 5：海阅，8：海剧
      ,a1.app_ver                                       as app_ver              -- 应用版本号
      ,a1.request_result                                as request_result       -- 广告请求结果
      ,a1.request_duration                              as request_duration     -- 请求时长
      ,now()                                            as etl_tm               -- 清洗时间
  from union_result                         as a1
  left join dim.dim_sr_ads_position_view    as a2
    on a1.ad_position_id = a2.ad_position
   and a1.project_id = 5
   and a1.event_name = 'ADRequest'
 where length(a1.ad_id) < 200
   and ((a1.project_id = 8 and app_ver >= 162)
    or (a1.project_id = 5 and app_ver >= 197))
;