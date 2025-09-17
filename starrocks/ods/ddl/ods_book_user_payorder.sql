----------------------------------------------------------------
-- 目标表： ods.ods_book_user_payorder
-- 来源实例： hk-koc-mysql-slave
-- 来源表： 
--        readernovel_tidb_fr.payorder
--        readernovel_tidb_pt.payorder
--        readernovel_tidb_ft.payorder
--        readernovel_tidb_en.payorder
--        readernovel_tidb_ru.payorder
--        readernovel_tidb_sp.payorder
--        readernovel_tidb_id.payorder
--        readernovel_tidb_th.payorder
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-09-11
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_book_user_payorder;
CREATE TABLE IF NOT EXISTS ods.ods_book_user_payorder (
     dt              DATE             NOT NULL                  COMMENT "createtime分区"
    ,productid       INT(11)          NOT NULL                  COMMENT "产品id"
    ,id              BIGINT(20)       NOT NULL                  COMMENT "自增id"
    ,userid          BIGINT(20)                                 COMMENT "用户id"
    ,type            INT(11)                                    COMMENT ""
    ,used            INT(11)                                    COMMENT "是否执行"
    ,orderid         VARCHAR(128)                               COMMENT "订单id"
    ,flag            INT(11)                                    COMMENT "用于判别是否为测试 1为测试, 0为正常"
    ,createtime      DATETIME                                   COMMENT "发起时间"
    ,gettime         DATETIME                                   COMMENT "入账时间"
    ,itemcount       INT(11)                                    COMMENT "金额数"
    ,systemtype      INT(11)                                    COMMENT "系统类型"
    ,receivedate     DATETIME                                   COMMENT "被接收时间"
    ,MT              INT(11)                                    COMMENT "平台"
    ,CouponId        VARCHAR(128)                               COMMENT "优惠券id"
    ,PackageId       VARCHAR(255)                               COMMENT "存放充值页面来源"
    ,ShopItem        VARCHAR(128)                               COMMENT "充值类型（0，普通充值，800，801，802月卡，810vip，830新签到卡)"
    ,ExtInfo         VARCHAR(128)                               COMMENT ""
    ,VipExpireTime   VARCHAR(20)                                COMMENT "充值订阅卡时，谷歌和苹果返回的过期时间"
    ,RealMoney       INT(11)                                    COMMENT "给的阅币数"
    ,GiveMoney       INT(11)                                    COMMENT "暂时无用"
    ,Amount          INT(11)                                    COMMENT ""
    ,ProdId          INT(11)                                    COMMENT "产品id"
    ,PayConfigId     INT(11)                                    COMMENT "充值项的Id，可能不准确"
    ,CoreVer         INT(11)                                    COMMENT "core的版本号"
    ,UniqueGuid      VARCHAR(255)                               COMMENT "唯一设备id"
    ,TestFlag        INT(11)                                    COMMENT "是否是测试号充值（0正式，1测试）"
    ,BuyToken        VARCHAR(255)                               COMMENT "客户端充值时的token，现在没什么用"
    ,BaseAmount      INT(11)                                    COMMENT "分成后的数量（除以100为分成后的金额）"
    ,Version         VARCHAR(255)                               COMMENT "购买时，用户客户端的版本号"
    ,SubPayType      VARCHAR(50)                                COMMENT "充值渠道"
    ,GiftMoney       INT(11)                                    COMMENT "充值赠送的礼券数(不准确，部分活动赠送未记录)"
    ,OrderInitTime   DATETIME                                   COMMENT "用户订单创建时间"
    ,CooOrderExtInfo VARCHAR(1000)                              COMMENT "合作方订单扩展"
    ,ProductData     VARCHAR(1048576)                           COMMENT "商品数据 发货成功后回写 json格式"
    ,ActualAmount    DECIMAL(18, 2)                             COMMENT "总支付金额，小数类型，chh"
    ,SensorsData     VARCHAR(65533)                             COMMENT "埋点信息"
    ,sr_createtime   DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime   DATETIME                                   COMMENT "starrocks数据更新时间"
    ,INDEX index_productid (productid) USING BITMAP             COMMENT 'index_productid'
)
PRIMARY KEY (dt, productid, id)
COMMENT "用户充值记录表"
PARTITION BY RANGE (dt)
(
    PARTITION p202507 VALUES less than ("2025-07-01"),
    PARTITION p202508 VALUES less than ("2025-08-01"),
    PARTITION p202509 VALUES less than ("2025-09-01")
)
DISTRIBUTED BY HASH (productid, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "createtime, userid",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;