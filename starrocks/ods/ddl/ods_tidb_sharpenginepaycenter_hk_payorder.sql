----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpenginepaycenter_hk_payorder
-- 来源实例： old_tidb_source
-- 来源表： sharpenginepaycenter_hk.payorder
-- 来源负责： 华总
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 创建日期： 2025-09-25
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpenginepaycenter_hk_payorder;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_sharpenginepaycenter_hk_payorder (
     dt                 DATE         NOT NULL                  COMMENT "createtime 分区"
    ,ProductId          VARCHAR(512) NOT NULL DEFAULT ""       COMMENT "充值产品编号"
    ,Id                 BIGINT(20)   NOT NULL                  COMMENT ""
    ,OrderSerialId      VARCHAR(80)  NOT NULL                  COMMENT "订单流水号全局唯一,写入到业务库使用"
    ,OrderId            VARCHAR(128) NOT NULL                  COMMENT "订单号,透传给支付合作方"
    ,CooOrderId         VARCHAR(128)                           COMMENT "支付订单号,合作方回传的"
    ,PayChanelId        INT(11)      NOT NULL                  COMMENT "渠道号"
    ,Account            VARCHAR(128) NOT NULL                  COMMENT "账号"
    ,UserId             BIGINT(20)   NOT NULL                  COMMENT "用户Id"
    ,ServerId           INT(11)      NOT NULL                  COMMENT "服务器id,已废弃"
    ,UserIPAddress      VARCHAR(50)  NOT NULL                  COMMENT "客户端ip"
    ,CreateTime         DATETIME     NOT NULL                  COMMENT "创建时间"
    ,CooNotifyTime      DATETIME                               COMMENT "收到的付款时间"
    ,FinishTime         DATETIME                               COMMENT "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,Amount             INT(11)      NOT NULL                  COMMENT "金额,分为单位"
    ,GiveAmount         INT(11)                                COMMENT "赠送金额,一般无用了"
    ,BankAmount         INT(11)      NOT NULL                  COMMENT "银行金额,一般等同于Amount"
    ,OrderStatus        INT(11)      NOT NULL                  COMMENT "订单状态1为成功"
    ,CooOrderStatus     INT(11)      NOT NULL                  COMMENT "合作方扣款状态1为成功"
    ,ShopItem           VARCHAR(512)                           COMMENT "支付的商品id"
    ,PayType            VARCHAR(50)                            COMMENT ""
    ,BankId             VARCHAR(50)                            COMMENT ""
    ,Ext1               STRING                                 COMMENT ""
    ,Ext2               STRING                                 COMMENT ""
    ,Ext3               STRING                                 COMMENT ""
    ,Ext4               STRING                                 COMMENT ""
    ,Ext5               STRING                                 COMMENT ""
    ,OsType             INT(11)                                COMMENT "相当于Mt"
    ,ShopItemId         INT(11)                                COMMENT "商品Id,配置在后台"
    ,CouponId           VARCHAR(128)                           COMMENT "优惠券Id"
    ,PackageId          VARCHAR(255)                           COMMENT "客户端透传参数,不同场景用途不一样"
    ,Phone              VARCHAR(50)                            COMMENT ""
    ,HasNotifyTimes     INT(11)      NOT NULL                  COMMENT ""
    ,PayConfigId        INT(11)                                COMMENT ""
    ,Core               INT(11)      NOT NULL                  COMMENT ""
    ,BaseAmount         INT(11)      NOT NULL                  COMMENT "统计收入金额字段"
    ,UniqueGuid         VARCHAR(128)                           COMMENT ""
    ,TestFlag           INT(11)      NOT NULL                  COMMENT "测试标记1为测试"
    ,CooExtStatus       INT(11)      NOT NULL                  COMMENT ""
    ,CooExtInfo         STRING                                 COMMENT ""
    ,BillInfo           STRING                                 COMMENT ""
    ,RowUpdateTimestamp BIGINT(20)   NOT NULL                  COMMENT ""
    ,SubPayType         VARCHAR(128)                           COMMENT "子渠道id"
    ,AutoRenewTimes     INT(11)                                COMMENT "续订次数"
    ,SubscribeStatus    INT(11)                                COMMENT "状态：默认0"
    ,AppVer             VARCHAR(50)                            COMMENT "版本号"
    ,sr_createtime      DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime      DATETIME                               COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(dt, ProductId, Id)
COMMENT "订单支付信息"
PARTITION BY RANGE(dt)
(PARTITION p202509 VALUES LESS THAN ("2025-10-01"))
DISTRIBUTED BY HASH(Id) BUCKETS 6
PROPERTIES (
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