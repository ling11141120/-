----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_production_adwatchsuccess
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：qhr
-- 开发日期：2025-12-01
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_production_adwatchsuccess;
create table ods_log.ods_sensors_production_adwatchsuccess (
     dt                  date      not null comment "分区日期"
    ,id                  string    not null comment "nvl(rid,track_id)"
    ,track_id            string             comment ""
    ,rid                 string             comment "记录ID"
    ,event_tm            datetime           comment "事件时间"
    ,device_id           string             comment "设备id"
    ,login_id            string             comment "login_id"
    ,identity_login_id   string             comment "identity_login_id"
    ,device_lang         string             comment "设备语言"
    ,event               string             comment "事件"
    ,distinct_id         string             comment "distinct_id"
    ,identity_user_id    string             comment "identity_userid"
    ,app_product_id      string             comment "包体ID"
    ,send_id             string             comment "转化来源"
    ,app_core_ver        string             comment "core"
    ,app_channel         string             comment "渠道编号"
    ,app_product_x       string             comment "应用程序ID"
    ,app_lang_id         string             comment "界面语言"
    ,lib_version         string             comment "lib_version"
    ,app_version         string             comment "app_version"
    ,page_id             string             comment "页面ID"
    ,page_name           string             comment "页面名称"
    ,ad_position_id      string             comment "广告位ID"
    ,ad_position_id1     string             comment "广告位ID_new"
    ,ad_id               string             comment "广告ID"
    ,ad_type             string             comment "广告类型"
    ,ad_platform         string             comment "广告平台"
    ,ad_source           string             comment "广告来源"
    ,project_id          string             comment "5阅读 8 短剧"
    ,etl_tm              datetime           comment "清洗时间"
    ,app_id              string             comment "app_id"
    ,product_id          string             comment "产品ID"
    ,os                  string             comment "操作系统"
    ,ip                  string             comment "IP"
    ,city                string             comment "城市"
    ,element_id          string             comment "控件ID"
    ,element_name        string             comment "控件名称"
    ,element_type        string             comment "控件类型"
    ,ad_revenue          string             comment "广告收益"
    ,ad_currency_code    string             comment "货币单位"
    ,ad_revenue_category string             comment "广告收益类型"
    ,ad_strategy_id      string             comment "广告策略ID"
    ,ad_group_id         string             comment "广告人群包ID"
    ,event_strategy_id   string             comment "策略ID"
    ,main_strategy_id    string             comment "主策略ID"
    ,programme_id        string             comment "方案ID"
    ,module_channel_id   string             comment "频道id"
)
primary key(dt, id)
comment "event=ADWatchSuccess 广告完播"
partition by range(dt)
(partition p20251201 values less than ("2025-12-02"))
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