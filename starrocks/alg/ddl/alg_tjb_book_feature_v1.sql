CREATE TABLE `alg_tjb_book_feature_v1` (
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NULL COMMENT "书籍ID",
  `read_uv` bigint(20) NOT NULL COMMENT "阅读人数",
  `csum_uv` bigint(20) NOT NULL COMMENT "消费人数",
  `start_read_chpts` bigint(20) NOT NULL COMMENT "开始阅读章节数",
  `end_read_chpts` bigint(20) NOT NULL COMMENT "结束阅读章节数",
  `csum_total` bigint(20) NOT NULL COMMENT "总花费金额",
  `upload_days` bigint(20) NOT NULL COMMENT "上传天数"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);