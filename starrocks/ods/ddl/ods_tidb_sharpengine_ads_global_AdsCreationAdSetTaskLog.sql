CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `TaskId` bigint(20) NULL COMMENT "任务Id",
  `AdSetName` varchar(1024) NULL COMMENT "广告组名称",
  `AdSetId` varchar(1024) NULL COMMENT "广告组Id",
  `AdId` varchar(1024) NULL COMMENT "广告Id",
  `ResponseContent` varchar(65533) NULL COMMENT "响应内容",
  `Status` int(11) NULL COMMENT "状态 0 待执行 1 成功 2 失败",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `AdName` varchar(2048) NULL COMMENT "广告名称",
  `CheckStatus` varchar(1024) NULL COMMENT "广告发布状态",
  `AdStatus` varchar(2048) NULL COMMENT "状态",
  `ArrangeTime` varchar(1024) NULL COMMENT "日期",
  `BookId` bigint(20) NULL COMMENT "书籍Id",
  `Mt` int(11) NULL COMMENT "终端",
  `AdsOptimizer` varchar(1024) NULL COMMENT "优化师",
  `AccountId` varchar(1024) NULL COMMENT "账号",
  `ProjectCode` int(11) NULL COMMENT "项目",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  `IsAutoOpen` int(11) NOT NULL DEFAULT "0" COMMENT "默认开启的广告",
  `AdsAssetTestItemId` bigint(20) NOT NULL DEFAULT "0" COMMENT "素材算法测试项ID",
  `AdBudget` decimal(10, 5) NULL COMMENT "广告组预算",
  `PageId` varchar(128) NULL COMMENT "主页Id",
  `PixelId` varchar(128) NULL COMMENT "PixelId",
  `AdCampId` varchar(128) NULL COMMENT "系列Id",
  `LandingPageUrl` varchar(1024) NULL COMMENT "落地页地址",
  `SourceAdId` varchar(255) NULL COMMENT "复制源广告Id",
  `IsCopyPost` int(11) NULL COMMENT "是否复制原帖 0-否|1-是",
  `CreativeId` varchar(128) NULL COMMENT "素材Id",
  `CdAdId` varchar(50) NULL COMMENT "主动生成的AdId",
  `IsUpgrade` int(11) NULL COMMENT "是否新版本 1=SmartPlust 2.0"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告 广告组 日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
