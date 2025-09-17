DROP TABLE IF EXISTS ads.ads_bi_user_book_consume_info;
CREATE TABLE ads.ads_bi_user_book_consume_info (
     dt                    date         NOT NULL   COMMENT "事件分区"
    ,product_id            int(11)                 COMMENT "产品id"
    ,book_id               bigint(20)              COMMENT "书籍id"
    ,book_name             varchar(512)            COMMENT "书名"
    ,book_nature           int(11)                 COMMENT "书籍来源"
    ,new_cname             varchar(512)            COMMENT "书籍分类"
    ,build_time            datetime                COMMENT "上架时间"
    ,normal_chapter_num_f  int(11)                 COMMENT "发布章节数"
    ,user_id               bigint(20)              COMMENT "用户id"
    ,corever               int(11)                 COMMENT "corever"
    ,types                 int(11)                 COMMENT "1：阅币，2:礼券 3：赠送币 4：vip"
    ,amount                int(11)                 COMMENT "消耗数量"
    ,con_chapter_nums      int(11)                 COMMENT "消费章节数"
    ,is_read               int(11)                 COMMENT "1：有阅读 0 ：非阅读"
    ,is_channel_book       int(11)                 COMMENT "1：引流书籍 0：非引流书籍"
    ,mt                    varchar(255)            COMMENT "用户终端 0未知 1iphone 4安卓 9书城"
    ,etl_time              datetime     NOT NULL   COMMENT "数据清洗时间"
)
ON DUPLICATE KEY UPDATE (dt, product_id)
COMMENT "bi:用户消耗书籍数据"
PARTITION BY date_trunc('month',dt)
DISTRIBUTED BY HASH(dt, product_id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;