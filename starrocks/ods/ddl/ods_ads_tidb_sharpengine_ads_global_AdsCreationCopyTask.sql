CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsCreationCopyTask` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `TaskId` varchar(50) NOT NULL COMMENT "任务Id",
  `CampaignId` varchar(500) NULL COMMENT "系列Id",
  `CampaignTaskId` varchar(500) NULL COMMENT "系列任务Id",
  `CampaignName` varchar(500) NULL COMMENT "系列名称",
  `ObjectContent` varchar(65533) NULL COMMENT "广告组信息",
  `Status` int(11) NOT NULL DEFAULT "0" COMMENT "状态 0 待执行 1 成功 2 失败",
  `SourceChl` varchar(100) NULL COMMENT "媒体",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `ResponseContent` varchar(65533) NULL COMMENT "响应内容",
  `CreateByUid` varchar(500) NULL COMMENT "创建人",
  `CreateBy` varchar(500) NULL COMMENT "创建人",
  `MarketingPlanLastTaskId` bigint(20) NULL COMMENT "内容任务最终任务ID",
  `IsCreateNewCampaign` int(11) NOT NULL DEFAULT "0" COMMENT "是否新系列",
  `ProjectCode` int(11) NOT NULL DEFAULT "0" COMMENT "项目",
  `CreationType` int(11) NOT NULL DEFAULT "0" COMMENT "创编方式 0 手动 1 自动",
  `PlanId` varchar(100) NULL COMMENT "方案Id",
  `PlanTaskId` varchar(100) NULL COMMENT "任务Id",
  `PlanItemId` varchar(100) NULL COMMENT "方案配置项Id",
  `TemplateId` bigint(20) NULL COMMENT "模板Id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告 广告组复制"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
