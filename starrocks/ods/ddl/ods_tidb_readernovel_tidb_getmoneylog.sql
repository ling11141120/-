----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_getmoneylog
-- 来源实例： old_tidb_source
-- 来源表： readernovel_tidb_fr.getmoneylog
--        readernovel_tidb_pt.getmoneylog
--        readernovel_tidb_ft.getmoneylog
--        readernovel_tidb_en.getmoneylog
--        readernovel_tidb_ru.getmoneylog
--        readernovel_tidb_sp.getmoneylog
--        readernovel_tidb_jp.getmoneylog
--        readernovel_tidb_id.getmoneylog
--        readernovel_tidb_th.getmoneylog
--        readernovel_tidb_and2.getmoneylog
--        readernovel_tidb_cd2.getmoneylog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-05-14
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_getmoneylog;
create table if not exists ods.ods_tidb_readernovel_tidb_getmoneylog (
     dt            date         not null                  comment "GetTime 分区"
    ,product_id    int          not null                  comment "产品id"
    ,Id            int          not null                  comment "id"
    ,UserId        bigint       not null                  comment "用户id"
    ,VipLv         int          not null                  comment "vip等级"
    ,PayChl        varchar(150) not null                  comment "payorder.type"
    ,Charge        int          not null                  comment "充值金额"
    ,RealGet       int          not null                  comment "实际获取到的阅币数量"
    ,Give          int          not null                  comment "实际获取到的赠送币数量"
    ,CurMoney      int          not null                  comment "用户当前阅币数量"
    ,GetTime       datetime     not null                  comment "获得时间"
    ,reforderid    varchar(765)                           comment "payorder.orderid"
    ,Seq           bigint                                 comment "自增的序号"
    ,cps           int                                    comment ""
    ,chl2          varchar(765)                           comment ""
    ,ChargeType    int                                    comment "充值类型,0:正常 100：测试 5：余额冻结（先把用户余额消费冻结了   之后用户解冻在getmoneylog 又会发放一次 ）"
    ,DeviceGUID    varchar(765)                           comment "当前用户的设备id"
    ,GiftMoney     int                                    comment "获得的礼券数量"
    ,sr_createtime datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime     default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, product_id, Id)
comment "领卡获取到的阅币，礼券记录日志"
partition by range(dt)
distributed by hash(Id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "GetTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "YEAR",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-120",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

