create view `ads_sensors_cd_video_operationpositionexposure_view` (
    `dt` comment "日期", `id` comment "主键", `rid` comment "记录ID", `track_id` comment "track_id",
             `event` comment "事件", `event_tm` comment "事件时间", `app_channel` comment "渠道编号",
             `app_id` comment "app_id", `app_lang_id` comment "界面语言", `device_lang` comment "设备语言",
             `login_id` comment "用户ID", `product_id` comment "产品ID", `app_version` comment "应用版本",
             `os` comment "操作系统", `core` comment "core版本，目前有1，2，3", `current_language2` comment "注册时语言",
             `ip` comment "IP", `city` comment "城市", `province` comment "省份", `country` comment "国家",
             `lib` comment "lib", `page_id` comment "页面ID", `page_name` comment "页面名称",
             `element_id` comment "控件ID", `element_type` comment "控件类型", `element_name` comment "控件名称",
             `element_content` comment "元素内容", `activity_id` comment "活动id", `event_strategy_id` comment "策略id",
             `group_id` comment "用户分组id", `project_id` comment "5阅读 8 短剧", `activity_link` comment "活动链路",
             `etl_tm` comment "清洗时间"
)
as
select `ods_log`.`a`.`dt`
     , `ods_log`.`a`.`id`
     , `ods_log`.`a`.`rid`
     , `ods_log`.`a`.`track_id`
     , `ods_log`.`a`.`event`
     , `ods_log`.`a`.`event_tm`
     , `ods_log`.`a`.`app_channel`
     , `ods_log`.`a`.`app_id`
     , `ods_log`.`a`.`app_lang_id`
     , `ods_log`.`a`.`device_lang`
     , `ods_log`.`a`.`login_id`
     , `ods_log`.`a`.`product_id`
     , `ods_log`.`a`.`app_version`
     , `ods_log`.`a`.`os`
     , cast((substring(`ods_log`.`a`.`app_id`, 4, 3)) as INT) as `core`
     , `ods`.`b`.`CurrentLanguage2`                           as `current_language2`
     , `ods_log`.`a`.`ip`
     , `ods_log`.`a`.`city`
     , `ods_log`.`a`.`province`
     , `ods_log`.`a`.`country`
     , `ods_log`.`a`.`lib`
     , `ods_log`.`a`.`page_id`
     , `ods_log`.`a`.`page_name`
     , `ods_log`.`a`.`element_id`
     , `ods_log`.`a`.`element_type`
     , `ods_log`.`a`.`element_name`
     , `ods_log`.`a`.`element_content`
     , `ods_log`.`a`.`activity_id`
     , `ods_log`.`a`.`event_strategy_id`
     , `ods_log`.`a`.`group_id`
     , `ods_log`.`a`.`project_id`
     , `ods_log`.`a`.`activity_link`
     , `ods_log`.`a`.`etl_tm`
  from `ods_log`.`ods_sensors_cd_video_production_operationpositionexposure` as `a`
  left outer join `ods`.`ods_tidb_short_video_accountinfo`                   as `b`
  on `ods_log`.`a`.`login_id` = `ods`.`b`.`Id`
 where `ods_log`.`a`.`project_id` = '8';