create or replace view dwd.dwd_sensors_production_itemclick_view (
     dt                  comment "分区日期"
    ,id                  comment "nvl(rid,track_id)"
    ,track_id
    ,rid                 comment "记录ID"
    ,event_tm            comment "事件时间"
    ,device_id           comment "设备id"
    ,login_id            comment "login_id"
    ,identity_login_id   comment "identity_login_id"
    ,device_lang         comment "设备语言"
    ,event               comment "事件"
    ,distinct_id         comment "distinct_id"
    ,identity_user_id    comment "identity_userid"
    ,app_product_id      comment "包体ID"
    ,send_id             comment "转化来源"
    ,app_core_ver        comment "core"
    ,mt                  comment "平台（lib字段）"
    ,app_channel         comment "渠道编号"
    ,app_product_x       comment "应用程序ID"
    ,app_lang_id         comment "界面语言"
    ,app_version         comment "app版本号"
    ,page_name           comment "页面名称"
    ,page_id             comment "页面ID"
    ,element_name        comment "控件名称"
    ,element_id          comment "控件ID"
    ,book_id             comment "小说ID"
    ,is_bookshelf        comment "小说是否已在书架中"
    ,module_channel_id   comment "频道id"
    ,list_id             comment "榜单id"
    ,list_style          comment "榜单样式"
    ,list_name           comment "榜单名称"
    ,list_index          comment "榜单位序"
    ,parent_group_id     comment "用户集合ID"
    ,group_id            comment "用户分组ID"
    ,current_book_id     comment "当前书籍ID"
    ,ranking_type        comment "排行榜类型"
    ,gender              comment "性别"
    ,period              comment "时间周期"
    ,activity_id         comment "活动ID"
    ,app_module          comment "模块"
    ,event_strategy_id   comment "策略id"
    ,project_id          comment "5 阅读 8 短剧"
    ,etl_tm
)
comment "event=itemClick 小说点击 点击小说封面时点击进入详情页或者阅读页"
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
      ,lib AS mt
      ,app_channel
      ,app_product_x
      ,app_lang_id
      ,app_version
      ,page_name
      ,page_id
      ,element_name
      ,element_id
      ,book_id
      ,is_bookshelf
      ,module_channel_id
      ,list_id
      ,list_style
      ,list_name
      ,list_index
      ,parent_group_id
      ,group_id
      ,current_book_id
      ,ranking_type
      ,gender
      ,period
      ,activity_id
      ,app_module
      ,event_strategy_id
      ,project_id
      ,etl_tm
  from ods_log.ods_sensors_cd_video_production_Itemclick
 where project_id = 5
;