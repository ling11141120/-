CREATE TABLE dws_advertisement_admob_income_ed (
     dt               date           NOT NULL COMMENT "日期，来自DATE字段"
    ,product_id       int(11)        NOT NULL COMMENT "产品"
    ,account          varchar(65533)     NULL COMMENT "账号"
    ,ads_nmae         varchar(65533)     NULL COMMENT "广告来源"
    ,ad_unit          varchar(65533)     NULL COMMENT "广告单元id"
    ,mt               int(11)            NULL COMMENT "终端"
    ,corever          int(11)            NULL COMMENT "corever"
    ,time_types       smallint(6)    NOT NULL COMMENT "时区类型 1北京 2洛杉矶"
    ,ad_requests      bigint(20)         NULL COMMENT "请求的数量。该值是一个整数。"
    ,matched_requests bigint(20)         NULL COMMENT "响应请求而返回广告的次数。该值是一个整数。"
    ,impressions      bigint(20)         NULL COMMENT "向用户展示的广告总数。该值是一个整数。"
    ,clicks           bigint(20)         NULL COMMENT "用户点击广告的次数。该值是一个整数。"
    ,ad_amount        decimal(18, 4)     NULL COMMENT "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,etl_time         datetime       NOT NULL COMMENT "数据清洗时间"
    ,appver           varchar(50)        NULL COMMENT ""
) ENGINE=OLAP
DUPLICATE KEY(dt, product_id)
COMMENT "沙盘-广告错误报表数据"
PARTITION BY RANGE(dt)
(
    PARTITION p202201 VALUES [("2022-01-01"), ("2022-02-01")],
    PARTITION p202202 VALUES [("2022-02-01"), ("2022-03-01")],
    PARTITION p202203 VALUES [("2022-03-01"), ("2022-04-01")],
    PARTITION p202204 VALUES [("2022-04-01"), ("2022-05-01")],
    PARTITION p202205 VALUES [("2022-05-01"), ("2022-06-01")],
    PARTITION p202206 VALUES [("2022-06-01"), ("2022-07-01")],
    PARTITION p202207 VALUES [("2022-07-01"), ("2022-08-01")],
    PARTITION p202208 VALUES [("2022-08-01"), ("2022-09-01")],
    PARTITION p202209 VALUES [("2022-09-01"), ("2022-10-01")],
    PARTITION p202210 VALUES [("2022-10-01"), ("2022-11-01")],
    PARTITION p202211 VALUES [("2022-11-01"), ("2022-12-01")],
    PARTITION p202212 VALUES [("2022-12-01"), ("2023-01-01")],
    PARTITION p202301 VALUES [("2023-01-01"), ("2023-02-01")],
    PARTITION p202302 VALUES [("2023-02-01"), ("2023-03-01")],
    PARTITION p202303 VALUES [("2023-03-01"), ("2023-04-01")],
    PARTITION p202304 VALUES [("2023-04-01"), ("2023-05-01")],
    PARTITION p202305 VALUES [("2023-05-01"), ("2023-06-01")],
    PARTITION p202306 VALUES [("2023-06-01"), ("2023-07-01")],
    PARTITION p202307 VALUES [("2023-07-01"), ("2023-08-01")],
    PARTITION p202308 VALUES [("2023-08-01"), ("2023-09-01")],
    PARTITION p202309 VALUES [("2023-09-01"), ("2023-10-01")],
    PARTITION p202310 VALUES [("2023-10-01"), ("2023-11-01")],
    PARTITION p202311 VALUES [("2023-11-01"), ("2023-12-01")],
    PARTITION p202312 VALUES [("2023-12-01"), ("2024-01-01")],
    PARTITION p202401 VALUES [("2024-01-01"), ("2024-02-01")],
    PARTITION p202402 VALUES [("2024-02-01"), ("2024-03-01")],
    PARTITION p202403 VALUES [("2024-03-01"), ("2024-04-01")],
    PARTITION p202404 VALUES [("2024-04-01"), ("2024-05-01")],
    PARTITION p202405 VALUES [("2024-05-01"), ("2024-06-01")],
    PARTITION p202406 VALUES [("2024-06-01"), ("2024-07-01")],
    PARTITION p202407 VALUES [("2024-07-01"), ("2024-08-01")],
    PARTITION p202408 VALUES [("2024-08-01"), ("2024-09-01")],
    PARTITION p202409 VALUES [("2024-09-01"), ("2024-10-01")],
    PARTITION p202410 VALUES [("2024-10-01"), ("2024-11-01")],
    PARTITION p202411 VALUES [("2024-11-01"), ("2024-12-01")],
    PARTITION p202412 VALUES [("2024-12-01"), ("2025-01-01")],
    PARTITION p202501 VALUES [("2025-01-01"), ("2025-02-01")],
    PARTITION p202502 VALUES [("2025-02-01"), ("2025-03-01")],
    PARTITION p202503 VALUES [("2025-03-01"), ("2025-04-01")],
    PARTITION p202504 VALUES [("2025-04-01"), ("2025-05-01")],
    PARTITION p202505 VALUES [("2025-05-01"), ("2025-06-01")],
    PARTITION p202506 VALUES [("2025-06-01"), ("2025-07-01")],
    PARTITION p202507 VALUES [("2025-07-01"), ("2025-08-01")],
    PARTITION p202508 VALUES [("2025-08-01"), ("2025-09-01")],
    PARTITION p202509 VALUES [("2025-09-01"), ("2025-10-01")],
    PARTITION p202510 VALUES [("2025-10-01"), ("2025-11-01")]
)
DISTRIBUTED BY HASH(dt, product_id) BUCKETS 1 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "ads_nmae",
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
);