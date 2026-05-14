CREATE TABLE `dwm_video_short_video_watch_wz5_ed_mid` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `watch_user_90` bitmap NULL COMMENT "前90天观看人员id的bitmap",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `series_id`)
COMMENT "海外短剧剧粒度观看中间表-西五区"
DISTRIBUTED BY HASH(`dt`, `product_id`, `series_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
