CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsAdAutoRuleLog` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `RuleId` bigint(20) NULL COMMENT "规则Id",
  `AccountId` varchar(500) NULL COMMENT "账号Id",
  `AccountName` varchar(1000) NULL COMMENT "账号名称",
  `ObjectId` varchar(500) NULL COMMENT "操作对象Id",
  `ObjectName` varchar(1000) NULL COMMENT "操作对象名称",
  `Operate` int(11) NULL COMMENT "操作 0-关闭广告组 1-开启广告组 2-关闭广告系列 3-开启广告系列 4-仅通知",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Status` int(11) NULL COMMENT "规则状态 0 失败 1 成功",
  `LogContent` varchar(4000) NULL COMMENT "日志debug信息",
  `LogGuid` varchar(50) NULL COMMENT "规则日志GuId",
  `BudgetTaskId` bigint(20) NULL COMMENT "预算任务Id",
  `D0ReachRate` decimal(10, 5) NULL COMMENT "D0达标率",
  `PayCount` int(11) NULL COMMENT "付费次数",
  `D0Cac` decimal(10, 5) NULL COMMENT "D0 CAC",
  `D0Roi` decimal(10, 5) NULL COMMENT "D0 Roi",
  `PayNum` decimal(10, 5) NULL COMMENT "付费人数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告自动关闭规则 操作日志,author:742337"
DISTRIBUTED BY HASH(`Id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
