----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_production_adwatchsuccess
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：qhr/xjc
-- 开发日期：2025-12-01
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_production_H5BackToApp;
create table ods_log.ods_sensors_production_H5BackToApp (
     dt                   date        not null                     comment "分区日期"
    ,id                   string      not null                     comment "nvl(rid,track_id)"
    ,track_id             string                                   comment "跟踪id"
    ,rid                  string                                   comment "记录ID"
    ,event_tm             datetime                                 comment "事件时间"
    ,device_id            string                                   comment "设备id"
    ,login_id             string                                   comment "login_id"
    ,identity_login_id    string                                   comment "identity_login_id"
    ,device_lang          string                                   comment "设备语言"
    ,event                string                                   comment "事件"
    ,distinct_id          string                                   comment "distinct_id"
    ,identity_user_id     string                                   comment "identity_userid"
    ,app_product_id       string                                   comment "包体ID"
    ,send_id              string                                   comment "转化来源"
    ,app_core_ver         string                                   comment "core"
    ,app_channel          string                                   comment "渠道编号"
    ,app_product_x        string                                   comment "应用程序ID"
    ,app_lang_id          string                                   comment "界面语言"
    ,lib_version          string                                   comment "lib_version"
    ,app_version          string                                   comment "app_version"
    ,ad_position_id       string                                   comment "广告位ID"
    ,project_id           string                                   comment "5阅读 8 短剧"
    ,app_id               string                                   comment "app_id"
    ,product_id           string                                   comment "产品ID"
    ,os                   string                                   comment "操作系统"
    ,ip                   string                                   comment "IP"
    ,city                 string                                   comment "城市"
    ,app_name             string                                   comment "应用名称"
    ,status               string                                   comment "状态"
    ,task_id              string                                   comment "任务id	"
    ,ad_strategy_id       string                                   comment "广告策略ID"
    ,ad_group_id          string                                   comment "广告人群包ID"
    ,event_strategy_id    string                                   comment "策略ID"
    ,main_strategy_id     string                                   comment "主策略ID"
    ,programme_id         string                                   comment "方案ID"
    ,module_channel_id    string                                   comment "频道id"
    ,etl_tm               datetime    default current_timestamp    comment "清洗时间"
    ,ad_source            varchar(30)                              comment "广告来源"
)
primary key(dt, id)
comment "event=H5BackToApp H5广告返回APP"
partition by range(dt)
(partition p20251201 values less than ('2025-12-02'))
distributed by hash(dt, id) buckets 3
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-92",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;