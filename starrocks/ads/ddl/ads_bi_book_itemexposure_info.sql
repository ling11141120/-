DROP TABLE IF EXISTS ads.ads_bi_book_itemexposure_info_tmp;
CREATE TABLE ads.ads_bi_book_itemexposure_info_tmp (
     dt              DATE         NOT NULL COMMENT "createtime 分区"
    ,product_id      INT          NOT NULL COMMENT "产品id"
    ,book_lang_id    INT          NOT NULL COMMENT "书籍语言id"
    ,corever         INT          NOT NULL COMMENT "core"
    ,book_id         BIGINT       NOT NULL COMMENT "书籍id"
    ,is_channel_book INT          NOT NULL COMMENT "是否引流书籍"
    ,mt              VARCHAR(255) NOT NULL COMMENT "移动终端"
    ,expo_unt        BITMAP                COMMENT "曝光用户id"
    ,cli_unt         BITMAP                COMMENT "点击用户id"
    ,etl_tm          DATETIME     NOT NULL COMMENT "清洗时间"
) 
PRIMARY KEY (dt, product_id, book_lang_id, corever, book_id, is_channel_book, mt)
COMMENT "海阅小说曝光点击事件数据_临时"
PARTITION BY DATE_TRUNC("month", dt)
DISTRIBUTED BY HASH (dt, product_id, book_lang_id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "partition_live_number" = "1830",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;