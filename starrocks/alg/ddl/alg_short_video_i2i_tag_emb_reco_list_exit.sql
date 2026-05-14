CREATE TABLE `alg_short_video_i2i_tag_emb_reco_list_exit` (
  `user_id` varchar(500) NOT NULL COMMENT "用户id",
  `language_id` varchar(500) NOT NULL COMMENT "语言id",
  `type` varchar(500) NOT NULL COMMENT "类型 1外文剧 2 中文剧",
  `reco_list` varchar(20000) NOT NULL COMMENT "推荐列表"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `language_id`, `type`)
COMMENT "返回推u2i推荐结果"
DISTRIBUTED BY HASH(`user_id`, `language_id`, `type`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);