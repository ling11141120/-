CREATE TABLE `ads_sr_bi_commercialize_target_di` (
  `dt` date NOT NULL COMMENT "日期",
  `week` varchar(128) NOT NULL COMMENT "年周",
  `quarter` varchar(128) NOT NULL COMMENT "年季度",
  `dau` int(11) NOT NULL COMMENT "广告总活跃",
  `deu` int(11) NOT NULL COMMENT "日活",
  `motive_deu` int(11) NOT NULL COMMENT "激励视频活跃",
  `ad_amt_zs` decimal(38, 6) NOT NULL COMMENT "真实广告收益",
  `click_cnt_zs` int(11) NOT NULL COMMENT "激励视频广告点击次数",
  `show_cnt_zs` int(11) NOT NULL COMMENT "激励视频广告展示次数",
  `ad_amt_yg` decimal(38, 6) NOT NULL COMMENT "激励视频预估广告收益",
  `show_cnt_yg` int(11) NOT NULL COMMENT "激励视频广告展示次数",
  `show_unt_yg` int(11) NOT NULL COMMENT "激励视频广告展示人数",
  `watch_cnt_sc` int(11) NOT NULL COMMENT "激励视频广告完播次数",
  `click_cnt_sc` int(11) NOT NULL COMMENT "激励视频资源位点击次数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`)
COMMENT "海阅商业化指标表"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);