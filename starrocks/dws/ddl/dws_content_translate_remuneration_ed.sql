DROP TABLE IF EXISTS dws.dws_content_translate_remuneration_ed;
CREATE TABLE dws.dws_content_translate_remuneration_ed (
     dt             DATE           NOT NULL           COMMENT "年分区字段：日期"
    ,product_id     SMALLINT       NOT NULL           COMMENT "产品id"
    ,book_id        BIGINT         NOT NULL           COMMENT "书籍id"
    ,cost_types     SMALLINT       NOT NULL           COMMENT "费用类型:1稿酬；2书籍销售分成"
    ,cost_amt       DECIMAL(32, 6)                    COMMENT "费用"
    ,etl_time       DATETIME       NOT NULL           COMMENT "数据清洗时间"
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT '产品id索引'
)
PRIMARY KEY(dt, product_id, book_id, cost_types)
COMMENT "内容域翻译书籍销售情况明细表"
DISTRIBUTED BY HASH(product_id, book_id, cost_types) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, cost_types, book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;