CREATE TABLE `ads_bi_user_book_consume_info` (
    `dt`                    date         NOT NULL   COMMENT "事件分区",
    `product_id`            int(11)      NULL       COMMENT "产品id",
    `book_id`               bigint(20)   NULL       COMMENT "书籍id",
    `book_name`             varchar(512) NULL       COMMENT "书名",
    `book_nature`           int(11)      NULL       COMMENT "书籍来源",
    `new_cname`             varchar(512) NULL       COMMENT "书籍分类",
    `build_time`            datetime     NULL       COMMENT "上架时间",
    `normal_chapter_num_f`  int(11)      NULL       COMMENT "发布章节数",
    `user_id`               bigint(20)   NULL       COMMENT "用户id",
    `corever`               int(11)      NULL       COMMENT "corever",
    `types`                 int(11)      NULL       COMMENT "1：阅币，2:礼券 3：赠送币 4：vip",
    `amount`                int(11)      NULL       COMMENT "消耗数量",
    `con_chapter_nums`      int(11)      NULL       COMMENT "消费章节数",
    `is_read`               int(11)      NULL       COMMENT "1：有阅读 0 ：非阅读",
    `is_channel_book`       int(11)      NULL       COMMENT "1：引流书籍 0：非引流书籍",
    `etl_time`              datetime     NOT NULL   COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "bi:用户消耗书籍数据"
PARTITION BY RANGE(`dt`)
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES ("replication_num" = "3",
            "bloom_filter_columns" = "book_id",
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