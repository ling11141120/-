----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_adrequest
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-22
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_adrequest;
create table ods_log.ods_sensors_cd_video_adrequest (
     dt                date           not null comment "分区日期"
    ,id                string         not null comment "nvl(rid,track_id)"
    ,track_id          string                  comment "唯一追踪ID"
    ,rid               string                  comment "记录ID"
    ,event_tm          datetime                comment "事件时间"
    ,device_id         string                  comment "设备id"
    ,login_id          string                  comment "login_id"
    ,identity_login_id string                  comment "identity_login_id"
    ,event             string                  comment "事件"
    ,app_core_ver      string                  comment "core"
    ,distinct_id       string                  comment "distinct_id"
    ,app_product_id    string                  comment "包体ID"
    ,lib_version       string                  comment "lib_version"
    ,app_version       string                  comment "app_version"
    ,os                varchar(200)            comment "操作系统"
    ,app_id            string                  comment "app_id"
    ,ad_position_id1   string                  comment "广告位置ID1"
    ,failure_reason    string                  comment "失败原因"
    ,group_id          string                  comment "用户分组ID"
    ,request_duration  decimal(20, 3)          comment "请求时长"
    ,request_result    string                  comment "请求结果"
    ,request_type1     string                  comment "请求类型"
    ,ip                string                  comment "IP"
    ,etl_tm            datetime                comment "清洗时间"
    ,page_id           string                  comment "页面ID"
    ,page_name         string                  comment "页面名称"
    ,element_id        string                  comment "控件ID"
    ,element_name      string                  comment "控件名称"
    ,element_type      int                     comment "控件类型"
    ,ad_id             string                  comment "广告ID"
    ,ad_platform       string                  comment "广告平台"
    ,ad_source         string                  comment "广告来源"
    ,ad_type           int                     comment "广告类型"
    ,main_strategy_id  string                  comment "主策略ID"
    ,event_strategy_id string                  comment "策略ID"
)
primary key(dt, id)
comment "event=ADRequest 广告请求事件"
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