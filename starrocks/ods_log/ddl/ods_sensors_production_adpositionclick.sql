----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_production_adpositionclick
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：xjc
-- 开发日期：2025-11-13
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_production_adpositionclick;
create table ods_log.ods_sensors_production_adpositionclick (
     dt                   date              not null    comment "分区日期"
    ,id                   varchar(65533)    not null    comment "nvl(rid,track_id)"
    ,track_id             varchar(65533)                comment "跟踪id"
    ,rid                  varchar(65533)                comment "记录id"
    ,event_tm             datetime                      comment "事件时间"
    ,device_id            varchar(65533)                comment "设备id"
    ,login_id             varchar(65533)                comment "login_id"
    ,identity_login_id    varchar(65533)                comment "identity_login_id"
    ,device_lang          varchar(65533)                comment "设备语言"
    ,event                varchar(65533)                comment "事件"
    ,distinct_id          varchar(65533)                comment "distinct_id"
    ,identity_user_id     varchar(65533)                comment "identity_userid"
    ,app_product_id       varchar(65533)                comment "包体id"
    ,send_id              varchar(65533)                comment "转化来源"
    ,app_id               varchar(65533)                comment "app_id"
    ,app_core_ver         varchar(65533)                comment "core"
    ,lib                  varchar(65533)                comment "平台"
    ,app_channel          varchar(65533)                comment "渠道编号"
    ,app_product_x        varchar(65533)                comment "应用程序id"
    ,app_lang_id          varchar(65533)                comment "界面语言"
    ,lib_version          varchar(65533)                comment "lib_version"
    ,app_version          varchar(65533)                comment "app_version"
    ,page_id              varchar(65533)                comment "页面id"
    ,page_name            varchar(65533)                comment "页面名称"
    ,ad_type              varchar(65533)                comment "广告类型"
    ,ad_position_id       varchar(65533)                comment "广告位id"
    ,ad_position_id1      varchar(65533)                comment "广告位id_new"
    ,project_id           varchar(65533)                comment "5阅读 8 短剧"
    ,etl_tm               datetime                      comment "清洗时间"
    ,product_id           varchar(65533)                comment "产品id"
    ,os                   varchar(65533)                comment "操作系统"
    ,ip                   varchar(65533)                comment "ip"
    ,city                 varchar(65533)                comment "城市"
    ,element_id           varchar(65533)                comment "控件id"
    ,element_name         varchar(65533)                comment "控件名称"
    ,element_type         varchar(65533)                comment "控件类型"
    ,event_strategy_id    varchar(65533)                comment "策略id"
    ,parent_group_id      varchar(65533)                comment "用户集合id"
    ,main_strategy_id     varchar(65533)                comment "主策略id"
    ,ad_strategy_id       varchar(65533)                comment "广告策略id"
    ,ad_group_id          varchar(65533)                comment "广告人群包id"
    ,programme_id         varchar(65533)                comment "方案id"
    ,module_channel_id    varchar(65533)                comment "频道id"
    ,ad_source            varchar(255)                  comment "广告来源"
    ,shortplay_id         varchar(255)                  comment "短剧id"
    ,episode_id           varchar(255)                  comment "剧集id"
    ,appId                varchar(255)                  comment "海阅appId"
    ,dollar_app_id        varchar(255)                  comment "海剧海阅共用，可转换为core值"
)
primary key (dt, id)
comment "event=ADPositionClick 资源位点击"
partition by range(dt)
distributed by hash (dt, id) buckets 3
properties (
    "replication_num" = "2"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-92"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "14"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "ZSTD"
)
;