CREATE TABLE `alg_short_video_tag_index` (
  `tag` varchar(255) NOT NULL COMMENT "tag名",
  `tag_index` int(11) NOT NULL COMMENT "tag emb位置"
) ENGINE=OLAP 
PRIMARY KEY(`tag`)
DISTRIBUTED BY HASH(`tag`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);