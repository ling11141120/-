CREATE TABLE `alg_short_video_itemcf_reco_core_list_top100_v1` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "类型 1外文剧 2 中文剧",
  `core` int(11) NOT NULL COMMENT "corever",
  `reco_list` varchar(65533) NULL COMMENT "推荐列表"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `language_id`, `type`, `core`)
COMMENT "分core_u2i推荐结果"
DISTRIBUTED BY HASH(`user_id`, `language_id`, `type`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);