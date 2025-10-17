DROP TABLE IF EXISTS dwd.dwd_content_book_capacity_monitoring_snap;
CREATE TABLE dwd.dwd_content_book_capacity_monitoring_snap (
     dt               DATE     NOT NULL                  COMMENT "日期"
    ,to_book_id       BIGINT   NOT NULL                  COMMENT "书籍id"
    ,site_id          SMALLINT NOT NULL                  COMMENT "语言id"
    ,resource_type    SMALLINT NOT NULL                  COMMENT "生产位"
    ,book_name        STRING                             COMMENT "书籍名称"
    ,book_code        STRING                             COMMENT "书籍代码"
    ,book_status      SMALLINT                           COMMENT "书籍状态"
    ,account_name     STRING                             COMMENT "项管名称"
    ,proofread_length BIGINT                             COMMENT "精修（二校）字数"
    ,publish_length   BIGINT                             COMMENT "发布字数"
    ,length_target    BIGINT                             COMMENT "目标字数"
    ,daily_publish    BIGINT                             COMMENT "日更字数"
    ,pri_cd           INT                                COMMENT '优先级编号'
    ,pri_name         VARCHAR(5)                         COMMENT '优先级名称'
    ,etl_time         DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
    ,INDEX index_site_id (site_id) USING BITMAP          COMMENT '语言id索引'
)
PRIMARY KEY(dt, to_book_id, site_id, resource_type)
COMMENT "周期型内容域目标书籍进度事实表"
PARTITION BY RANGE(dt)
(PARTITION p2025 VALUES LESS THAN ("2026-01-01"))
DISTRIBUTED BY HASH(to_book_id, site_id, resource_type) BUCKETS 3
PROPERTIES (
    "replication_num" = "3"
    ,"bloom_filter_columns" = "dt, to_book_id"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;