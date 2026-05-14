CREATE TABLE `ads_bi_ads_creation_replay_report_di` (
  `dt` date NOT NULL COMMENT "日期",
  `product_type` varchar(255) NOT NULL COMMENT "项目类型 1-海阅 2-海剧",
  `current_language` varchar(255) NOT NULL COMMENT "投放语言",
  `source_chl` varchar(1024) NOT NULL COMMENT "媒体",
  `priority_type` varchar(255) NOT NULL COMMENT "类型",
  `ad_priority` int(11) NOT NULL COMMENT "优先级",
  `publish_time` varchar(255) NOT NULL COMMENT "发布时间段",
  `ad_set_count` int(11) NULL COMMENT "发布广告组数",
  `cost_amount` decimal(18, 2) NULL COMMENT "花费",
  `d0_reach_rate` decimal(18, 8) NULL COMMENT "d0达标率",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_type`, `current_language`, `source_chl`, `priority_type`, `ad_priority`, `publish_time`)
COMMENT "创编管理系统复盘"
DISTRIBUTED BY HASH(`dt`, `product_type`, `source_chl`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);