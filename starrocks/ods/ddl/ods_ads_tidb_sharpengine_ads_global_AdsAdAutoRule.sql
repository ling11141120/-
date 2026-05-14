CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsAdAutoRule` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `Name` varchar(4000) NULL COMMENT "规则名称",
  `Status` int(11) NULL COMMENT "规则状态 1运行 0关闭",
  `Operate` int(11) NULL COMMENT "操作 0-关闭广告组 1-开启广告组 2-关闭广告系列 3-开启广告系列 4-仅通知",
  `CreateBy` varchar(200) NULL COMMENT "创建者",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `ProjectCode` int(11) NULL COMMENT "项目 1 阅读 2 海外短剧",
  `InstId` bigint(20) NULL COMMENT "机构Id",
  `Core` int(11) NULL COMMENT "Core",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告自动关闭规则,author:742337"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
