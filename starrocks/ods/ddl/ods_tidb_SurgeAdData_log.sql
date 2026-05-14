CREATE TABLE `ods_tidb_SurgeAdData_log` (
  `sr_createtime` datetime NOT NULL COMMENT "starrocks数据注入时间",
  `Id` bigint(20) NOT NULL COMMENT "",
  `Date` date NULL COMMENT "日期",
  `Sessions` bigint(20) NULL COMMENT "展示次数",
  `Clicks` bigint(20) NULL COMMENT "点击数",
  `RevenueNet` decimal(10, 2) NULL COMMENT "分成后收益",
  `Ctr` decimal(10, 2) NULL COMMENT "点击率",
  `Cpm` decimal(10, 2) NULL COMMENT "广告千次展现单价",
  `Cpc` decimal(10, 2) NULL COMMENT "广告千次点击单价",
  `UrlNo` varchar(255) NULL COMMENT "链接ID",
  `UrlName` varchar(255) NULL COMMENT "链接命名",
  `PartnerNo` varchar(255) NULL COMMENT "合作方ID",
  `PartnerName` varchar(255) NULL COMMENT "合作方名称",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`sr_createtime`, `Id`)
COMMENT "澎湃广告数据"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
