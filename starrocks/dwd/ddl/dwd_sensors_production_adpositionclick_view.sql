CREATE VIEW dwd_sensors_production_adpositionclick_view (
     dt
    ,id
    ,track_id
    ,rid
    ,event_tm
    ,device_id
    ,user_id
    ,identity_login_id
    ,device_lang
    ,event
    ,distinct_id
    ,identity_user_id
    ,product_id
    ,send_id
    ,app_id
    ,core
    ,mt
    ,app_channel
    ,app_product_x
    ,current_language
    ,lib_version
    ,appver
    ,page_id
    ,page_name
    ,ad_type
    ,ad_position_id
    ,project_id
    ,os                COMMENT "操作系统"
    ,ip                COMMENT "IP"
    ,city              COMMENT "城市"
    ,element_id        COMMENT "控件ID"
    ,element_name      COMMENT "控件名称"
    ,element_type      COMMENT "控件类型"
    ,event_strategy_id COMMENT "策略ID"
    ,parent_group_id   COMMENT "用户集合ID"
    ,main_strategy_id  COMMENT "主策略ID"
    ,ad_strategy_id    COMMENT "广告策略ID"
    ,ad_group_id       COMMENT "广告人群包ID"
    ,programme_id      COMMENT "方案ID"
    ,module_channel_id COMMENT "频道id"
    ,etl_tm
) AS
SELECT dt
      ,id
      ,track_id
      ,rid
      ,event_tm
      ,device_id
      ,login_id AS user_id
      ,identity_login_id
      ,device_lang
      ,event
      ,distinct_id
      ,identity_user_id
      ,if (project_id = 8,6833,app_product_id) AS product_id
      ,send_id
      ,app_id
      ,coalesce(app_core_ver,CAST((substring(app_id,4,3)) AS INT)) AS core
      ,lib AS mt
      ,app_channel
      ,app_product_x
      ,app_lang_id AS current_language
      ,lib_version
      ,app_version AS appver
      ,page_id
      ,page_name
      ,ad_type
      ,coalesce(ad_position_id1,ad_position_id) AS ad_position_id
      ,project_id
      ,os
      ,ip
      ,city
      ,element_id
      ,element_name
      ,element_type
      ,event_strategy_id
      ,parent_group_id
      ,main_strategy_id
      ,ad_strategy_id
      ,ad_group_id
      ,programme_id
      ,module_channel_id
      ,etl_tm
  FROM ods_log.ods_sensors_production_adpositionclick
;