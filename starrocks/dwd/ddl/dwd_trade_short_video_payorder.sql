DROP TABLE IF EXISTS dwd.dwd_trade_short_video_payorder;
CREATE TABLE dwd.dwd_trade_short_video_payorder (
     dt                 DATE           NOT NULL                          COMMENT ""
    ,product_id         INT(11)        NOT NULL                          COMMENT "产品id 6833海外短剧"
    ,id                 INT(11)        NOT NULL                          COMMENT ""
    ,status             INT(11)        NOT NULL                          COMMENT "0 正常订单 1 退款订单"
    ,type               INT(11)        DEFAULT '0'                       COMMENT "类型"
    ,user_id            BIGINT(20)                                       COMMENT "用户id"
    ,used               INT(11)        DEFAULT '0'                       COMMENT ""
    ,order_id           VARCHAR(128)                                     COMMENT "订单id"
    ,flag               INT(11)        DEFAULT '0'                       COMMENT "标识（没用）"
    ,create_time        DATETIME       DEFAULT '1970-01-01 00:00:00.000' COMMENT "创建时间"
    ,get_time           DATETIME       DEFAULT '1970-01-01 00:00:00.000' COMMENT "获取时间"
    ,item_count         INT(11)        DEFAULT '0'                       COMMENT "金额数"
    ,system_type        INT(11)        DEFAULT '0'                       COMMENT "系统类型"
    ,receive_date       DATETIME                                         COMMENT "被接收时间"
    ,mt                 INT(11)        DEFAULT '0'                       COMMENT "平台"
    ,coupon_id          VARCHAR(128)                                     COMMENT "礼券id"
    ,package_id         VARCHAR(255)                                     COMMENT "存放充值页面来源"
    ,shop_item          VARCHAR(128)                                     COMMENT "充值类型"
    ,extinfo            VARCHAR(128)                                     COMMENT "ext信息"
    ,vip_expire_time    VARCHAR(20)                                      COMMENT "vip过期时间"
    ,real_money         INT(11)                                          COMMENT "给的阅币数"
    ,give_money         INT(11)                                          COMMENT "暂时无用"
    ,amount             INT(11)                                          COMMENT "暂时无用"
    ,prod_id            INT(11)        DEFAULT '0'                       COMMENT "暂时无用"
    ,pay_config_id      INT(11)                                          COMMENT "充值项的Id，可能不准确"
    ,corever            INT(11)                                          COMMENT "包体"
    ,unique_guid        VARCHAR(255)                                     COMMENT "用户设备id"
    ,test_flag          INT(11)        DEFAULT '0'                       COMMENT "用于判别是否为测试 1为测试, 0为正常"
    ,buy_token          VARCHAR(255)                                     COMMENT "购买时候的google的token"
    ,base_amount        INT(11)        DEFAULT '0'                       COMMENT "分成后的数量（除以100为分成后的金额）"
    ,version            VARCHAR(255)                                     COMMENT "购买时，用户客户端的版本号"
    ,subpay_type        VARCHAR(50)                                      COMMENT "充值渠道"
    ,gift_money         INT(11)                                          COMMENT "充值赠送的礼券数(可能不准确)"
    ,order_init_time    DATETIME                                         COMMENT "用户订单创建时间"
    ,cooorder_extinfo   VARCHAR(1000)                                    COMMENT "合作方订单扩展"
    ,custom_data        VARCHAR(65533)                                   COMMENT "自定义数据，透传，json格式"
    ,schedule_time      DATETIME                                         COMMENT "退款时间"
    ,etl_tm             DATETIME                                         COMMENT "清洗时间"
)
PRIMARY KEY (dt, product_id, id, status)
COMMENT "短剧--用户订单表"
DISTRIBUTED BY HASH (id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;