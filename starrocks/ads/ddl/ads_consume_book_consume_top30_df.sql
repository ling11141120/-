CREATE TABLE `ads_consume_book_consume_top30_df` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `story_type_id` int(11) NOT NULL COMMENT "书籍类型id",
  `language_name` varchar(50) NULL COMMENT "语言名称",
  `story_type_name` varchar(50) NULL COMMENT "书籍类型名称",
  `consume_14d` bigint(20) NULL COMMENT "近14日阅币+礼券+赠送币+VIP消费消耗",
  `desc_rank` int(11) NULL COMMENT "倒序排名",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `book_id`, `language_id`, `story_type_id`)
COMMENT "消费域-近14天长篇/短篇书籍合计消费金额（礼券/VIP/SVIP/阅币等）TOP30"
PARTITION BY date_trunc('year', dt)
DISTRIBUTED BY HASH(`dt`, `product_id`, `book_id`, `language_id`, `story_type_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);