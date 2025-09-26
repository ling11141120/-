DROP TABLE IF EXISTS ads.ads_content_en_book_stat;
CREATE TABLE IF NOT EXISTS ads.ads_content_en_book_stat (
     dt                          date              not null    comment "日期"
    ,book_id                     bigint(20)        not null    comment "书籍ID"
    ,book_code                   varchar(65533)    null        comment "书籍代号、书籍编码"
    ,putaway_status              varchar(100)      null        comment "上下架状态"
    ,first_translate             date              null        comment "首次翻译时间"
    ,proofread_words             bigint(20)        null        comment "精修字数"
    ,en_first10_chapter_words    bigint(20)        null        comment "英语前10章字数"
    ,cn_first10_chapter_words    bigint(20)        null        comment "中文前10章字数"
    ,cn_publish_words            bigint(20)        null        comment "中文发布字数"
    ,latest7_days_words          bigint(20)        null        comment "近7天更新字数"
    ,etl_time                    datetime          not null    comment "数据清洗时间"
)
primary key(dt, book_id)
comment "内容域--英语书籍翻译统计"
partition by range(dt)
(
    partition p2025 values less then  ("2026-01-01")
)
distributed by hash(book_id) buckets 7
properties (
            "replication_num" = "3"
            ,"bloom_filter_columns" = "book_id"
            ,"dynamic_partition.enable" = "true"
            ,"dynamic_partition.time_unit" = "MONTH"
            ,"dynamic_partition.time_zone" = "Asia/Shanghai"
            ,"dynamic_partition.start" = "-120"
            ,"dynamic_partition.end" = "3"
            ,"dynamic_partition.prefix" = "p"
            ,"dynamic_partition.history_partition_num" = "0"
            ,"dynamic_partition.start_day_of_month" = "1"
            ,"in_memory" = "false"
            ,"enable_persistent_index" = "true"
            ,"replicated_storage" = "true"
            ,"storage_medium" = "SSD"
            ,"compression" = "ZSTD"
)
;