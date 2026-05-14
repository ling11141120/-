CREATE TABLE `dim_sr_book_category` (
  `id` int(11) NOT NULL COMMENT "序号",
  `language_id` int(11) NULL COMMENT "语言id",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `book_name` varchar(2000) NULL COMMENT "书籍名称",
  `introduce` varchar(65533) NULL COMMENT "书籍简介",
  `theme` varchar(2000) NULL COMMENT "内容主题类",
  `emotion` varchar(2000) NULL COMMENT "感情基调类",
  `character_setting` varchar(2000) NULL COMMENT "人设类",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海阅-书籍分类"
DISTRIBUTED BY HASH(`id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);