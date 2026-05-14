CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsAdAutoRuleReviewPlan` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `ProjectCode` int(11) NULL COMMENT "项目 1 阅读 2 海外短剧",
  `Name` varchar(5000) NULL COMMENT "复盘方案名称",
  `Status` int(11) NULL COMMENT "复盘方案状态 1运行 0关闭",
  `CreateBy` varchar(200) NULL COMMENT "创建者",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateBy` varchar(200) NULL COMMENT "更新人",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告自动关闭规则复盘方案,author:102094"
DISTRIBUTED BY HASH(`Id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
