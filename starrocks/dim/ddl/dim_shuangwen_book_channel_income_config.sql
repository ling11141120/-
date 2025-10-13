DROP TABLE IF EXISTS dim.dim_shuangwen_book_channel_income_config;
CREATE TABLE dim.dim_shuangwen_book_channel_income_config (
     product_id      SMALLINT NOT NULL COMMENT "产品id"
    ,id              BIGINT   NOT NULL COMMENT "自增id"
    ,book_id         BIGINT   NOT NULL COMMENT "书籍id"
    ,site_id         SMALLINT NOT NULL COMMENT "语言id"
    ,language        SMALLINT          COMMENT "语言"
    ,del_flag        SMALLINT          COMMENT "DelFlag"
    ,start_time      DATETIME          COMMENT "生效时间"
    ,channel_book_id BIGINT   NOT NULL COMMENT "书籍渠道id"
    ,author_id       BIGINT   NOT NULL COMMENT "作者id"
    ,rate            DOUBLE   NOT NULL COMMENT "Rate"
    ,create_time     DATETIME          COMMENT "创建时间"
    ,etl_time        DATETIME NOT NULL COMMENT "更新版本"
)
PRIMARY KEY(product_id, id, book_id, site_id)
COMMENT "书籍渠道收入配置维度表"
DISTRIBUTED BY HASH(product_id) BUCKETS 4
PROPERTIES (
    "replication_num" = "3"
    ,"bloom_filter_columns" = "product_id, site_id, id, book_id"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
);