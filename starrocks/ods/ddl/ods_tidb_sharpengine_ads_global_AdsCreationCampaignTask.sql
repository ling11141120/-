CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsCreationCampaignTask` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `TaskId` varchar(1024) NULL COMMENT "任务Id",
  `AccountId` varchar(1024) NULL COMMENT "账号Id",
  `Name` varchar(1024) NULL COMMENT "系列名称",
  `BuyingType` varchar(1024) NULL COMMENT "购买类型",
  `Objective` varchar(2048) NULL COMMENT "广告目标",
  `Status` int(11) NULL COMMENT "状态 0 待执行 1 成功 2 失败",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `CampaignId` varchar(1024) NULL COMMENT "系列Id",
  `ResponseContent` varchar(65533) NULL COMMENT "响应内容",
  `AdsMode` int(11) NULL COMMENT "广告模式 0 动态广告 1 普通广告 2 A+AC",
  `CopyFromCampaignId` varchar(1024) NULL COMMENT "从其他系列ID进行复制",
  `AdsType` varchar(1024) NULL COMMENT "AdsType",
  `Budget` decimal(10, 2) NULL COMMENT "CBO系列预算",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告 广告系列"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
