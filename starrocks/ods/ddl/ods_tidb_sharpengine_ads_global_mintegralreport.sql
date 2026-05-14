CREATE TABLE `ods_tidb_sharpengine_ads_global_mintegralreport` (
  `dt` date NOT NULL COMMENT "日期，来自CreatedTime字段",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `DATE` varchar(10) NULL COMMENT "日期",
  `AppId` bigint(20) NULL COMMENT "appid",
  `UnitId` bigint(20) NULL COMMENT "单元id",
  `Platform` varchar(10) NULL COMMENT "系统",
  `Filled` int(11) NULL COMMENT "填充次数",
  `Request` int(11) NOT NULL COMMENT "请求次数",
  `Impression` int(11) NOT NULL COMMENT "印记次数",
  `Click` int(11) NOT NULL COMMENT "点击",
  `EstRevenue` decimal(10, 2) NOT NULL COMMENT "EstRevenue",
  `FillRate` decimal(10, 2) NOT NULL COMMENT "填充率",
  `Country` varchar(10) NULL COMMENT "国家",
  `Ecpm` decimal(10, 2) NOT NULL COMMENT "每一千的有效成本",
  `Ctr` decimal(10, 2) NOT NULL COMMENT "点击通过率",
  `AppName` varchar(50) NULL COMMENT "app名字",
  `AppPackage` varchar(50) NULL COMMENT "应用包",
  `UnitName` varchar(50) NULL COMMENT "单元名字",
  `AdFormat` varchar(50) NULL COMMENT "广告格式",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
COMMENT "mintegral广告收入报表"
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")))
DISTRIBUTED BY HASH(`dt`, `Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
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
