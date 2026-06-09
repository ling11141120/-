----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_sharpengine_pay_hk_sync_payorder
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.sharpengine_pay_hk_sync_payorder
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_sharpengine_pay_hk_sync_payorder;
create table ods.ods_tidb_finance_snapshot_sharpengine_pay_hk_sync_payorder (
     Id                 bigint           not null comment "主键id"
    ,OrderSerialId      string                    comment "订单流水号全局唯一,写入到业务库使用"
    ,OrderId            string                    comment "订单号,透传给支付合作方"
    ,CooOrderId         string                    comment "支付订单号,合作方回传的"
    ,PayChanelId        int                       comment "渠道号"
    ,Account            string                    comment "账号"
    ,UserId             bigint                    comment "用户Id"
    ,ServerId           int                       comment "服务器id,已废弃"
    ,UserIPAddress      string                    comment "客户端ip"
    ,CreateTime         datetime                  comment "创建时间"
    ,CooNotifyTime      datetime                  comment "收到的付款时间"
    ,FinishTime         datetime                  comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,Amount             int                       comment "金额,分为单位"
    ,GiveAmount         int                       comment "赠送金额,一般无用了"
    ,BankAmount         int                       comment "银行金额,一般等同于Amount"
    ,OrderStatus        int                       comment "订单状态1为成功"
    ,CooOrderStatus     int                       comment "合作方扣款状态1为成功"
    ,ShopItem           string                    comment "支付的商品id"
    ,ProductId          string                    comment "充值产品编号"
    ,PayType            string                    comment "PayType"
    ,BankId             string                    comment "BankId"
    ,Ext1               varchar(1048576)          comment "Ext1"
    ,Ext2               varchar(1048576)          comment "Ext2"
    ,Ext3               varchar(1048576)          comment "Ext3"
    ,Ext4               varchar(1048576)          comment "Ext4"
    ,Ext5               varchar(1048576)          comment "Ext5"
    ,OsType             int                       comment "相当于Mt"
    ,ShopItemId         int                       comment "商品Id,配置在后台"
    ,CouponId           string                    comment "优惠券Id"
    ,PackageId          string                    comment "客户端透传参数,不同场景用途不一样"
    ,Phone              string                    comment "Phone"
    ,HasNotifyTimes     int                       comment "HasNotifyTimes"
    ,PayConfigId        int                       comment "PayConfigId"
    ,Core               int                       comment "Core"
    ,BaseAmount         int                       comment "统计收入金额字段"
    ,UniqueGuid         string                    comment "UniqueGuid"
    ,TestFlag           int                       comment "测试标记1为测试"
    ,CooExtStatus       int                       comment "CooExtStatus"
    ,CooExtInfo         varchar(1048576)          comment "CooExtInfo"
    ,BillInfo           varchar(1048576)          comment "BillInfo"
    ,RowUpdateTimestamp datetime                  comment "RowUpdateTimestamp"
    ,SubPayType         string                    comment "子渠道类型"
    ,AutoRenewTimes     int                       comment "续订次数"
    ,SubscribeStatus    int                       comment "SubscribeStatus"
    ,AppVer             string                    comment "AppVer"
    ,Country            string                    comment "Country"
    ,CurrencyAmount     int                       comment "本地化货币值"
    ,snapshot_time      datetime                  comment "快照时间"
    ,sr_createtime      datetime                  comment "sr入库时间"
    ,sr_updatetime      datetime                  comment "sr更新时间"
)
primary key(Id)
comment "财务专用-海阅海剧充值表（带国家）"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
