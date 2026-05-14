CREATE TABLE `ads_sv_stat_mi` (
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `dt_month` varchar(20) NOT NULL COMMENT "日期月份",
  `user_count` int(11) NOT NULL COMMENT "活跃用户数",
  `arpu` decimal(20, 2) NULL COMMENT "ARPU（置信度，均值类）",
  `pay_rate` decimal(20, 2) NULL COMMENT "付费率",
  `ad_arpu` decimal(20, 2) NULL COMMENT "广告ARPU",
  `total_ad_arpu` decimal(20, 2) NULL COMMENT "总广告ARPU",
  `ad_unlock_rate` decimal(20, 2) NULL COMMENT "广告解锁率",
  `ad_unlock_episodes_rate` decimal(20, 2) NULL COMMENT "人均广告解锁剧集",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `dt_month`)
COMMENT "海剧月活用户相关指标-月统计"
DISTRIBUTED BY HASH(`product_id`, `dt_month`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);