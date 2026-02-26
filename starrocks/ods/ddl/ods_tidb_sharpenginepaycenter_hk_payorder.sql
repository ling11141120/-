----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpenginepaycenter_hk_payorder
-- 来源实例： old_tidb_source
-- 来源表： sharpenginepaycenter_hk.payorder
-- 来源负责： 华总
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 创建日期： 2025-09-25
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpenginepaycenter_hk_payorder;
create table ods.ods_tidb_sharpenginepaycenter_hk_payorder (
     dt                 date         not null                  comment "createtime 分区"
    ,ProductId          varchar(512) not null default ""       comment "充值产品编号"
    ,Id                 bigint(20)   not null                  comment ""
    ,OrderSerialId      varchar(80)  not null                  comment "订单流水号全局唯一,写入到业务库使用"
    ,OrderId            varchar(128) not null                  comment "订单号,透传给支付合作方"
    ,CooOrderId         varchar(128)                           comment "支付订单号,合作方回传的"
    ,PayChanelId        int(11)      not null                  comment "渠道号"
    ,Account            varchar(128) not null                  comment "账号"
    ,UserId             bigint(20)   not null                  comment "用户Id"
    ,ServerId           int(11)      not null                  comment "服务器id,已废弃"
    ,UserIPAddress      varchar(50)  not null                  comment "客户端ip"
    ,CreateTime         datetime     not null                  comment "创建时间"
    ,CooNotifyTime      datetime                               comment "收到的付款时间"
    ,FinishTime         datetime                               comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,Amount             int(11)      not null                  comment "金额,分为单位"
    ,GiveAmount         int(11)                                comment "赠送金额,一般无用了"
    ,BankAmount         int(11)      not null                  comment "银行金额,一般等同于Amount"
    ,OrderStatus        int(11)      not null                  comment "订单状态1为成功"
    ,CooOrderStatus     int(11)      not null                  comment "合作方扣款状态1为成功"
    ,ShopItem           varchar(512)                           comment "支付的商品id"
    ,PayType            varchar(50)                            comment ""
    ,BankId             varchar(50)                            comment ""
    ,Ext1               string                                 comment ""
    ,Ext2               string                                 comment ""
    ,Ext3               string                                 comment ""
    ,Ext4               string                                 comment ""
    ,Ext5               string                                 comment ""
    ,OsType             int(11)                                comment "相当于Mt"
    ,ShopItemId         int(11)                                comment "商品Id,配置在后台"
    ,CouponId           varchar(128)                           comment "优惠券Id"
    ,PackageId          varchar(255)                           comment "客户端透传参数,不同场景用途不一样"
    ,Phone              varchar(50)                            comment ""
    ,HasNotifyTimes     int(11)      not null                  comment ""
    ,PayConfigId        int(11)                                comment ""
    ,Core               int(11)      not null                  comment ""
    ,BaseAmount         int(11)      not null                  comment "统计收入金额字段"
    ,UniqueGuid         varchar(128)                           comment ""
    ,TestFlag           int(11)      not null                  comment "测试标记1为测试"
    ,CooExtStatus       int(11)      not null                  comment ""
    ,CooExtInfo         string                                 comment ""
    ,BillInfo           string                                 comment ""
    ,RowUpdateTimestamp bigint(20)   not null                  comment ""
    ,SubPayType         varchar(128)                           comment "子渠道id"
    ,AutoRenewTimes     int(11)                                comment "续订次数"
    ,SubscribeStatus    int(11)                                comment "状态：默认0"
    ,AppVer             varchar(50)                            comment "版本号"
    ,sr_createtime      datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime      datetime                               comment "starrocks数据更新时间"
)
primary key(dt, ProductId, Id)
comment "订单支付信息"
partition by range(dt)
(partition p202509 values less than ("2025-10-01"))
distributed by hash(Id) buckets 6
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime, OrderId",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-1200",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;