CREATE TABLE `ods_tidb_readernovel_userladdertaskrecord` (
  `dt` date NOT NULL COMMENT "createtime分区",
  `product_id` int(11) NOT NULL COMMENT "createtime分区",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `ActId` int(11) NOT NULL DEFAULT "0" COMMENT "活动id",
  `LadderId` int(11) NOT NULL DEFAULT "0" COMMENT "阶梯任务id",
  `ReadTime` bigint(20) NOT NULL DEFAULT "0" COMMENT "活动阅读时长(秒)",
  `CoinConsume` int(11) NOT NULL DEFAULT "0" COMMENT "活动阅币消费",
  `RechargeMoney` int(11) NOT NULL DEFAULT "0" COMMENT "活动充值金额",
  `IsUnlockPaidReward` int(11) NOT NULL DEFAULT "0" COMMENT "是否解锁付费奖励 0：未解锁 1：已解锁",
  `FreeNumRecord` varchar(5000) NOT NULL COMMENT "免费档位记录",
  `PayNumRecord` varchar(5000) NOT NULL COMMENT "付费档位记录",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
COMMENT "海外阅读-用户阶梯任务记录"
PARTITION BY RANGE(`dt`)
(PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`dt`, `product_id`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Pid",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-120",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
