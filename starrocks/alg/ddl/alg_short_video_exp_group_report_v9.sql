CREATE TABLE `alg_short_video_exp_group_report_v9` (
  `dt` date NOT NULL COMMENT "日期",
  `scene_id` varchar(512) NOT NULL COMMENT "scene_id",
  `uv` varchar(512) NULL COMMENT "推荐人数",
  `play_uv` varchar(512) NULL COMMENT "观看人数",
  `cost_uv` bigint(20) NULL COMMENT "消费人数",
  `play_count` bigint(20) NULL COMMENT "总观看集数",
  `unlock_count` bigint(20) NULL COMMENT "总解锁集数",
  `cost_amount` bigint(20) NULL COMMENT "总消费书币",
  `cost_per_user` decimal(16, 6) NULL COMMENT "人均消费/曝光"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `scene_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);