create or replace view ads.ads_sensors_cd_video_ElmentExposure_view (
     dt                 comment "日期"
    ,id                 comment "主键"
    ,rid                comment "记录ID"
    ,track_id           comment "track_id"
    ,event              comment "事件"
    ,event_tm           comment "事件时间"
    ,app_channel        comment "渠道编号"
    ,app_id             comment "app_id"
    ,app_lang_id        comment "界面语言"
    ,device_lang        comment "设备语言"
    ,login_id           comment "用户ID"
    ,product_id         comment "产品ID"
    ,app_version        comment "应用版本"
    ,os                 comment "操作系统"
    ,ip                 comment "IP"
    ,city               comment "城市"
    ,province           comment "省份"
    ,country            comment "国家"
    ,lib                comment "lib"
    ,page_name          comment "页面名称"
    ,element_id         comment "控件ID"
    ,element_name       comment "控件名称"
    ,shortplay_id       comment "短剧ID（仅在视频播放页上报）"
    ,episode_id         comment "剧集ID（仅在视频播放页上报）"
    ,watch_episode_sort comment "内容页剧集ID序号（仅在视频播放页上报）"
    ,button_status      comment "按钮状态（例如：开/关，适用于点赞、追剧等开关状态的按钮）"
    ,element_content    comment "元素内容（适用于类似倍速控件、选集控件等带有数值信息的控件或特殊对象时记录曝光/点击元素的内容）"
    ,project_id         comment "5阅读 8 短剧"
    ,zffs_list
    ,sfzf_strategy_id
    ,element_index
    ,activity_id
    ,group_id
    ,page_id            comment "页面id"
    ,first_tag_list     comment "一级标签列表"
    ,second_tag_list    comment "二级标签列表"
    ,third_tag_list     comment "三级标签列表"
    ,app_core_ver       comment "core"
    ,etl_tm             comment "清洗时间"
)
as
select dt
      ,id
      ,rid
      ,track_id
      ,event
      ,event_tm
      ,app_channel
      ,app_id
      ,app_lang_id
      ,device_lang
      ,login_id
      ,product_id
      ,app_version
      ,os
      ,ip
      ,city
      ,province
      ,country
      ,lib
      ,page_name
      ,element_id
      ,element_name
      ,shortplay_id
      ,episode_id
      ,watch_episode_sort
      ,button_status
      ,element_content
      ,project_id
      ,zffs_list
      ,sfzf_strategy_id
      ,element_index
      ,activity_id
      ,group_id
      ,page_id
      ,first_tag_list
      ,second_tag_list
      ,third_tag_list
      ,app_core_ver
      ,etl_tm
  from ods_log.ods_sensors_cd_video_ElmentExposure
;