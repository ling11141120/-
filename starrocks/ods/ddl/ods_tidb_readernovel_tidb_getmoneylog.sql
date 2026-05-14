CREATE TABLE `ods_tidb_readernovel_tidb_getmoneylog` (
  `dt` date NOT NULL COMMENT "GetTime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "",
  `UserId` bigint(20) NOT NULL COMMENT "",
  `VipLv` int(11) NOT NULL COMMENT "",
  `PayChl` varchar(150) NOT NULL COMMENT "",
  `Charge` int(11) NOT NULL COMMENT "",
  `RealGet` int(11) NOT NULL COMMENT "",
  `Give` int(11) NOT NULL COMMENT "",
  `CurMoney` int(11) NOT NULL COMMENT "",
  `GetTime` datetime NOT NULL COMMENT "",
  `reforderid` varchar(765) NULL COMMENT "",
  `Seq` bigint(20) NULL COMMENT "",
  `cps` int(11) NULL COMMENT "",
  `chl2` varchar(765) NULL COMMENT "",
  `ChargeType` int(11) NULL COMMENT "0:正常 100：测试 5：余额冻结（先把用户余额消费冻结了   之后用户解冻在getmoneylog 又会发放一次 ）",
  `DeviceGUID` varchar(765) NULL COMMENT "",
  `GiftMoney` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
COMMENT "用户获得阅币记录表"
PARTITION BY RANGE(`dt`)
(PARTITION p2017 VALUES [("2017-01-01"), ("2018-01-01")),
PARTITION p2018 VALUES [("2018-01-01"), ("2019-01-01")),
PARTITION p2019 VALUES [("2019-01-01"), ("2020-01-01")),
PARTITION p2020 VALUES [("2020-01-01"), ("2021-01-01")),
PARTITION p2021 VALUES [("2021-01-01"), ("2022-01-01")),
PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
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
"bloom_filter_columns" = "GetTime",
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
