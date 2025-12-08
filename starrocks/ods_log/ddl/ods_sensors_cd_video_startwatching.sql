----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_startwatching
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具： 极光-实时映射
-- 开发人： wx/xjc
-- 开发日期： 2025-10-31
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_startwatching;
create table ods_log.ods_sensors_cd_video_startwatching (
     dt                          date              not null    comment "日期"
    ,id                          varchar(65533)    not null    comment "主键"
    ,rid                         varchar(65533)                comment "记录id"
    ,track_id                    varchar(65533)                comment "track_id"
    ,event                       varchar(65533)                comment "事件"
    ,event_tm                    datetime                      comment "事件时间"
    ,app_channel                 varchar(65533)                comment "渠道编号"
    ,app_id                      varchar(65533)                comment "app_id"
    ,app_lang_id                 varchar(65533)                comment "界面语言"
    ,device_lang                 varchar(65533)                comment "设备语言"
    ,login_id                    varchar(65533)                comment "用户id"
    ,product_id                  varchar(65533)                comment "产品id"
    ,app_version                 varchar(65533)                comment "应用版本"
    ,os                          varchar(65533)                comment "操作系统"
    ,ip                          varchar(65533)                comment "ip"
    ,city                        varchar(65533)                comment "城市"
    ,province                    varchar(65533)                comment "省份"
    ,country                     varchar(65533)                comment "国家"
    ,shortplay_id                varchar(65533)                comment "短剧id"
    ,if_first_watch_shortplay    varchar(65533)                comment "短剧是否首次观看"
    ,episode_id                  varchar(65533)                comment "剧集id"
    ,watch_episode_sort          varchar(65533)                comment "内容页剧集id序号"
    ,watch_source_id             varchar(65533)                comment "观看来源控件id"
    ,watch_source_name           varchar(65533)                comment "观看来源控件名称"
    ,watch_source_page_id        varchar(65533)                comment "观看来源页面id"
    ,watch_source_page_name      varchar(65533)                comment "观看来源页面名称"
    ,watch_speeds                varchar(65533)                comment "观看倍速"
    ,send_id                     varchar(65533)                comment "发送id"
    ,activity_link               varchar(65533)                comment "活动链路"
    ,anonymous_id                varchar(65533)                comment "匿名id"
    ,etl_tm                      datetime                      comment "清洗时间"
)
primary key(dt, id)
comment "event=startWatching 开始观看"
partition by range(dt)
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "2"
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