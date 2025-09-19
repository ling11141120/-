----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_payorder
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.payorder
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2023-06-03
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_short_video_payorder;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_short_video_payorder(
     dt                  DATE            NOT NULL                                   COMMENT "createtime分区"
    ,id                  INT(11)         NOT NULL                                   COMMENT "自增id"
    ,type                INT(11)         NOT NULL DEFAULT '0'                       COMMENT "类型"
    ,userid              BIGINT(20)      NOT NULL                                   COMMENT "用户id"
    ,used                INT(11)         NOT NULL DEFAULT ''                        COMMENT "是否执行"
    ,orderid             VARCHAR(128)    NOT NULL                                   COMMENT "订单id"
    ,flag                INT(11)         NOT NULL DEFAULT '0'                       COMMENT "标识"
    ,createtime          DATETIME        NOT NULL DEFAULT '1970-01-01 00:00:00.000' COMMENT '创建时间'
    ,gettime             DATETIME        NOT NULL DEFAULT '1970-01-01 00:00:00.000' COMMENT '获取时间'
    ,itemcount           INT(11)         NOT NULL DEFAULT '0'                       COMMENT "金额数"
    ,systemtype          INT(11)         NOT NULL DEFAULT '0'                       COMMENT "系统类型"
    ,receivedate         DATETIME                                                   COMMENT "被接收时间"
    ,MT                  INT(11)         NOT NULL DEFAULT '0'                       COMMENT "终端"
    ,CouponId            VARCHAR(128)                                               COMMENT "礼券id"
    ,PackageId           VARCHAR(255)                                               COMMENT "存放充值页面来源"
    ,ShopItem            VARCHAR(128)                                               COMMENT "充值类型"
    ,ExtInfo             VARCHAR(128)                                               COMMENT "信息"
    ,VipExpireTime       VARCHAR(20)                                                COMMENT "充值订阅卡时,过期时间"
    ,RealMoney           INT(11)                                                    COMMENT "给的阅币数"
    ,GiveMoney           INT(11)                                                    COMMENT "暂时无用"
    ,Amount              INT(11)                                                    COMMENT "暂时无用"
    ,ProdId              INT(11)         NOT NULL DEFAULT '0'                       COMMENT "暂时无用"
    ,PayConfigId         INT(11)                                                    COMMENT "充值项的Id,可能不准确"
    ,CoreVer             INT(11)                                                    COMMENT "包体"
    ,UniqueGuid          VARCHAR(255)                                               COMMENT "用户设备id"
    ,TestFlag            INT(11)         NOT NULL DEFAULT '0'                       COMMENT "是否是测试号充值(0正式,1测试)"
    ,BuyToken            VARCHAR(255)                                               COMMENT "购买时候的google的token"
    ,BaseAmount          INT(11)         NOT NULL DEFAULT ''                        COMMENT "分成后的数量"
    ,Version             VARCHAR(255)                                               COMMENT "购买时,用户客户端的版本号"
    ,SubPayType          VARCHAR(50)                                                COMMENT "充值渠道"
    ,GiftMoney           INT(11)                                                    COMMENT "充值赠送的礼券数(可能不准确)"
    ,OrderInitTime       DATETIME                                                   COMMENT "用户订单创建时间"
    ,CooOrderExtInfo     VARCHAR(1000)                                              COMMENT "合作方订单扩展"
    ,CustomData          STRING                                                     COMMENT "自定义数据,透传,json格式"
    ,sr_createtime       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP         COMMENT "starrocks数据注入时间"
    ,sr_updatetime       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP         COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(dt, id)
COMMENT '海外短剧-用户充值表'
PARTITION BY RANGE(dt)
(START ("2023-07-05") END ("2023-11-24") EVERY (INTERVAL 1 DAY))
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "userid,orderid",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;