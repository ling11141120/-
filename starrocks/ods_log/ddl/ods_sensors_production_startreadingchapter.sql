----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_production_startreadingchapter
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具： 极光-实时映射
-- 开发人： wx
-- 开发日期： 2025-10-31
----------------------------------------------------------------
drop table if exists ods_log.ods_sensors_production_startreadingchapter;
create table ods_log.ods_sensors_production_startreadingchapter (
     dt                             date              NOT NULL         COMMENT "分区日期"
    ,id                             varchar(65533)    NOT NULL         COMMENT "nvl(rid,track_id)"
    ,track_id                       varchar(65533)                     COMMENT ""
    ,rid                            varchar(65533)                     COMMENT "记录ID"
    ,event_tm                       datetime                           COMMENT "事件时间"
    ,device_id                      varchar(65533)                     COMMENT "设备id"
    ,login_id                       varchar(65533)                     COMMENT "login_id"
    ,identity_login_id              varchar(65533)                     COMMENT "identity_login_id"
    ,device_lang                    varchar(65533)                     COMMENT "设备语言"
    ,event                          varchar(65533)                     COMMENT "事件"
    ,distinct_id                    varchar(65533)                     COMMENT "distinct_id"
    ,identity_user_id               varchar(65533)                     COMMENT "identity_userid"
    ,app_product_id                 varchar(65533)                     COMMENT "包体ID"
    ,send_id                        varchar(65533)                     COMMENT "转化来源"
    ,app_core_ver                   varchar(65533)                     COMMENT "core"
    ,app_channel                    varchar(65533)                     COMMENT "渠道编号"
    ,app_product_x                  varchar(65533)                     COMMENT "应用程序ID"
    ,app_lang_id                    varchar(65533)                     COMMENT "界面语言"
    ,book_id                        varchar(65533)                     COMMENT "小说ID"
    ,read_chapter_sort              varchar(65533)                     COMMENT "阅读页章节id序号"
    ,chapter_id                     varchar(65533)                     COMMENT "章节id"
    ,page_turning                   varchar(65533)                     COMMENT "翻页方式"
    ,font_size                      varchar(65533)                     COMMENT "字体大小"
    ,is_first_read_book             varchar(65533)                     COMMENT "书籍是否首次阅读"
    ,first_read_source_id           varchar(65533)                     COMMENT "首次阅读来源控件ID"
    ,first_read_source_name         varchar(65533)                     COMMENT "首次阅读来源控件名称"
    ,first_read_source_page_id      varchar(65533)                     COMMENT "首次阅读来源页面ID"
    ,first_read_source_page_name    varchar(65533)                     COMMENT "首次阅读来源页面名称"
    ,read_source_id                 varchar(65533)                     COMMENT "阅读来源控件ID"
    ,read_source_name               varchar(65533)                     COMMENT "阅读来源控件名称"
    ,read_source_page_id            varchar(65533)                     COMMENT "阅读来源页面ID"
    ,read_source_page_name          varchar(65533)                     COMMENT "阅读来源页面名称"
    ,etl_tm                         datetime DEFAULT CURRENT_TIMESTAMP COMMENT ""
    ,activity_link                  varchar(65533)                     COMMENT ""
    ,os                             varchar(65533)                     COMMENT "操作系统"
    ,app_module                     varchar(65533)                     COMMENT "模块"
)
PRIMARY KEY(dt,id)
COMMENT "event=startReadingChapter 开始阅读章节 1.进入阅读页、切换章节后上报（非半屏、语音朗读事件） 2.进入前台，阅读页面关闭遮挡后上报"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(id) BUCKETS 3
PROPERTIES (
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