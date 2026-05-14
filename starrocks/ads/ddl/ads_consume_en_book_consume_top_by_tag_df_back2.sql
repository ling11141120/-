CREATE TABLE `ads_consume_en_book_consume_top_by_tag_df_back2` (
  `dt` date NOT NULL COMMENT "分区日期",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(900) NULL COMMENT "书名",
  `book_code` varchar(50) NULL COMMENT "代号",
  `tags` varchar(65533) NULL COMMENT "标签",
  `story_type` int(11) NULL COMMENT "类型  0长篇小说 1短篇小说",
  `show_date` date NOT NULL COMMENT "展示时间,dt+1",
  `site_id` int(11) NULL COMMENT "site_id",
  `channel` int(11) NULL COMMENT "频道 1女频 2男频",
  `revenue` decimal(20, 4) NULL COMMENT "阅币收入",
  `introduction` varchar(65533) NULL COMMENT "简介",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  `category_name` varchar(100) NULL COMMENT "分类名称",
  `source_book_id` bigint(20) NULL COMMENT "源书籍id",
  `source_book_name` varchar(900) NULL COMMENT "源书籍书名",
  `source_book_code` varchar(50) NULL COMMENT "源书籍代号"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "消费域-英语产品线3366小说阅币收入标签维度榜单"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`dt`, `book_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);