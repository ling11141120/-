CREATE TABLE `ads_read_retention_stat_p_da` (
  `dt` date NOT NULL COMMENT "阅读时间分区",
  `lang_id` int(11) NOT NULL COMMENT "书籍语言id",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `mt` int(11) NULL COMMENT "平台： 1 iphone   4 android   9 书城    7 ipad   0 其它",
  `source_user_tp` int(11) NULL COMMENT "媒体用户类型:1 注册当天 2 再营销安装 3 其它",
  `date_stat_type` int(11) NULL COMMENT "取值为0~7， 0为DT当天",
  `book_name` varchar(255) REPLACE NULL COMMENT "书籍名称",
  `book_code` varchar(255) REPLACE NULL COMMENT "书籍编码",
  `first_read_users` bitmap BITMAP_UNION NULL COMMENT "首次阅读用户列表",
  `read_users` bitmap BITMAP_UNION NULL COMMENT "阅读用户列表",
  `consume_amount` decimal(38, 2) SUM NULL COMMENT "阅币消耗",
  `consume_users` bitmap BITMAP_UNION NULL COMMENT "阅币消耗用户列表",
  `d7_read_users` bitmap BITMAP_UNION NULL COMMENT "7天内阅读指定天数的用户列表",
  `d7_consume_users` bitmap BITMAP_UNION NULL COMMENT "7天内消耗指定天数的用户列表",
  `etl_time` datetime REPLACE NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据清洗时间"
) ENGINE=OLAP 
AGGREGATE KEY(`dt`, `lang_id`, `book_id`, `mt`, `source_user_tp`, `date_stat_type`)
COMMENT "阅读-西五区-书籍每日阅读留存相关统计"
PARTITION BY RANGE(`dt`)
(PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")))
DISTRIBUTED BY HASH(`book_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, lang_id, book_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-10",
"dynamic_partition.end" = "1",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);