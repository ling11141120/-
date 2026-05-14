CREATE TABLE `ods_tidb_shuangwen_xx_objectchaptervice` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "",
  `ObjectBookId` int(11) NULL COMMENT "",
  `ThirdProofreadId` bigint(20) NULL COMMENT "",
  `ThirdProofreadName` varchar(1000) NULL COMMENT "",
  `ThirdPercent` decimal(18, 2) NULL COMMENT "",
  `NoProofreadPassStatus` int(11) NULL COMMENT "",
  `AuditStatus` int(11) NULL COMMENT "",
  `CheckInspectorsId` int(11) NULL COMMENT "",
  `CheckInspectorsName` varchar(200) NULL COMMENT "",
  `InspectorsPercent` decimal(18, 2) NULL COMMENT "",
  `InspectorsNoPassStatus` int(11) NULL COMMENT "",
  `InspectorsAuditStatus` int(11) NULL COMMENT "",
  `CheckForeignId` int(11) NULL COMMENT "",
  `CheckForeignName` varchar(200) NULL COMMENT "",
  `CheckForeignPercent` decimal(18, 2) NULL COMMENT "",
  `CheckForeignNoPassStatus` int(11) NULL COMMENT "",
  `CheckForeignAuditStatus` int(11) NULL COMMENT "",
  `RowVersion` datetime NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "爆款内容-翻译章节列表（抽检信息）"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
