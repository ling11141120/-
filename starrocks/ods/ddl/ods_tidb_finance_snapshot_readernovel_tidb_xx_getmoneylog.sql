----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_readernovel_tidb_xx_getmoneylog
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.readernovel_tidb_xx_getmoneylog
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_readernovel_tidb_xx_getmoneylog;
create table ods.ods_tidb_finance_snapshot_readernovel_tidb_xx_getmoneylog (
     dt            date           not null                  comment "GetTime 分区"
    ,productid     int            not null                  comment "产品id"
    ,Id            int            not null                  comment "id"
    ,UserId        bigint         not null                  comment "用户id"
    ,VipLv         int            not null                  comment "vip等级"
    ,PayChl        varchar(150)   not null                  comment "payorder.type"
    ,Charge        int            not null                  comment "充值金额"
    ,RealGet       int            not null                  comment "实际获取到的阅币数量"
    ,Give          int            not null                  comment "实际获取到的赠送币数量"
    ,CurMoney      int            not null                  comment "用户当前阅币数量"
    ,GetTime       datetime       not null                  comment "获得时间"
    ,reforderid    varchar(765)                             comment "payorder.orderid"
    ,Seq           bigint                                   comment "自增的序号"
    ,cps           int                                      comment "cps"
    ,chl2          varchar(765)                             comment "chl2"
    ,ChargeType    int                                      comment "充值类型,0:正常 100：测试 5：余额冻结（先把用户余额消费冻结了   之后用户解冻在getmoneylog 又会发放一次 ）"
    ,DeviceGUID    varchar(765)                             comment "当前用户的设备id"
    ,GiftMoney     int                                      comment "获得的礼券数量"
    ,TestFlag      int                                      comment "测试数据 1 是"
    ,ActualAmount  decimal(18,2)                            comment "订单真实充值金额，精准价格"
    ,snapshot_time datetime                                 comment "快照时间"
    ,sr_createtime datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, productid, Id)
comment "财务专用-领卡获取到的阅币，礼券记录日志"
partition by date_trunc("month", dt)
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "GetTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
