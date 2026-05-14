CREATE TABLE `ads_tag_voiced_category_book_stat_da` (
  `dt` datetime NOT NULL COMMENT "统计时间",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `language_id` int(11) NOT NULL COMMENT "书籍语言",
  `new_cid` int(11) NULL COMMENT "书籍分类id",
  `is_full` tinyint(4) NULL COMMENT "完结状态",
  `is_putaway` int(11) NULL COMMENT "上架状态",
  `Status` int(11) NULL COMMENT "0：下架 1：上架",
  `build_time` datetime NULL COMMENT "书籍上架时间",
  `update_time` datetime NULL COMMENT "书籍更新时间",
  `consume_1d` int(11) NULL COMMENT "近1日阅币加礼券消耗",
  `consume_7d` int(11) NULL COMMENT "近7日阅币加礼券消耗",
  `consume_30d` int(11) NULL COMMENT "近30日阅币加礼券消耗",
  `consume_td` int(11) NULL COMMENT "历史阅币加礼券消耗",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`, `language_id`)
COMMENT "书籍维度阅读消耗人数"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);