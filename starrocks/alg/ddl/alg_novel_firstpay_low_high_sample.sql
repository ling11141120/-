CREATE TABLE `alg_novel_firstpay_low_high_sample` (
  `user_id` bigint(20) NOT NULL COMMENT "",
  `productid` varchar(65533) NOT NULL COMMENT "",
  `bookid` varchar(65533) NOT NULL COMMENT "",
  `mt` bigint(20) NULL COMMENT "",
  `sex` varchar(65533) NULL COMMENT "",
  `brand` varchar(65533) NULL COMMENT "",
  `device` varchar(65533) NULL COMMENT "",
  `regcountry` varchar(65533) NULL COMMENT "",
  `country_level` varchar(65533) NULL COMMENT "",
  `sysreleasever` varchar(65533) NULL COMMENT "",
  `email` varchar(65533) NULL COMMENT "",
  `currentlanguage` varchar(65533) NULL COMMENT "",
  `currentlanguage2` varchar(65533) NULL COMMENT "",
  `corever` varchar(65533) NULL COMMENT "",
  `chl` varchar(65533) NULL COMMENT "",
  `chl2` varchar(65533) NULL COMMENT "",
  `adstype` varchar(65533) NULL COMMENT "",
  `adsquality` varchar(65533) NULL COMMENT "",
  `ram` varchar(65533) NULL COMMENT "",
  `price` varchar(65533) NOT NULL COMMENT "",
  `dt` date NOT NULL COMMENT "",
  `ecpm` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`, `productid`)
COMMENT "海阅-用户首充样本表"
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`dt`, `mt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "year",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-365",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);