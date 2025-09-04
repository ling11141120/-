CREATE TABLE ads.ads_bi_read_adv_income_report_advdata (
     dt                  DATE           NOT NULL COMMENT "日期，来自DATE字段"
    ,product_id          INT(11)        NOT NULL COMMENT "产品"
    ,mt                  INT(11)                 COMMENT "平台"
    ,corever             INT(11)                 COMMENT "包体"
    ,ads_nmae            VARCHAR(65533)          COMMENT "广告来源"
    ,ad_show_type        VARCHAR(255)            COMMENT "广告类型"
    ,position_id         VARCHAR(255)            COMMENT "广告位置id"
    ,tps                 INT(11)                 COMMENT "1:admob 2:topon 3:max 4:starmobi"
    ,ad_amt              DECIMAL(18, 4)          COMMENT "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,ad_request_cnt      BIGINT(20)              COMMENT "请求的数量。该值是一个整数。"
    ,matched_request_cnt BIGINT(20)              COMMENT "响应请求而返回广告的次数。该值是一个整数。"
    ,impression_cnt      BIGINT(20)              COMMENT "向用户展示的广告总数。该值是一个整数。"
    ,click_cnt           BIGINT(20)              COMMENT "用户点击广告的次数。该值是一个整数。"
    ,etl_tm              DATETIME       NOT NULL COMMENT "数据清洗时间"
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT 'index_product_id'
)
DUPLICATE KEY(dt, product_id)
COMMENT "广告位置收入数据"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, product_id) BUCKETS 1 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
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