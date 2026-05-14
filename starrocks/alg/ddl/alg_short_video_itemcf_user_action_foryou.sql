CREATE TABLE `alg_short_video_itemcf_user_action_foryou` (
  `user_id` varchar(500) NOT NULL COMMENT "user_id",
  `series_id` varchar(500) NOT NULL COMMENT "剧id",
  `language_id` varchar(500) NULL COMMENT "语言id",
  `category` varchar(500) NULL COMMENT "分类",
  `type` varchar(500) NULL COMMENT "类型 1外文剧 2 中文剧",
  `weight` decimal(12, 2) NULL COMMENT "权重",
  `create_time` datetime NULL COMMENT "创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`, `series_id`)
COMMENT "用户剧集weight"
DISTRIBUTED BY HASH(`user_id`, `series_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);