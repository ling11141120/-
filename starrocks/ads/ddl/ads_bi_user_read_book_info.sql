DROP TABLE IF EXISTS ads.ads_bi_user_read_book_info;
CREATE TABLE ads.ads_bi_user_read_book_info (
     dt              date          NOT NULL              COMMENT "createtime 分区"
    ,product_id      int(11)       NOT NULL              COMMENT "产品id"
    ,user_id         bigint(20)    NOT NULL              COMMENT "用户id"
    ,book_id         bigint(20)    NOT NULL              COMMENT "书籍id"
    ,site_id         int(11)                             COMMENT "书籍语言id"
    ,corever         int(11)                             COMMENT "corever"
    ,is_channel_book int(11)                             COMMENT "是否引流书籍"
    ,mt              varchar(255)                        COMMENT "用户终端 0未知 1iphone 4安卓 9书城",
    ,etl_time        datetime                            COMMENT "etl时间"
    ,INDEX index_product_id (product_id) USING BITMAP    COMMENT '产品id索引'
 )
PRIMARY KEY (dt, product_id, user_id, book_id)
COMMENT "运营业务bi报表需求-阅读域用户粒度书籍阅读信息表"
PARTITION BY date_trunc('month',dt)
DISTRIBUTED BY HASH (dt, product_id, user_id, book_id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id, book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;