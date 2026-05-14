CREATE TABLE `ads_edm_book_consume_l30d` (
  `dt` date NULL COMMENT "统计日期",
  `language_id` int(11) NULL COMMENT "书籍语言 通过site_id来获取",
  `channel` int(11) NULL COMMENT "频道",
  `new_cid` int(11) NULL COMMENT "分类",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `amount` int(11) NULL COMMENT "消耗量（近30天阅币加礼券消耗）",
  `etl_time` datetime NULL COMMENT "数据更新时间",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `language_id`)
COMMENT "edm算法书籍消耗排行数据"
DISTRIBUTED BY HASH(`dt`, `language_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, language_id, new_cid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);