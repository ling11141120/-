CREATE TABLE `alg_novel_book_reco_list_top20` (
  `book_id` varchar(200) NOT NULL COMMENT "书籍id",
  `reco_list` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`book_id`)
DISTRIBUTED BY HASH(`book_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);