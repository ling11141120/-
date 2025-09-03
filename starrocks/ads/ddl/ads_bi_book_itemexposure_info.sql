DROP TABLE IF EXISTS ads.ads_bi_book_itemexposure_info;
CREATE TABLE ads.ads_bi_book_itemexposure_info (
     dt              DATE    NOT NULL  COMMENT "createtime 分区"
    ,product_id      INT     NOT NULL  COMMENT "产品id"
    ,book_lang_id    INT     NOT NULL  COMMENT "书籍语言id"
    ,corever         INT     NOT NULL  COMMENT "core"
    ,book_id         BIGINT  NOT NULL  COMMENT "书籍id"
    ,is_channel_book INT     NOT NULL  COMMENT "是否引流书籍"
    ,expo_unt        BITMAP            COMMENT "曝光用户id"
    ,cli_unt         BITMAP            COMMENT "点击用户id"
    ,etl_tm          DATETIME NOT NULL COMMENT "清洗时间"
) 
PRIMARY KEY (dt, product_id, book_lang_id, corever, book_id, is_channel_book)
COMMENT "海阅小说曝光点击事件数据"
PARTITION BY RANGE (dt) (
    partition p202508 values less than ("2025-09-01"),
    partition p202509 values less than ("2025-10-01"),
    partition p202510 values less than ("2025-11-01"),
    partition p202511 values less than ("2025-12-01")
)
DISTRIBUTED BY HASH (dt, product_id, book_lang_id) BUCKETS 1
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