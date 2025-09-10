DROP TABLE IF EXISTS ads.ads_tag_sr_pub_spnd_anal;
CREATE TABLE ads.ads_tag_sr_pub_spnd_anal (
     dt                     DATETIME      NOT NULL COMMENT '日期'
    ,book_id                BIGINT        NOT NULL COMMENT '书籍id'
    ,lang_cd                INT                    COMMENT '语言编码'
    ,lang_name              VARCHAR(50)            COMMENT '语言名称'
    ,rcoin_giftvchr_amt_30d DECIMAL(10,0)          COMMENT '近30日阅币礼券消耗数额'
    ,rec_time               DATETIME               COMMENT '推荐时间'
    ,etl_time               DATETIME               COMMENT 'etl时间'
)
PRIMARY KEY (dt,book_id)
COMMENT 'TAG海阅上架与消耗分析'
PARTITION BY DATE_TRUNC('day',dt)
DISTRIBUTED BY HASH (dt, book_id)
PROPERTIES(
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;