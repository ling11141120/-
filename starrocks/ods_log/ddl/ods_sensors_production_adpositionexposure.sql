----------------------------------------------------------------
-- 目标表：ods_sensors_production_adpositionexposure
-- 来源实例：神策埋点
-- 来源表：event=ADPositionExposure
-- 来源负责人：无
-- 开发人：qhr
-- 开发日期：2026-06-09
----------------------------------------------------------------

create table if not exists ods.ods_sensors_production_adpositionexposure (
     dt                date         not null comment "分区日期"
    ,id                string       not null comment "nvl(rid,track_id)"
    ,track_id          string                comment ""
    ,rid               string                comment "记录ID"
    ,event_tm          datetime              comment "事件时间"
    ,device_id         string                comment "设备id"
    ,login_id          string                comment "login_id"
    ,identity_login_id string                comment "identity_login_id"
    ,device_lang       string                comment "设备语言"
    ,event             string                comment "事件"
    ,distinct_id       string                comment "distinct_id"
    ,identity_user_id  string                comment "identity_userid"
    ,app_product_id    string                comment "包体ID"
    ,send_id           string                comment "转化来源"
    ,app_core_ver      string                comment "core"
    ,app_channel       string                comment "渠道编号"
    ,app_product_x     string                comment "应用程序ID"
    ,app_lang_id       string                comment "界面语言"
    ,lib_version       string                comment "lib_version"
    ,app_version       string                comment "app_version"
    ,page_id           string                comment "页面ID"
    ,page_name         string                comment "页面名称"
    ,ad_position_id    string                comment "广告位ID"
    ,ad_position_id1   string                comment "广告位ID_new"
    ,project_id        string                comment "5阅读 8 短剧"
    ,etl_tm            datetime              comment "清洗时间"
    ,app_id            string                comment "app_id"
    ,os                string                comment "操作系统"
    ,core              string                comment "core（废弃）"
    ,ip                string                comment "IP"
    ,city              string                comment "城市"
    ,ad_type           string                comment "广告类型"
    ,element_id        string                comment "控件ID"
    ,element_name      string                comment "控件名称"
    ,element_type      string                comment "控件类型"
    ,product_id        string                comment "产品ID"
    ,ad_strategy_id    string                comment "广告策略ID"
    ,ad_group_id       string                comment "广告人群包ID"
    ,event_strategy_id string                comment "策略ID"
    ,main_strategy_id  string                comment "主策略ID"
    ,programme_id      string                comment "方案ID"
    ,module_channel_id string                comment "频道id"
    ,ad_source         varchar(255)          comment "广告来源"
)
primary key(dt, id)
comment "event=ADPositionExposure 资源位曝光"
partition by range(dt)
(partition p20260609 values less than ("2026-06-10"))
distributed by hash(dt, id) buckets 3
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-90",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "35",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;
