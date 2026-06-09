----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_short_video_log_getmoneylog
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.short_video_log_getmoneylog
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_short_video_log_getmoneylog;
create table ods.ods_tidb_finance_snapshot_short_video_log_getmoneylog (
     Id            int                           not null comment "id"
    ,UserId        bigint                                 comment "用户id"
    ,VipLv         int                                    comment "vip等级"
    ,PayChl        varchar(50)                            comment "payorder.type"
    ,Charge        int                                    comment "充值金额"
    ,RealGet       int                                    comment "实际获取到的阅币数量"
    ,Give          int                                    comment "实际获取到的赠送币数量"
    ,CurMoney      int                                    comment "用户当前阅币数量"
    ,GetTime       datetime                               comment "获得时间"
    ,reforderid    varchar(255)                           comment "payorder.orderid"
    ,Seq           bigint                                 comment "自增的序号"
    ,cps           int                                    comment "cps"
    ,chl2          varchar(255)                           comment "chl2"
    ,ChargeType    int                                    comment "充值类型："
    ,DeviceGUID    varchar(255)                           comment "当前用户的设备id"
    ,GiftMoney     int                                    comment "获得的礼券数量"
    ,snapshot_time datetime                               comment "快照时间"
    ,sr_createtime datetime default current_timestamp     comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp     comment "starrocks数据更新时间"
)
primary key(Id)
comment "财务专用-领卡获取到的阅币，礼券记录日志"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
