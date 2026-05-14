CREATE TABLE `ods_tidb_readernovel_tidb_xx_puzzleactuserrecord` (
  `dt` date NOT NULL COMMENT "日期",
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `ActId` int(11) NULL COMMENT "",
  `Pid` bigint(20) NULL COMMENT "",
  `ImgId` int(11) NULL COMMENT "",
  `Type` int(11) NULL COMMENT "",
  `Token` varchar(150) NULL COMMENT "",
  `ImgPreResult` varchar(1500) NULL COMMENT "",
  `ImgResult` varchar(1500) NULL COMMENT "",
  `ComleteStatus` int(11) NULL COMMENT "",
  `RewardStatus` int(11) NULL COMMENT "",
  `AddTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `Power` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `productid`, `Id`)
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
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
