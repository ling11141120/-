CREATE TABLE `ads_ab_exp_core_recharge_index_detail` (
  `experimentId` bigint(20) NOT NULL COMMENT "实验id",
  `experimentGroupId` bigint(20) NOT NULL COMMENT "实验组id",
  `dt` date NOT NULL COMMENT "日期分区",
  `projectId` int(11) NOT NULL COMMENT "项目id",
  `experimentType` varchar(50) NOT NULL COMMENT "实验类型(1对照组、2实验组)",
  `trackficVersion` varchar(500) NOT NULL COMMENT "流量版本",
  `windowNum` int(11) NOT NULL COMMENT "窗口大小(过去n天)",
  `oneExposureArpuMean` decimal(20, 6) NULL COMMENT "单人曝光ARPU均值",
  `oneExposureArpuVar` decimal(20, 6) NULL COMMENT "单人曝光ARPU方差",
  `oneExposureArpuDingYueMean` decimal(20, 6) NULL COMMENT "单人曝光ARPU(订阅)均值",
  `oneExposureArpuDingYueVar` decimal(20, 6) NULL COMMENT "单人曝光ARPU(订阅)方差",
  `saveTime` datetime NULL COMMENT "入库时间",
  `updateTime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`experimentId`, `experimentGroupId`, `dt`, `projectId`, `experimentType`, `trackficVersion`, `windowNum`)
COMMENT "海剧-AB实验-实验用户明细数据"
PARTITION BY RANGE(`dt`)
(PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`experimentId`, `experimentGroupId`, `dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "experimentGroupId, trackficVersion, experimentId",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "year",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-30",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);