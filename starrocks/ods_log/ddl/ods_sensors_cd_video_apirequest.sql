----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_apirequest
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr/xjc
-- 开发日期： 2025-10-22
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_apirequest;
create table ods_log.ods_sensors_cd_video_apirequest (
     dt                   date      not null    comment "分区日期"
    ,id                   string    not null    comment "nvl(rid,track_id)"
    ,track_id             string                comment "唯一追踪ID"
    ,rid                  string                comment "记录ID"
    ,event_tm             datetime              comment "事件时间"
    ,device_id            string                comment "设备id"
    ,login_id             string                comment "login_id"
    ,identity_login_id    string                comment "identity_login_id"
    ,event                string                comment "事件"
    ,app_core_ver         string                comment "core"
    ,distinct_id          string                comment "distinct_id"
    ,app_product_id       string                comment "包体ID"
    ,lib_version          string                comment "lib_version"
    ,app_version          string                comment "app_version"
    ,os                   varchar(200)          comment "操作系统"
    ,app_id               string                comment "app_id"
    ,failure_reason       string                comment "失败原因"
    ,request_duration     decimal(20,3)         comment "请求时长"
    ,request_type1        string                comment "请求类型"
    ,request_result       string                comment "请求结果"
    ,ip                   string                comment "IP"
    ,anonymous_id         string                comment "匿名id"
    ,etl_tm               datetime              comment "清洗时间"
)
primary key(dt, id)
comment "event=apiRequest API请求事件"
partition by date_trunc('day', dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;