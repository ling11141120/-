CREATE TABLE `ods_tidb_shuangwen_en_authoreditorrole` (
  `ProductId` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `EditorName` varchar(600) NOT NULL COMMENT "",
  `UserId` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `RealName` varchar(600) NULL COMMENT "真实名称",
  `ParentId` bigint(20) NULL DEFAULT "0" COMMENT "",
  `Status` int(11) NOT NULL COMMENT "状态",
  `EditorType` int(11) NOT NULL COMMENT "编辑类型",
  `Language` int(11) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "新增时间",
  `EditorEmail` varchar(600) NULL COMMENT "",
  `Mobile` varchar(180) NULL COMMENT "",
  `DisableTime` datetime NULL COMMENT "禁用时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ProductId`, `Id`)
DISTRIBUTED BY HASH(`ProductId`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
