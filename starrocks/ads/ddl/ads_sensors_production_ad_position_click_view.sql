create view `ads_sensors_production_ad_position_click_view`
            (`dt`, `id`, `track_id`, `rid`, `event_tm`, `device_id`, `login_id`, `identity_login_id`, `device_lang`,
             `event`, `distinct_id`, `identity_user_id`, `app_product_id`, `send_id`, `app_id`, `app_core_ver`, `lib`,
             `app_channel`, `app_product_x`, `app_lang_id`, `lib_version`, `app_version`, `page_id`, `page_name`,
             `ad_type`, `ad_position_id`, `ad_position_id1`, `project_id`, `etl_tm`, `product_id`, `os`, `ip`, `city`,
             `element_id`, `element_name`, `element_type`, `event_strategy_id`, `parent_group_id`, `current_language2`)
as
select `ods_log`.`a`.`dt`
     , `ods_log`.`a`.`id`
     , `ods_log`.`a`.`track_id`
     , `ods_log`.`a`.`rid`
     , `ods_log`.`a`.`event_tm`
     , `ods_log`.`a`.`device_id`
     , `ods_log`.`a`.`login_id`
     , `ods_log`.`a`.`identity_login_id`
     , `ods_log`.`a`.`device_lang`
     , `ods_log`.`a`.`event`
     , `ods_log`.`a`.`distinct_id`
     , `ods_log`.`a`.`identity_user_id`
     , `ods_log`.`a`.`app_product_id`
     , `ods_log`.`a`.`send_id`
     , `ods_log`.`a`.`app_id`
     , `ods_log`.`a`.`app_core_ver`
     , `ods_log`.`a`.`lib`
     , `ods_log`.`a`.`app_channel`
     , `ods_log`.`a`.`app_product_x`
     , `ods_log`.`a`.`app_lang_id`
     , `ods_log`.`a`.`lib_version`
     , `ods_log`.`a`.`app_version`
     , `ods_log`.`a`.`page_id`
     , `ods_log`.`a`.`page_name`
     , `ods_log`.`a`.`ad_type`
     , `ods_log`.`a`.`ad_position_id`
     , `ods_log`.`a`.`ad_position_id1`
     , `ods_log`.`a`.`project_id`
     , `ods_log`.`a`.`etl_tm`
     , `ods_log`.`a`.`product_id`
     , `ods_log`.`a`.`os`
     , `ods_log`.`a`.`ip`
     , `ods_log`.`a`.`city`
     , `ods_log`.`a`.`element_id`
     , `ods_log`.`a`.`element_name`
     , `ods_log`.`a`.`element_type`
     , `ods_log`.`a`.`event_strategy_id`
     , `ods_log`.`a`.`parent_group_id`
     , `dim`.`b`.`current_language2`
  from `ods_log`.`ods_sensors_production_adpositionclick` as `a`
  left outer join `dim`.`dim_user_account_info_view`      as `b`
  on (`ods_log`.`a`.`app_product_id` = `dim`.`b`.`product_id`) and (`ods_log`.`a`.`identity_user_id` = `dim`.`b`.`id`)
 where `ods_log`.`a`.`project_id` = 5;