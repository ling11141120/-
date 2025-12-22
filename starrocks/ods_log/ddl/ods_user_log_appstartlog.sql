----------------------------------------------------------------
-- 目标表： ods_log.ods_book_user_readchapter
-- 来源实例： old_tidb_source
-- 来源表：
--        readerlog_fr.Log_AppStartLog
--        readerlog_pt.Log_AppStartLog
--        readerlog_ft.Log_AppStartLog
--        readerlog_en.Log_AppStartLog
--        readerlog_ru.Log_AppStartLog
--        readerlog_sp.Log_AppStartLog
--        readerlog_jp.Log_AppStartLog
--        readerlog_id.Log_AppStartLog
--        readerlog_th.Log_AppStartLog
--        readerlog_and2_sync.Log_AppStartLog
--        readerlog_cd2_sync.Log_AppStartLog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-01
----------------------------------------------------------------

drop table if exists ods_log.ods_user_log_appstartlog;
create table ods_log.ods_user_log_appstartlog (
     dt            date         not null                  comment "createtime 分区"
    ,Productid     int(11)      not null                  comment "产品id"
    ,Id            bigint(20)   not null                  comment "自增id"
    ,UserId        bigint(20)                             comment "用户id"
    ,CreateTime    datetime                               comment "用户登录时间"
    ,IP            varchar(512)                           comment "用户ip地址"
    ,MT            int(11)                                comment "终端"
    ,IMEI          varchar(512)                           comment "用户手机设备识别码"
    ,IMSI          varchar(512)                           comment "空字段"
    ,MAC           varchar(512)                           comment "空字段"
    ,Ver           int(11)                                comment "版本号"
    ,Chl           varchar(512)                           comment "投放渠道值"
    ,Device        varchar(512)                           comment "设备号"
    ,SW            int(11)                                comment "客户端分辨率"
    ,SH            int(11)                                comment "客户端分辨率"
    ,DeviceGUID    varchar(512)                           comment "设备guid"
    ,AppId         int(11)                                comment "产品appid"
    ,sr_createtime datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime     default current_timestamp comment "starrocks数据更新时间"
    ,index index1(Productid) using bitmap                 comment 'index_productid'
)
primary key(dt, Productid, Id)
comment "用户登录记录表"
partition by range(dt)
(partition p20251201 values less than ('2025-12-02'))
distributed by hash(Productid, Id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;