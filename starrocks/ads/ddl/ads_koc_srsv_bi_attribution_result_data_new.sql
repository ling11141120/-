DROP TABLE IF EXISTS ads.ads_koc_srsv_bi_attribution_result_data_new;
CREATE TABLE ads.ads_koc_srsv_bi_attribution_result_data_new (
     dt                    DATE         NOT NULL COMMENT '统计日期'
    ,product_id            INT          NOT NULL COMMENT '产品id'
    ,koc_code              VARCHAR(255) NOT NULL COMMENT '口令,来源于koc_text'
    ,user_type             INT          NOT NULL COMMENT '用户类型，1 新用户，2 老用户，3 自然活跃老用户数'
    ,reg_country           VARCHAR(50)  NOT NULL COMMENT '注册国家'
    ,project_tp            INT                   COMMENT '1：海阅 2：海剧'
    ,book_id               BIGINT(20)            COMMENT '书籍id'
    ,mt                    INT                   COMMENT '终端'
    ,core                  INT          NOT NULL COMMENT 'Core'
    ,source_chl            VARCHAR(255)          COMMENT '媒体,写死koc'
    ,chl                   VARCHAR(755)          COMMENT '渠道'
    ,current_language      INT                   COMMENT '投放语言'
    ,institution_id        VARCHAR(255)          COMMENT '机构id'
    ,star_id               INT                   COMMENT '达人id'
    ,dev_unt               INT                   COMMENT '激活用户数(新用户数+活跃用户数),不去重'
    ,order_num             INT                   COMMENT '订单数'
    ,koc_amt               DECIMAL(16,4)         COMMENT '充值金额'
    ,koc_amt_after         DECIMAL(16,4)         COMMENT '扣除渠道费之后的充值金额'
    ,etl_tm                DATETIME              COMMENT '清洗时间'
) 
PRIMARY KEY (dt, product_id, koc_code, user_type, reg_country)
COMMENT 'koc项目，koc归因数据报表(新)'
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (dt, product_id, koc_code) BUCKETS 3
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