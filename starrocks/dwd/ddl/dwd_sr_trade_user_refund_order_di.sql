----------------------------------------------------------------
-- 目标表： dwd.dwd_sr_trade_user_refund_order_di
-- 来源实例： 
-- 来源表： 
-- 来源负责：
-- 采集工具： 
-- 开发人：
-- 开发日期： 2025-09-11
----------------------------------------------------------------

DROP TABLE IF EXISTS dwd.dwd_sr_trade_user_refund_order_di;
CREATE TABLE dwd.dwd_sr_trade_user_refund_order_di (
      dt              DATE           NOT NULL                  COMMENT "日期"
     ,ProductId       INT(11)        NOT NULL                  COMMENT "产品id"
     ,AutoId          BIGINT(20)     NOT NULL                  COMMENT "自增id"
     ,UserId          BIGINT(20)                              COMMENT "用户id"
     ,PayChannelidId  INT(11)                                 COMMENT "支付渠道id"
     ,Used            INT(11)                                 COMMENT "订单是否处理过 0:未处理 1:处理"
     ,OrderId         VARCHAR(128)                            COMMENT "订单id"
     ,status          INT(11)                                 COMMENT "订单状态 0 正常订单 1 退款订单"
     ,Flag            INT(11)                                 COMMENT "标识 0：阅读；1：游戏"
     ,CreateTime      DATETIME                                COMMENT "发起时间"
     ,GetTime         DATETIME                                COMMENT "入账时间"
     ,ItemCount       INT(11)                                 COMMENT "金额数"
     ,SystemType      INT(11)                                 COMMENT "系统类型"
     ,ReceiveDate     DATETIME                                COMMENT "被接收时间"
     ,MT              INT(11)                                 COMMENT "平台"
     ,CouponId        VARCHAR(128)                            COMMENT "优惠券id"
     ,PackageId       VARCHAR(255)                            COMMENT "存放充值页面来源"
     ,ShopItem        VARCHAR(128)                            COMMENT "充值类型（0，普通充值，800，801，802月卡，810vip，830新签到卡)"
     ,ExtInfo         VARCHAR(128)                            COMMENT "扩展字段"
     ,VipExpireTime   VARCHAR(20)                             COMMENT "充值订阅卡时，谷歌和苹果返回的过期时间"
     ,RealMoney       INT(11)                                 COMMENT "给的阅币数"
     ,AwardMoney      INT(11)                                 COMMENT "赠送币数量"
     ,PayConfigId     INT(11)                                 COMMENT "新支付配置id"
     ,CoreVer         INT(11)                                 COMMENT "core的版本号"
     ,DeviceGUID      VARCHAR(255)                            COMMENT "当前设备id"
     ,TestFlag        INT(11)                                 COMMENT "是否是测试号充值（0正式，1测试）"
     ,BaseAmount      INT(11)                                 COMMENT "分成后的数量（除以100为分成后的金额）"
     ,Version         VARCHAR(255)                            COMMENT "购买时，用户客户端的版本号"
     ,SubPayType      VARCHAR(50)                             COMMENT "子支付渠道"
     ,GiftMoney       INT(11)                                 COMMENT "充值赠送的礼券数(不准确，部分活动赠送未记录)"
     ,OrderInitTime   DATETIME                                COMMENT "用户订单创建时间"
     ,CooOrderExtInfo VARCHAR(1000)                           COMMENT "合作方订单扩展"
     ,product_data    VARCHAR(1048576)                        COMMENT "商品数据 发货成功后回写 json格式"
     ,refund_time     DATETIME                                COMMENT "退款时间"
     ,etl_time        DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
     ,INDEX index_productid (productid) USING BITMAP COMMENT "index_productid"
)
PRIMARY KEY (dt, ProductId, AutoId)
COMMENT "交易域用户充值事实表"
DISTRIBUTED BY HASH (ProductId, AutoId) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;