CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsCreationTemplate` (
  `Id` bigint(20) NOT NULL COMMENT "模板Id",
  `Name` varchar(1024) NULL COMMENT "模板名称",
  `ProjectCode` int(11) NULL COMMENT "项目类型",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `ProductId` int(11) NULL COMMENT "语言",
  `Mt` int(11) NULL COMMENT "终端",
  `Core` int(11) NULL COMMENT "Core",
  `SourceChl` varchar(1024) NULL COMMENT "媒体",
  `AdsType` varchar(1024) NULL COMMENT "AdsType",
  `CreateBy` varchar(1024) NULL COMMENT "创建人",
  `Status` int(11) NULL COMMENT "模板状态",
  `CreateByUid` varchar(1024) NULL COMMENT "创建人",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `AccountId` varchar(1024) NULL COMMENT "账号Id",
  `AdsMode` int(11) NULL COMMENT "广告模式 0 动态广告 1 普通广告 2 A+AC",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告组模板"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
