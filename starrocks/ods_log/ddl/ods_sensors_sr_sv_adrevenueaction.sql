----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_sr_sv_adrevenueaction
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：xjc
-- 开发日期：2026-03-24
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_sr_sv_adrevenueaction;
create table ods_log.ods_sensors_sr_sv_adrevenueaction (
     dt                       date              not null    comment "日期"
    ,id                       varchar(65533)    not null    comment "主键"
    ,rid                      varchar(65533)                comment "记录ID"
    ,track_id                 varchar(65533)                comment "track_id"
    ,event                    varchar(65533)                comment "事件"
    ,event_tm                 datetime                      comment "事件时间"
    ,app_channel              varchar(65533)                comment "渠道编号"
    ,app_id                   varchar(65533)                comment "app_id"
    ,app_lang_id              varchar(65533)                comment "界面语言"
    ,device_lang              varchar(65533)                comment "设备语言"
    ,login_id                 varchar(65533)                comment "用户ID"
    ,product_id               varchar(65533)                comment "产品ID"
    ,app_version              varchar(65533)                comment "应用版本"
    ,os                       varchar(65533)                comment "操作系统"
    ,core                     varchar(65533)                comment "core（废弃）"
    ,ip                       varchar(65533)                comment "IP"
    ,city                     varchar(65533)                comment "城市"
    ,page_id                  varchar(65533)                comment "页面ID"
    ,page_name                varchar(65533)                comment "页面名称(1)"
    ,ad_position_id1          varchar(65533)                comment "广告位ID"
    ,ad_position_id           varchar(65533)                comment "广告位ID（废弃）"
    ,ad_type                  varchar(65533)                comment "广告类型"
    ,element_id               varchar(65533)                comment "控件ID"
    ,element_name             varchar(65533)                comment "控件名称"
    ,element_type             varchar(65533)                comment "控件类型"
    ,ad_id                    varchar(65533)                comment "广告ID"
    ,ad_platform              varchar(65533)                comment "广告平台"
    ,ad_source                varchar(65533)                comment "广告来源"
    ,ad_revenue               varchar(65533)                comment "广告收益"
    ,ad_currency_code         varchar(65533)                comment "货币单位"
    ,ad_revenue_type          varchar(65533)                comment "广告收益类型（废弃）"
    ,ad_revenue_category      varchar(65533)                comment "广告收益类型"
    ,project_id               varchar(65533)                comment "5阅读 8 短剧"
    ,app_core_ver             varchar(65533)                comment "app_core_ver"
    ,ad_strategy_id           varchar(65533)                comment "广告策略ID"
    ,ad_group_id              varchar(65533)                comment "广告人群包ID"
    ,programme_id             varchar(65533)                comment "方案ID"
    ,module_channel_id        varchar(65533)                comment "频道ID"
    ,etl_time                 datetime                      comment ""
    ,event_strategy_id        varchar(65533)                comment "策略ID"
    ,main_strategy_id         varchar(65533)                comment "主策略ID"
    ,shortplay_id             bigint(20)                    comment "剧id"
    ,episode_id               bigint(20)                    comment "集id"
)
primary key (dt, id)
comment "event=ADRevenueAction 广告收益事件"
partition by range (dt)()
properties (
     "replication_num" = "2"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-180"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;