----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_yqx_ods_sensors_cd_video_operationpositionclick
-- workflow_version : 1
-- create_user      : yaoqx
-- task_name        : tbl_ods_sensors_operationpositionclick
-- task_version     : 1
-- update_time      : 2024-01-17 23:48:43
-- sql_path         : \starrocks\tbl_yqx_ods_sensors_cd_video_operationpositionclick\tbl_ods_sensors_operationpositionclick
----------------------------------------------------------------
-- SQL语句
insert into ods_log.ods_sensors_cd_video_production_operationPositionClick
select
    dt,
    COALESCE (rid,track_id)id,
    rid,
    track_id,
    event,
    from_unixtime(cast (event_tm/1000 as int), 'yyyy-MM-dd HH:mm:ss') event_tm,
    app_channel,
    app_id,
    app_lang_id,
    device_lang,
    login_id,
    product_id,
    app_version,
    os,
    ip,
    city,
    province,
    country,
    lib,
    device_id,
    identity_login_id,
    distinct_id,
    identity_user_id,
    app_product_id,
    send_id,
    app_core_ver,
    app_product_x,
    lib_version,
    page_id,
    page_name,
    element_id,
    element_type,
    element_name,
    element_content,
    activity_id,
    event_strategy_id,
    group_id,
    parent_group_id,
    countdown,
    start_type,
    project_id,
    now()
from
ods_log.ods_sensors_cd_video_production_operationpositionclick_hive where dt ='${bf_1_dt}';
