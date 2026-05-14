CREATE TABLE `ads_sv_beidou_series_play_trend_hi_bak` (
  `dt` date NOT NULL COMMENT "日期",
  `hour_time` datetime NOT NULL COMMENT "小时时间",
  `core` int(11) NOT NULL COMMENT "Core",
  `language_code` int(11) NOT NULL COMMENT "语言编码",
  `series_id` bigint(20) NOT NULL COMMENT "短剧ID",
  `language_name` varchar(100) NULL COMMENT "语言名称",
  `series_code` varchar(100) NULL COMMENT "短剧代号",
  `series_name` varchar(255) NULL COMMENT "短剧名称",
  `series_level` int(11) NULL COMMENT "短剧等级(1.S 2.A 3.B 4.C)",
  `work_type` int(11) NULL COMMENT "作品类型(1.男频 2.女频 3.双番)",
  `local_type` int(11) NULL COMMENT "类型 (1.本土剧 2.译制剧 4.动态漫)",
  `local_sub_type` int(11) NULL COMMENT "短剧子类型(0.默认 1.本土剧-AI短剧)",
  `audio_type` int(11) NULL COMMENT "音轨类型(1.原声剧 2.配音剧)",
  `dubbed_type` int(11) NULL COMMENT "配音类型(1.人工配音 2.AI配音)",
  `day_time` date NULL COMMENT "天",
  `month_time` date NULL COMMENT "月(yyyy-MM-01)",
  `play_count` bigint(20) NULL COMMENT "播放量",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `hour_time`, `core`, `language_code`, `series_id`)
COMMENT "北斗短剧-播放量趋势表(小时粒度)"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(`dt`, `core`, `language_code`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);