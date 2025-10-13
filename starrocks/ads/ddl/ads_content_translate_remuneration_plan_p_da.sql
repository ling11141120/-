DROP TABLE IF EXISTS ads.ads_content_translate_remuneration_plan_p_da;
CREATE TABLE ads.ads_content_translate_remuneration_plan_p_da (
     dt                          DATE     NOT NULL COMMENT "日期"
    ,target_book_id              VARCHAR(65533) NOT NULL COMMENT "目标书ID"
    ,first_translate_day         DATE              COMMENT "首次翻译日期"
    ,translate_days              BIGINT            COMMENT "翻译天数"
    ,sug_straw_words             VARCHAR(65533)    COMMENT "建议囤稿字数"
    ,chapter_plus_by_day         INT               COMMENT "每日常规章节"
    ,chapter_plus_by_week        VARCHAR(65533)    COMMENT "周期加更数 每周常规章节"
    ,book_language_id            INT               COMMENT "语种"
    ,second_checkout_person      VARCHAR(65533)    COMMENT "二校人员"
    ,book_code                   VARCHAR(65533)    COMMENT "书籍代号"
    ,book_cn_name                VARCHAR(65533)    COMMENT "书籍中文名称"
    ,avg_chapter_words           BIGINT            COMMENT "章均字节"
    ,published_words             BIGINT            COMMENT "已发布字数"
    ,proofread_words             BIGINT            COMMENT "精修字数"
    ,income_rank_last_30day      VARCHAR(65533)    COMMENT "本月收入排名"
    ,total_income_rank           VARCHAR(65533)    COMMENT "累计收入排名"
    ,interpreter_number          BIGINT            COMMENT "已质检数量"
    ,foreign_number              BIGINT            COMMENT "已一校数量"
    ,proofread_number            BIGINT            COMMENT "已清修数量"
    ,published_number            BIGINT            COMMENT "已发布数量"
    ,has_straw_chapters          BIGINT            COMMENT "囤稿量章节 已精修-已发布"
    ,source_published_words      BIGINT            COMMENT "源语言发布字数"
    ,source_published_chapters   BIGINT            COMMENT "源语言发布章节数"
    ,income_last_7d              DECIMAL(18, 4)    COMMENT "近7天收入"
    ,income_last_30d             DECIMAL(18, 4)    COMMENT "近30天收入"
    ,income_last_7d_30d          DECIMAL(18, 4)    COMMENT "7天折30天收入"
    ,chapters_l20_publish_l7d    DECIMAL(18, 4)    COMMENT "最近7天以上发布的末尾20章--发布日期后的7天内的阅币消耗"
    ,chapters_l20_last_7d        DECIMAL(18, 4)    COMMENT "最近7天以上发布的末尾20章-最近7天内的阅币消耗"
    ,read_last_30d               BIGINT            COMMENT "30天阅读人数"
    ,consume_last_30d            BIGINT            COMMENT "30天消费人数"
    ,target_book_name            VARCHAR(65533)    COMMENT "目标书籍名称"
    ,book_status                 INT               COMMENT "书籍状态"
    ,foreigning_count            BIGINT            COMMENT "待一校量（章节数）"
    ,proofreading_count          BIGINT            COMMENT "待二校量（章节数）"
    ,collecting_by_foreign       VARCHAR(50)       COMMENT "领稿上限"
    ,no_proofread_length         BIGINT            COMMENT "待二校字数"
    ,cost_amt_curmon             DECIMAL(18, 4)    COMMENT "本月成本"
    ,amount_curmon               DECIMAL(18, 4)    COMMENT "本月收入"
    ,remark                      VARCHAR(65533)    COMMENT "卡章提示"
    ,etl_time                    DATETIME NOT NULL COMMENT "数据清洗时间"
)
PRIMARY KEY(dt, target_book_id)
COMMENT "内容域--翻译书籍产能排产计划表"
PARTITION BY RANGE(dt)
(PARTITION p202510 VALUES LESS THAN ("2025-11-01"))
DISTRIBUTED BY HASH(target_book_id) BUCKETS 3 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "book_language_id, target_book_id, book_code",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-360",
    "dynamic_partition.end" = "1",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;