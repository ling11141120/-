CREATE TABLE `ads_sv_algorithm_series_ranking` (
  `dt` date NOT NULL COMMENT "日期",
  `days` int(11) NOT NULL COMMENT "榜单周期类型：1总榜 2一日榜 3三日榜 4七日榜 5十五日榜 6三十日榜",
  `series_id` bigint(20) NOT NULL COMMENT "剧ID",
  `core` int(11) NOT NULL COMMENT "core版本",
  `lang_id` int(11) NOT NULL COMMENT "语言ID",
  `avg_epis` decimal(10, 2) NULL COMMENT "人均观看集数",
  `uv` bigint(20) NULL COMMENT "开始观看人数",
  `publish_edat` datetime NULL COMMENT "剧上架时间",
  `avg_epis_rank` bigint(20) NULL COMMENT "人均观看集数排名（倒序）",
  `uv_rank` bigint(20) NULL COMMENT "开始观看人数排名（倒序）",
  `publish_edat_rank` bigint(20) NULL COMMENT "上架时间排名（倒序：越晚上架排名越靠前）",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "ETL清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `days`, `series_id`, `core`, `lang_id`)
COMMENT "海剧-算法剧集排名表"
PARTITION BY RANGE(`dt`)
(PARTITION p202512 VALUES [("2025-12-01"), ("2026-01-01")),
PARTITION p202601 VALUES [("2026-01-01"), ("2026-02-01")),
PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`dt`, `series_id`, `core`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, core, series_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);