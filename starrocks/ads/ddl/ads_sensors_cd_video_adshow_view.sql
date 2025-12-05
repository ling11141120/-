create or replace view ads.ads_sensors_cd_video_adshow_view (
     dt                comment "分区日期"
    ,id                comment "nvl(rid,track_id)"
    ,track_id          comment "track_id"
    ,rid               comment "记录ID"
    ,event_tm          comment "事件时间"
    ,device_id         comment "设备id"
    ,login_id          comment "login_id"
    ,identity_login_id comment "identity_login_id"
    ,device_lang       comment "设备语言"
    ,event             comment "事件"
    ,distinct_id       comment "distinct_id"
    ,identity_user_id  comment "identity_userid"
    ,app_product_id    comment "包体ID"
    ,send_id           comment "转化来源"
    ,core              comment "core"
    ,app_channel       comment "渠道编号"
    ,app_product_x     comment "应用程序ID"
    ,app_lang_id       comment "界面语言"
    ,lib_version       comment "lib_version"
    ,app_version       comment "app_version"
    ,page_id           comment "页面ID"
    ,page_name         comment "页面名称"
    ,ad_position_id    comment "广告位ID"
    ,ad_position_id1   comment "广告位ID_new"
    ,ad_id             comment "广告ID"
    ,ad_type           comment "广告类型"
    ,ad_platform       comment "广告平台"
    ,ad_source         comment "广告来源"
    ,etl_tm            comment "清洗时间"
    ,app_id            comment "app_id"
    ,product_id        comment "产品ID"
    ,os                comment "操作系统"
    ,ip                comment "IP"
    ,city              comment "城市"
    ,element_id        comment "控件ID"
    ,element_name      comment "控件名称"
    ,element_type      comment "控件类型"
    ,current_language2 comment "投放语言"
    ,event_strategy_id comment "策略ID"
    ,main_strategy_id  comment "主策略ID"
    ,ad_strategy_id    comment "广告策略ID"
    ,ad_group_id       comment "广告人群包ID"
    ,programme_id      comment "方案ID"
    ,module_channel_id comment "频道id"
    ,request_duration  comment "请求时长"
    ,app_core_ver      comment "core"
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
      ,case when ((length(a.app_id)) = 9) then (substring(a.app_id, 6, 1))
            when (a.app_id is null) then ''
            else a.app_id
        end  as core
      ,a.app_channel
      ,a.app_product_x
      ,a.app_lang_id
      ,a.lib_version
      ,a.app_version
      ,a.page_id
      ,a.page_name
      ,a.ad_position_id
      ,a.ad_position_id1
      ,a.ad_id
      ,a.ad_type
      ,a.ad_platform
      ,a.ad_source
      ,a.etl_tm
      ,a.app_id
      ,6833 as product_id
      ,a.os
      ,a.ip
      ,a.city
      ,a.element_id
      ,a.element_name
      ,a.element_type
      ,b.current_language2
      ,a.event_strategy_id
      ,a.main_strategy_id
      ,a.ad_strategy_id
      ,a.ad_group_id
      ,a.programme_id
      ,a.module_channel_id
      ,a.request_duration
      ,a.app_core_ver
  from ods_log.ods_sensors_production_adshow              as a
  left outer join dim.dim_short_video_user_accountinfo    as b
    on a.login_id = b.user_id
 where a.project_id = 8
;