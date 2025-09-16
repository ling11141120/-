DROP TABLE IF EXISTS ads.ads_srsv_ads_koc_attribution_result_data;
CREATE TABLE ads.ads_srsv_ads_koc_attribution_result_data (
     dt                   DATETIME       NOT NULL COMMENT "统计日期"
    ,product_id           INT(11)        NOT NULL COMMENT "产品id"
    ,adid                 VARCHAR(755)   NOT NULL COMMENT "koc的广告ID"
    ,project_tp           INT(11)        NOT NULL COMMENT "1：海阅 2：海剧"
    ,book_id              BIGINT(20)              COMMENT "书籍id"
    ,mt                   INT(11)        NOT NULL COMMENT "终端"
    ,core                 INT(11)        NOT NULL COMMENT "Core"
    ,source_chl           VARCHAR(65533)          COMMENT "媒体,写死koc"
    ,chl                  VARCHAR(755)   NOT NULL COMMENT "渠道"
    ,current_language     INT(11)                 COMMENT "投放语言"
    ,koc_code             VARCHAR(65533)          COMMENT "口令,来源于koc_text"
    ,dev_unt              INT(11)                 COMMENT "激活用户数(新用户数+活跃用户数),不去重"
    ,new_dev_unt          INT(11)                 COMMENT "激活新用户数,不去重"
    ,active_dev_unt       INT(11)                 COMMENT "激活活跃用户数,不去重"
    ,order_num            INT(11)                 COMMENT "订单数"
    ,koc_amt              DECIMAL(16, 4)          COMMENT "充值金额"
    ,new_koc_amt          DECIMAL(16, 4)          COMMENT "激活新用户充值金额"
    ,active_koc_amt       DECIMAL(16, 4)          COMMENT "激活活跃用户充值金额"
    ,koc_amt_after        DECIMAL(16, 4)          COMMENT "扣除渠道费之后的充值金额"
    ,new_koc_amt_after    DECIMAL(16, 4)          COMMENT "激活新用户扣除渠道费之后的充值金额"
    ,active_koc_amt_after DECIMAL(16, 4)          COMMENT "激活活跃用户扣除渠道费之后的充值金额"
    ,koc_amt_14d          DECIMAL(12, 2)          COMMENT "充值金额-14天归因"
    ,koc_amt_after_14d    DECIMAL(12, 2)          COMMENT "扣除渠道费之后的充值金额-14天归因"
    ,ad_amt               DECIMAL(12, 2)          COMMENT "广告收入"
    ,etl_tm               DATETIME                COMMENT "清洗时间"
)
PRIMARY KEY (dt, product_id, adid)
COMMENT "海阅海剧koc用户回收数据结果表"
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (dt, product_id, adid) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
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
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;

alter table ads.ads_srsv_ads_koc_attribution_result_data add column anom_ded_amt DECIMAL(16, 4) COMMENT "异常扣除金额" after ad_amt;
alter table sharpengine_bi.SyncBi_ads_koc_srsv_bi_attribution_result_data_new add column anom_ded_amt DECIMAL(16, 4) COMMENT "异常扣除金额" after ad_amt;
-- 订单数算正常订单的订单数