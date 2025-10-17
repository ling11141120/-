DROP TABLE IF EXISTS ads.ads_report_target_book_progress_monitoring;
CREATE TABLE ads.ads_report_target_book_progress_monitoring (
     dt               DATE           NOT NULL                  COMMENT "日期"
    ,to_book_id       BIGINT(20)     NOT NULL                  COMMENT "书籍id"
    ,site_id          SMALLINT(6)    NOT NULL                  COMMENT "语言id"
    ,resource_type    SMALLINT(6)    NOT NULL                  COMMENT "生产位-1：新书上架 2：内部推荐 3：外部测推 4-小测  5-高优"
    ,book_name        STRING                                   COMMENT "书籍名称"
    ,book_code        STRING                                   COMMENT "书籍代码"
    ,book_plevel      STRING                                   COMMENT "书籍打P级标签"
    ,book_status      SMALLINT(6)                              COMMENT "书籍状态"
    ,account_name     STRING                                   COMMENT "项管名称"
    ,proofread_length BIGINT(20)                               COMMENT "精修（二校）字数"
    ,publish_length   BIGINT(20)                               COMMENT "发布字数"
    ,length_target    BIGINT(20)                               COMMENT "目标字数"
    ,yield_rate       DECIMAL(18, 4)                           COMMENT "达成率"
    ,progress_judge   SMALLINT(6)                              COMMENT "进度判断，1：已达成2：即将达成3：未达成"
    ,daily_publish    BIGINT(20)                               COMMENT "日更字数"
    ,fin_day_anly     DECIMAL(16, 4)                           COMMENT "预计完成天数"
    ,pri_cd           INT                                      COMMENT "优先级编号"
    ,pri_name         VARCHAR(5)                               COMMENT "优先级名称"
    ,etl_time         DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
    ,INDEX index_site_id (site_id)               USING BITMAP  COMMENT '语言id索引'
    ,INDEX index_resource_type (resource_type)   USING BITMAP  COMMENT '生产位索引'
    ,INDEX index_progress_judge (progress_judge) USING BITMAP  COMMENT '进度判断索引'
) 
PRIMARY KEY(dt, to_book_id, site_id, resource_type)
COMMENT "周期型内容域目标书籍进度事实表"
DISTRIBUTED BY HASH(to_book_id, site_id, resource_type) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, to_book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;