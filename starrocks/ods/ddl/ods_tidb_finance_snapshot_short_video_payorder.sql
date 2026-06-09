----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_short_video_payorder
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.short_video_payorder
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_short_video_payorder;
create table ods.ods_tidb_finance_snapshot_short_video_payorder (
     dt                  date            not null                                   comment "createtime分区"
    ,id                  int             not null                                   comment "自增id"
    ,type                int             not null                                   comment "类型"
    ,userid              bigint          not null                                   comment "用户id"
    ,used                int             not null                                   comment "是否执行"
    ,orderid             varchar(128)    not null                                   comment "订单id"
    ,flag                int             not null                                   comment "标识"
    ,createtime          datetime        not null                                   comment "创建时间"
    ,gettime             datetime        not null                                   comment "获取时间"
    ,itemcount           int             not null                                   comment "金额数"
    ,systemtype          int             not null                                   comment "系统类型"
    ,receivedate         datetime                                                   comment "被接收时间"
    ,MT                  int             not null                                   comment "终端"
    ,CouponId            varchar(128)                                               comment "礼券id"
    ,PackageId           varchar(255)                                               comment "存放充值页面来源"
    ,ShopItem            varchar(128)                                               comment "充值类型"
    ,ExtInfo             varchar(128)                                               comment "信息"
    ,VipExpireTime       varchar                                                    comment "充值订阅卡时,过期时间"
    ,RealMoney           int                                                        comment "给的阅币数"
    ,GiveMoney           int                                                        comment "暂时无用"
    ,Amount              int                                                        comment "暂时无用"
    ,ProdId              int             not null                                   comment "暂时无用"
    ,PayConfigId         int                                                        comment "充值项的Id,可能不准确"
    ,CoreVer             int                                                        comment "包体"
    ,UniqueGuid          varchar(255)                                               comment "用户设备id"
    ,TestFlag            int             not null                                   comment "是否是测试号充值(0正式,1测试)"
    ,BuyToken            varchar(255)                                               comment "购买时候的google的token"
    ,BaseAmount          int             not null                                   comment "分成后的数量"
    ,Version             varchar(255)                                               comment "购买时,用户客户端的版本号"
    ,SubPayType          varchar(50)                                                comment "充值渠道"
    ,GiftMoney           int                                                        comment "充值赠送的礼券数(可能不准确)"
    ,OrderInitTime       datetime                                                   comment "用户订单创建时间"
    ,CooOrderExtInfo     varchar(1000)                                              comment "合作方订单扩展"
    ,CustomData          string                                                     comment "自定义数据,透传,json格式"
    ,ActualAmount        decimal(18,2)                                              comment "总支付金额，小数类型"
    ,OrderStatus         int             not null                                   comment "订单状态，0：正常，1：发起退款，2：退款成功，3：退款失败"
    ,StatusUpdateTime    datetime                                                   comment "订单状态修改时间"
    ,snapshot_time       datetime                                                   comment "快照时间"
    ,sr_createtime       datetime        not null default current_timestamp         comment "starrocks数据注入时间"
    ,sr_updatetime       datetime        not null default current_timestamp         comment "starrocks数据更新时间"
)
primary key(dt, id)
comment "财务专用-海外短剧-用户充值表"
partition by date_trunc("month", dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "userid,orderid",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;
