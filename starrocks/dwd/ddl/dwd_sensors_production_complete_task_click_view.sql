create or replace view dwd.dwd_sensors_production_complete_task_click_view (
    ,dt
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
    ,mt
    ,appver
    ,app_channel
    ,app_product_x
    ,app_lang_id
    ,page_name
    ,page_id
    ,element_name
    ,element_id
    ,type
    ,parent_group_id
    ,group_id
    ,event_strategy_id    comment "策略ID"
    ,etl_tm
    ,task_type            comment "任务类型"
    ,corever              comment "corever"
)
as
select dt
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
      ,lib             as mt
      ,app_version     as appver
      ,app_channel
      ,app_product_x
      ,app_lang_id
      ,page_name
      ,page_id
      ,element_name
      ,element_id
      ,type
      ,parent_group_id
      ,group_id
      ,event_strategy_id
      ,etl_tm
      ,task_type
      ,corever
  from ods_log.ods_sensors_production_complete_task_click
;