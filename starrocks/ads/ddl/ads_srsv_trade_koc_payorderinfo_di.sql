DROP TABLE IF EXISTS ads.ads_srsv_trade_koc_payorderinfo_di;
CREATE TABLE ads.ads_srsv_trade_koc_payorderinfo_di (
     ref_order_id        VARCHAR(128)    NOT NULL                  COMMENT "订单号"
    ,status              INT(11)         NOT NULL                  COMMENT "订单状态 0 正常订单 1 退款订单"
    ,dt                  DATE            NOT NULL                  COMMENT "日期"
    ,code                VARCHAR(65533)  NOT NULL                  COMMENT "口令词"
    ,story_id            BIGINT(20)      NOT NULL                  COMMENT "故事 ID"
    ,story_name          VARCHAR(65533)                            COMMENT "故事名称"
    ,amount              DECIMAL(16, 4)                            COMMENT "金额数"
    ,base_amount         DECIMAL(16, 4)                            COMMENT "分成后金额数"
    ,project_type        INT(11)                                   COMMENT "项目类型 1=网文|2=短剧"
    ,institution_user_id VARCHAR(65533)                            COMMENT "机构用户 ID"
    ,star_user_id        VARCHAR(65533)                            COMMENT "达人用户 ID"
    ,create_time         DATETIME                                  COMMENT "创建时间"
    ,etl_time            DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
    ,core                INT(11)                                   COMMENT "core"
    ,current_language    INT(11)                                   COMMENT "投放语言"
    ,user_id             BIGINT(20)                                COMMENT "用户id"
    ,mt                  INT(11)                                   COMMENT "mt"
    ,sub_pay_type        VARCHAR(100)                              COMMENT "支付方式"
    ,shop_item           INT(11)                                   COMMENT "权益类型"
    ,activation_time     DATETIME                                  COMMENT "激活时间"
    ,country             VARCHAR(100)                              COMMENT "国家"
)
PRIMARY KEY(ref_order_id, status)
COMMENT "KOC订单信息"
DISTRIBUTED BY HASH(status, ref_order_id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

alter table ads.ads_srsv_trade_koc_payorderinfo_di add column is_anom_ord int(11) default "0" COMMENT "是否异常订单";