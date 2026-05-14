CREATE TABLE `ads_content_object_chapter_check` (
  `md5_key` varchar(65533) NOT NULL COMMENT "唯一主键",
  `dt` date NOT NULL COMMENT "统计日期（完成时间）",
  `site_id` bigint(20) NOT NULL COMMENT "语言ID",
  `author_id` bigint(20) NOT NULL COMMENT "被抽查人ID（译员ID）",
  `check_person` varchar(765) NULL COMMENT "抽查人员",
  `pen_name` varchar(765) NULL COMMENT "被抽查人",
  `book_name` varchar(765) NULL COMMENT "书名",
  `chapter_name` varchar(765) NULL COMMENT "章节名",
  `etl_time` datetime NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`md5_key`)
COMMENT "抽查列表"
DISTRIBUTED BY HASH(`md5_key`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);