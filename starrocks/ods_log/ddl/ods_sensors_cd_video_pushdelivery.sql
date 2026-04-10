----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_pushdelivery
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr/xjc
-- 开发日期： 2025-10-21
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_sensors_cd_video_pushdelivery;
CREATE TABLE ods_log.ods_sensors_cd_video_pushdelivery (
     dt                      date      not null    comment "分区日期"
    ,id                      string    not null    comment "nvl(rid,track_id)"
    ,track_id                string                comment ""
    ,rid                     string                comment "记录ID"
    ,event_tm                datetime              comment "事件时间"
    ,device_id               string                comment "设备id"
    ,login_id                string                comment "login_id"
    ,identity_login_id       string                comment "identity_login_id"
    ,event                   string                comment "事件"
    ,app_core_ver            string                comment "core"
    ,distinct_id             string                comment "distinct_id"
    ,app_product_id          string                comment "包体ID"
    ,lib_version             string                comment "lib_version"
    ,app_version             string                comment "app_version"
    ,os                      varchar(200)          comment "操作系统"
    ,app_id                  string                comment "app_id"
    ,push_content            string                comment "推送内容"
    ,push_id                 string                comment "推送ID"
    ,push_jump_page          string                comment "推送发送结果"
    ,push_send_result        string                comment "推送发送结果"
    ,push_title              string                comment "推送标题"
    ,push_type               string                comment "推送消息类型"
    ,project_id              string                comment "5阅读 8 短剧"
    ,etl_tm                  datetime              comment "清洗时间"
    ,fcmMsgType              string                comment "送达消息类型"
    ,hasNotifyPermissions    string                comment "是否有通知权限,0没权限,1有权限"
)
primary key(dt, id)
comment "event=pushDelivery push送达事件"
partition by range(dt)
(partition p20251021 values less than ("2025-10-21"))
distributed by hash(dt, id) buckets 5
properties (
    "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-365"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "3"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;