CREATE TABLE `ads_sv_beidou_series_epis_stat_di_bak` (
  `dt` date NOT NULL COMMENT "日期",
  `core` int(11) NOT NULL COMMENT "Core",
  `language_code` int(11) NOT NULL COMMENT "语言编码",
  `series_id` bigint(20) NOT NULL COMMENT "短剧ID",
  `epis_id` bigint(20) NOT NULL COMMENT "单集ID",
  `epis_num` int(11) NULL COMMENT "分集序号",
  `language_name` varchar(100) NULL COMMENT "语言名称",
  `series_code` varchar(100) NULL COMMENT "短剧代号",
  `series_name` varchar(255) NULL COMMENT "短剧名称",
  `next_epis_user` bitmap NULL COMMENT "下一集续看用户数",
  `epis_complete_user` bitmap NULL COMMENT "本集完播用户数(进度>=95%)",
  `epis_total_watch_duration` bigint(20) NULL COMMENT "本集观看进度总时长(秒)",
  `epis_duration` int(11) NULL COMMENT "本集总时长(秒)",
  `exit_0_5s_user` bitmap NULL COMMENT "0~5s跳出用户",
  `exit_5_10s_user` bitmap NULL COMMENT "5~10s跳出用户",
  `exit_10_20s_user` bitmap NULL COMMENT "10~20s跳出用户",
  `exit_20_30s_user` bitmap NULL COMMENT "20~30s跳出用户",
  `exit_30_40s_user` bitmap NULL COMMENT "30~40s跳出用户",
  `exit_40_50s_user` bitmap NULL COMMENT "40~50s跳出用户",
  `exit_50_60s_user` bitmap NULL COMMENT "50~60s跳出用户",
  `exit_60s_plus_user` bitmap NULL COMMENT ">=60s跳出用户",
  `epis_watch_user` bitmap NULL COMMENT "本集观看总用户",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `core`, `language_code`, `series_id`, `epis_id`)
COMMENT "北斗短剧-每集观看数据统计表"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(`dt`, `core`, `language_code`, `series_id`, `epis_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);