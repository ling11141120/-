----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_client_info
-- 来源实例： video-en-log-mysql-slave
-- 来源表： short_video_log.client_info
--         short_video_log.client_info_*(每月一张)
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-25
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_log_client_info;
create table ods.ods_tidb_short_video_log_client_info (
     Id                      bigint(20)   not null                  comment ""
    ,CreateTime              datetime     not null                  comment ""
    ,appver                  varchar(300)                           comment "版本号"
    ,sign                    varchar(300)                           comment "签名"
    ,corever                 int(11)                                comment "核心版本"
    ,locale                  varchar(300)                           comment "区域设置"
    ,userid                  varchar(300)                           comment "用户ID"
    ,sid                     varchar(300)                           comment "会话ID"
    ,sh                      int(11)                                comment "高度"
    ,langid                  int(11)                                comment "语言ID"
    ,UniqueCdReaderId        varchar(300)                           comment "唯一读卡器ID"
    ,timestamp               bigint(20)                             comment "时间戳"
    ,ver                     int(11)                                comment "版本"
    ,sendid                  varchar(300)                           comment "发送ID"
    ,device2                 varchar(300)                           comment "设备2"
    ,sw                      int(11)                                comment "宽度"
    ,chl                     varchar(300)                           comment "渠道"
    ,syslanguage             varchar(300)                           comment "系统语言"
    ,mt                      int(11)                                comment "类型"
    ,idfa                    varchar(300)                           comment "IDFA"
    ,osver                   varchar(300)                           comment "操作系统版本"
    ,build                   varchar(300)                           comment "构建版本"
    ,appid                   varchar(300)                           comment "应用ID"
    ,x                       varchar(300)                           comment "X"
    ,utcoffset               int(11)                                comment "UTC偏移量"
    ,guid                    varchar(300)                           comment "GUID"
    ,supportutctime          int(11)                                comment "支持UTC时间"
    ,device                  varchar(300)                           comment "设备"
    ,androidid               varchar(300)                           comment "Android ID"
    ,sr_createtime           datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime           datetime     default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id, CreateTime)
comment "短剧-用户观看短剧记录表"
distributed by hash(Id, CreateTime) BUCKETS 250 
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;