----------------------------------------------------------------
-- 目标表： ads.ads_content_en_book_stat
-- 功能：内容域--英语书籍翻译统计
-- 负责人： xjc
-- 开发日期：2025-06-30
----------------------------------------------------------------



DROP TABLE IF EXISTS ads_content_en_book_stat;
CREATE TABLE IF NOT EXISTS ads_content_en_book_stat (
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
     partition p202401 values [("2024-01-01"), ("2024-02-01"))
    ,partition p202402 values [("2024-02-01"), ("2024-03-01"))
    ,partition p202403 values [("2024-03-01"), ("2024-04-01"))
    ,partition p202404 values [("2024-04-01"), ("2024-05-01"))
    ,partition p202405 values [("2024-05-01"), ("2024-06-01"))
    ,partition p202406 values [("2024-06-01"), ("2024-07-01"))
    ,partition p202407 values [("2024-07-01"), ("2024-08-01"))
    ,partition p202408 values [("2024-08-01"), ("2024-09-01"))
    ,partition p202409 values [("2024-09-01"), ("2024-10-01"))
    ,partition p202410 values [("2024-10-01"), ("2024-11-01"))
    ,partition p202411 values [("2024-11-01"), ("2024-12-01"))
    ,partition p202412 values [("2024-12-01"), ("2025-01-01"))
    ,partition p202501 values [("2025-01-01"), ("2025-02-01"))
    ,partition p202502 values [("2025-02-01"), ("2025-03-01"))
    ,partition p202503 values [("2025-03-01"), ("2025-04-01"))
    ,partition p202504 values [("2025-04-01"), ("2025-05-01"))
    ,partition p202505 values [("2025-05-01"), ("2025-06-01"))
    ,partition p202506 values [("2025-06-01"), ("2025-07-01"))
    ,partition p202507 values [("2025-07-01"), ("2025-08-01"))
    ,partition p202508 values [("2025-08-01"), ("2025-09-01"))
    ,partition p202509 values [("2025-09-01"), ("2025-10-01"))
    ,partition p202510 values [("2025-10-01"), ("2025-11-01"))
    ,partition p202511 values [("2025-11-01"), ("2025-12-01"))
    ,partition p202512 values [("2025-12-01"), ("2026-01-01"))
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