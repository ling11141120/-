CREATE TABLE `dws_sv_ads_position_play_data_di_bak` (
  `dt` date NOT NULL COMMENT "分区日期",
  `ad_position_id` int(11) NOT NULL COMMENT "广告位置id",
  `exposure_cnt` int(11) NULL COMMENT "曝光次数",
  `exposure_unt` int(11) NULL COMMENT "曝光人数",
  `click_cnt` int(11) NULL COMMENT "点击次数",
  `click_unt` int(11) NULL COMMENT "点击人数",
  `show_cnt` int(11) NULL COMMENT "播放次数",
  `show_unt` int(11) NULL COMMENT "播放人数",
  `watch_cnt` int(11) NULL COMMENT "完播次数",
  `watch_unt` int(11) NULL COMMENT "完播人数",
  `etl_tm` datetime NOT NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `ad_position_id`)
COMMENT "海剧-广告位置曝光点击播放数据"
DISTRIBUTED BY HASH(`dt`, `ad_position_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
