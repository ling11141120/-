create view ads.ads_sensors_production_ad_position_exposure_view(
     dt
    ,id
    ,track_id
    ,rid
    ,event_tm
    ,device_id
    ,login_id
    ,identity_login_id
    ,device_lang
    ,event
    ,distinct_id
    ,identity_user_id
    ,app_product_id
    ,send_id
    ,app_core_ver
    ,app_channel
    ,app_product_x
    ,app_lang_id
    ,lib_version
    ,app_version
    ,page_id
    ,page_name
    ,ad_position_id
    ,ad_position_id1
    ,project_id
    ,etl_tm
    ,app_id
    ,os
    ,core
    ,ip
    ,city
    ,ad_type
    ,element_id
    ,element_name
    ,element_type
    ,product_id
    ,ad_strategy_id
    ,ad_group_id
    ,current_language2
    ,event_strategy_id    comment "策略ID"
    ,main_strategy_id     comment "主策略ID"
    ,programme_id         comment "方案ID"
    ,module_channel_id    comment "频道id"
)
as
select a.dt
      ,a.id
      ,a.track_id
      ,a.rid
      ,a.event_tm
      ,a.device_id
      ,a.login_id
      ,a.identity_login_id
      ,a.device_lang
      ,a.event
      ,a.distinct_id
      ,a.identity_user_id
      ,a.app_product_id
      ,a.send_id
      ,a.app_core_ver
      ,a.app_channel
      ,a.app_product_x
      ,a.app_lang_id
      ,a.lib_version
      ,a.app_version
      ,a.page_id
      ,a.page_name
      ,a.ad_position_id
      ,a.ad_position_id1
      ,a.project_id
      ,a.etl_tm
      ,a.app_id
      ,a.os
      ,a.core
      ,a.ip
      ,a.city
      ,a.ad_type
      ,a.element_id
      ,a.element_name
      ,a.element_type
      ,a.product_id
      ,a.ad_strategy_id
      ,a.ad_group_id
      ,b.current_language2
      ,a.event_strategy_id
      ,a.main_strategy_id
      ,a.programme_id
      ,a.module_channel_id
  from ods_log.ods_sensors_production_adpositionexposure as a
  left join dim.dim_user_account_info_view               as b
    on a.app_product_id = b.product_id
   and a.identity_user_id = b.id
 where a.project_id = 5
;