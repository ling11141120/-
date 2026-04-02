----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_device_info
-- 来源实例： old_tidb_source
-- 来源表： short_video.device_info
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期：2026-03-25
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_device_info;
create table ods.ods_tidb_short_video_device_info (
    id                        bigint      not null                     comment "id"
   ,appver                    varchar(50)                              comment "app版本号"
   ,sign                      varchar(255)                             comment "签名"
   ,corever                   varchar(50)                              comment "核心版本"
   ,locale                    varchar(50)                              comment "区域设置"
   ,userid                    varchar(255)                             comment "用户ID"
   ,sid                       varchar(50)                              comment "会话ID"
   ,sh                        int                                      comment "高度"
   ,langid                    int                                      comment "语言ID"
   ,uniquecdreaderid          varchar(50)                              comment "唯一读卡器ID，UNI索引"
   ,timestamp                 bigint                                   comment "时间戳"
   ,ver                       int                                      comment "版本"
   ,sendid                    varchar(50)                              comment "发送ID"
   ,device2                   varchar(50)                              comment "设备型号"
   ,sw                        int                                      comment "宽度"
   ,chl                       varchar(255)                             comment "渠道"
   ,syslanguage               varchar(50)                              comment "系统语言"
   ,mt                        varchar(50)                              comment "类型"
   ,idfa                      varchar(255)                             comment "IDFA"
   ,osver                     varchar(50)                              comment "操作系统版本"
   ,build                     varchar(50)                              comment "构建版本"
   ,appid                     varchar(50)                              comment "应用ID"
   ,x                         varchar(50)                              comment "X"
   ,utcoffset                 int                                      comment "UTC偏移量"
   ,guid                      varchar(255)                             comment "GUID"
   ,supportutctime            int                                      comment "支持UTC时间"
   ,device                    varchar(50)                              comment "设备"
   ,androidid                 varchar(50)                              comment "Android ID"
   ,devicetoken               varchar(255)                             comment ""
   ,signnotify                tinyint                                  comment "是否开启签到推送"
   ,appnotify                 tinyint                                  comment "是否开启推送"
   ,regionid                  smallint                                 comment "归属区域 id，1：香港，2：北美；"
   ,realtimeactivitynotify    int                                      comment "实时活动启用状态：1不支持，2支持未开启，3支持未授权，4支持"
   ,sr_createtime             datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime             datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "短剧设备信息表"
distributed by hash(id) buckets 105
properties (
    "replication_num" = "3"
   ,"bloom_filter_columns" = "device2"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;