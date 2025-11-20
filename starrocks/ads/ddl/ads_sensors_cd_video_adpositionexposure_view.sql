CREATE VIEW `ads_sensors_cd_video_adpositionexposure_view` (`dt` COMMENT "分区日期", `id` COMMENT "nvl(rid,track_id)", `track_id` COMMENT "跟踪id", `rid` COMMENT "记录ID", `event_tm` COMMENT "事件时间", `device_id` COMMENT "设备id", `login_id` COMMENT "登录id", `product_id` COMMENT "产品ID", `identity_login_id` COMMENT "identity_login_id", `device_lang` COMMENT "设备语言", `event` COMMENT "事件", `distinct_id` COMMENT "去重id", `identity_user_id` COMMENT "用户验证id", `app_product_id` COMMENT "包体ID", `send_id` COMMENT "转化来源", `core` COMMENT "core", `app_channel` COMMENT "渠道编号", `app_product_x` COMMENT "应用程序ID", `app_lang_id` COMMENT "界面语言", `lib_version` COMMENT "lib版本", `app_version` COMMENT "app版本", `page_id` COMMENT "页面ID", `page_name` COMMENT "页面名称", `ad_position_id` COMMENT "广告位ID", `ad_position_id1` COMMENT "广告位ID_new", `app_id` COMMENT "app_id", `os` COMMENT "操作系统", `ip` COMMENT "IP", `city` COMMENT "城市", `ad_type` COMMENT "广告类型", `element_id` COMMENT "控件ID", `element_name` COMMENT "控件名称", `element_type` COMMENT "控件类型", `current_language2` COMMENT "当前语言", `ad_strategy_id` COMMENT "广告策略ID", `ad_group_id` COMMENT "广告人群包ID", `event_strategy_id` COMMENT "策略ID", `main_strategy_id` COMMENT "主策略ID", `ad_src` COMMENT "广告来源")
COMMENT "event=ADPositionExposure 资源位曝光" AS 
SELECT `ods_log`.`a`.`dt`
      ,`ods_log`.`a`.`id`
      ,`ods_log`.`a`.`track_id`
      ,`ods_log`.`a`.`rid`
      ,`ods_log`.`a`.`event_tm`
      ,`ods_log`.`a`.`device_id`
      ,`ods_log`.`a`.`login_id`
      ,6833                                                                  AS `product_id`
      ,`ods_log`.`a`.`identity_login_id`
      ,`ods_log`.`a`.`device_lang`
      ,`ods_log`.`a`.`event`
      ,`ods_log`.`a`.`distinct_id`
      ,`ods_log`.`a`.`identity_user_id`
      ,`ods_log`.`a`.`app_product_id`
      ,`ods_log`.`a`.`send_id`
      ,CASE WHEN ((length(`ods_log`.`a`.`app_id`)) = 9) THEN (substring(`ods_log`.`a`.`app_id`, 6, 1))
            WHEN (`ods_log`.`a`.`app_id` IS NULL) THEN ''
            ELSE `ods_log`.`a`.`app_id`
       END                                                                  AS `core`
      ,`ods_log`.`a`.`app_channel`
      ,`ods_log`.`a`.`app_product_x`
      ,`ods_log`.`a`.`app_lang_id`
      ,`ods_log`.`a`.`lib_version`
      ,`ods_log`.`a`.`app_version`
      ,`ods_log`.`a`.`page_id`
      ,`ods_log`.`a`.`page_name`
      ,`ods_log`.`a`.`ad_position_id`
      ,`ods_log`.`a`.`ad_position_id1`
      ,`ods_log`.`a`.`app_id`
      ,`ods_log`.`a`.`os`
      ,`ods_log`.`a`.`ip`
      ,`ods_log`.`a`.`city`
      ,`ods_log`.`a`.`ad_type`
      ,`ods_log`.`a`.`element_id`
      ,`ods_log`.`a`.`element_name`
      ,`ods_log`.`a`.`element_type`
      ,`dim`.`b`.`current_language2`
      ,`ods_log`.`a`.`ad_strategy_id`
      ,`ods_log`.`a`.`ad_group_id`
      ,`ods_log`.`a`.`event_strategy_id`
      ,`ods_log`.`a`.`main_strategy_id`
      ,`ods_log`.`a`.`ad_source`                                             AS `ad_src`
  FROM `ods_log`.`ods_sensors_production_adpositionexposure` AS `a`
  LEFT JOIN `dim`.`dim_short_video_user_accountinfo`          AS `b`
    ON `ods_log`.`a`.`login_id` = `dim`.`b`.`user_id`
 WHERE `ods_log`.`a`.`project_id` = 8
;