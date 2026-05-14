CREATE TABLE `ads_syncbi_book_ranking_list` (
  `dt` date NULL COMMENT "统计数据分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(255) NULL COMMENT "书名",
  `mea_val` int(11) NULL COMMENT "统计值",
  `rn` int(11) NULL COMMENT "排行序号",
  `newc_id` int(11) NULL COMMENT "分类id",
  `time_type` int(11) NULL COMMENT "统计周期 0：默认 1：季度 2：月 3：周",
  `type` int(11) NULL COMMENT "畅销榜 200,编辑推荐 201,本周流行，202,各分类最佳小说，203,最新热门小说204",
  `language_id` int(11) NULL COMMENT "语言id",
  `etl_time` datetime NULL COMMENT "etl清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "各分类书籍按不同周期的阅读消耗排行，主要用于官网的书籍展示数据"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);