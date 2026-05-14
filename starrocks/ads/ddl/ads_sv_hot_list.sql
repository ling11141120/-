CREATE TABLE `ads_sv_hot_list` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `language_id` int(11) NOT NULL COMMENT "语言id",
  `core` int(11) NOT NULL COMMENT "core",
  `amt_weight` int(11) NULL COMMENT "观看付费集权重值",
  `consume_coin` int(11) NULL COMMENT "消费观看币数",
  `consume_bonus` int(11) NULL COMMENT "消费观看券数",
  `watch_cnt` int(11) NULL COMMENT "播放次数",
  `like_cnt` int(11) NULL COMMENT "点赞次数",
  `follow_cnt` int(11) NULL COMMENT "添加追剧",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `language_id`, `core`)
COMMENT "海剧排行榜热度指标计算口径"
DISTRIBUTED BY HASH(`dt`, `series_id`, `language_id`, `core`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);