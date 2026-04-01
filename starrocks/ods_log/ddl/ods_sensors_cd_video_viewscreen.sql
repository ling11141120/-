----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_viewscreen
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具： 极光-实时映射
-- 开发人： xjc
-- 开发日期： 2026-03-11
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_viewscreen;
create table ods_log.ods_sensors_cd_video_viewscreen (
     dt                          date              not null    comment "日期"
    ,id                          varchar(65533)    not null    comment "主键"
    ,rid                         varchar(65533)                comment "记录ID"
    ,track_id                    varchar(65533)                comment "track_id"
    ,event                       varchar(65533)                comment "事件"
    ,event_tm                    datetime                      comment "事件时间"
    ,app_channel                 varchar(65533)                comment "渠道编号"
    ,app_id                      varchar(65533)                comment "app_id"
    ,app_lang_id                 varchar(65533)                comment "界面语言"
    ,device_lang                 varchar(65533)                comment "设备语言"
    ,login_id                    varchar(65533)                comment "用户ID"
    ,product_id                  varchar(65533)                comment "产品ID"
    ,app_version                 varchar(65533)                comment "应用版本"
    ,os                          varchar(65533)                comment "操作系统"
    ,ip                          varchar(65533)                comment "IP"
    ,city                        varchar(65533)                comment "城市"
    ,province                    varchar(65533)                comment "省份"
    ,country                     varchar(65533)                comment "国家"
    ,lib                         varchar(65533)                comment "lib"
    ,page_id                     varchar(65533)                comment "页面ID"
    ,page_name                   varchar(65533)                comment "页面名称"
    ,project_id                  varchar(65533)                comment "5阅读 8 短剧"
    ,etl_tm                      datetime                      comment "清洗时间"
    ,dollar_url                  varchar(65533)                comment "$url"
)
primary key(dt, id)
comment "event=viewScreen 页面曝光"
partition by range(dt)
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "3"
   ,"dynamic_partition.enable" = "true"
   ,"dynamic_partition.time_unit" = "DAY"
   ,"dynamic_partition.time_zone" = "Asia/Shanghai"
   ,"dynamic_partition.start" = "-92"
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