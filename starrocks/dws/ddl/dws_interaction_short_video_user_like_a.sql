CREATE TABLE `dws_interaction_short_video_user_like_a` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `fst_like_tm` datetime NULL COMMENT "首次点赞时间",
  `lst_like_tm` datetime NULL COMMENT "末次点赞时间",
  `like_series_td` bitmap NULL COMMENT "累计点赞剧的bitmap",
  `like_epis_td` bitmap NULL COMMENT "累计点赞剧集bitmap(剧id+集序号)",
  `like_cnt_td` bigint(20) NULL COMMENT "累计点赞次数",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "互动域短剧用户点赞累计指标表"
PARTITION BY RANGE(`dt`)
(PARTITION p202405 VALUES [("2024-05-01"), ("2024-06-01")),
PARTITION p202406 VALUES [("2024-06-01"), ("2024-07-01")),
PARTITION p202407 VALUES [("2024-07-01"), ("2024-08-01")),
PARTITION p202408 VALUES [("2024-08-01"), ("2024-09-01")),
PARTITION p202409 VALUES [("2024-09-01"), ("2024-10-01")),
PARTITION p202410 VALUES [("2024-10-01"), ("2024-11-01")),
PARTITION p202411 VALUES [("2024-11-01"), ("2024-12-01")),
PARTITION p202412 VALUES [("2024-12-01"), ("2025-01-01")),
PARTITION p202501 VALUES [("2025-01-01"), ("2025-02-01")),
PARTITION p202502 VALUES [("2025-02-01"), ("2025-03-01")),
PARTITION p202503 VALUES [("2025-03-01"), ("2025-04-01")),
PARTITION p202504 VALUES [("2025-04-01"), ("2025-05-01")),
PARTITION p202505 VALUES [("2025-05-01"), ("2025-06-01")),
PARTITION p202506 VALUES [("2025-06-01"), ("2025-07-01")),
PARTITION p202507 VALUES [("2025-07-01"), ("2025-08-01")),
PARTITION p202508 VALUES [("2025-08-01"), ("2025-09-01")),
PARTITION p202509 VALUES [("2025-09-01"), ("2025-10-01")),
PARTITION p202510 VALUES [("2025-10-01"), ("2025-11-01")),
PARTITION p202511 VALUES [("2025-11-01"), ("2025-12-01")),
PARTITION p202512 VALUES [("2025-12-01"), ("2026-01-01")),
PARTITION p202601 VALUES [("2026-01-01"), ("2026-02-01")),
PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-24",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "70",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
