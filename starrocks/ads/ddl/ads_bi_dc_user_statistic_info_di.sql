DROP TABLE IF EXISTS ads.ads_bi_dc_user_statistic_info_di;
CREATE TABLE ads.ads_bi_dc_user_statistic_info_di (
     dt                  DATE              NOT NULL COMMENT "统计日期"
    ,md5_key             STRING            NOT NULL COMMENT "主键md5key"
    ,product_id          INT(11)                    COMMENT "产品id"
    ,dc_code             BIGINT(20)                 COMMENT "所属机构"
    ,dc_account          BIGINT(20)                 COMMENT "机构投放账号"
    ,core                INT(11)                    COMMENT "corever"
    ,mt                  INT(11)                    COMMENT "终端"
    ,user_type           INT(11)                    COMMENT "用户类型:1 新用户 0老用户"
    ,new_user_count      INT(11)                    COMMENT "新增用户数"
    ,pay_user_count      INT(11)                    COMMENT "新增用户数"
    ,pay_order_count     INT(11)                    COMMENT "订单数"
    ,pay_order_amount    DECIMAL(18, 4)             COMMENT "订单金额"
    ,etl_tm              DATETIME          NOT NULL COMMENT "数据清洗时间"
)
PRIMARY KEY(dt, md5_key)
COMMENT "分销机构用户统计报表"
PARTITION BY RANGE(dt)
(PARTITION p202511 VALUES LESS THAN ("2025-12-01"))
distributed by hash(dt, md5_key) buckets 3
properties (
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