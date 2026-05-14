CREATE TABLE `dws_video_user_watch_series_td_a` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `fst_watch_tm` datetime NULL COMMENT "首次观看时间",
  `lst_watch_tm` datetime NULL COMMENT "末次观看时间",
  `watch_series_td` bitmap NULL COMMENT "累计观看剧的bitmap",
  `watch_tv_td` bitmap NULL COMMENT "累计观看剧集bitmap(剧id+集序号)",
  `watch_days_td` bigint(20) NULL COMMENT "累计观看天数",
  `watch_cnt_td` bigint(20) NULL COMMENT "累计观看次数(需要除以2再向上取整)",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "观看域短剧用户观看累计指标表"
PARTITION BY RANGE(`dt`)
(PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "2",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-3",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "700",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
