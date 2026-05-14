CREATE TABLE `ads_app_ad_income_ed` (
  `dt` date NOT NULL COMMENT "时间天",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `core` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "终端： 1 iphone   4 Android   7 ipad   12 小程序   dim.dim_dic在这个表中 ",
  `ad_show_type` int(11) NULL COMMENT "广告类型：1banner，2原生广告，3激励视频，4开屏广告，6插屏广告",
  `appver` varchar(255) NULL COMMENT "版本号",
  `amt` decimal(38, 9) NULL COMMENT "广告收益",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `core`, `mt`)
COMMENT "广告收入统计"
PARTITION BY RANGE(`dt`)
(PARTITION p202406 VALUES [("2024-06-01"), ("2024-07-01")),
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
DISTRIBUTED BY HASH(`dt`, `product_id`, `core`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-120",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);