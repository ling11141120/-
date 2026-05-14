CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask` (
  `dt` date NOT NULL COMMENT "日期, date(CreateTime)转化为日期格式",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `TemplateId` bigint(20) NULL COMMENT "模板Id",
  `CampaignTaskId` varchar(1024) NULL COMMENT "创建系列任务Id",
  `ObjectContent` varchar(1048576) NULL COMMENT "广告组信息",
  `Status` int(11) NULL COMMENT "状态 0 待执行 1 成功 2 失败",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `ResponseContent` varchar(65533) NULL COMMENT "响应内容",
  `CreateBy` varchar(1024) NULL COMMENT "创建人",
  `CreateByUid` varchar(1024) NULL COMMENT "创建人",
  `MarketingPlanLastTaskId` bigint(20) NULL COMMENT "内容任务最终任务ID",
  `CreationType` int(11) NULL COMMENT "创编方式 0 手动 1 自动",
  `PlanId` varchar(1024) NULL COMMENT "方案Id",
  `PlanItemId` varchar(1024) NULL COMMENT "方案配置项Id",
  `PlanTaskId` varchar(1024) NULL COMMENT "任务Id",
  `DefaultAccountId` varchar(1024) NULL COMMENT "默认账号",
  `DefaultPageId` varchar(1024) NULL COMMENT "默认主页",
  `DefaultInstaId` varchar(1024) NULL COMMENT "默认IG账号",
  `Sync` int(11) NULL COMMENT "是否同步",
  `AdsMode` int(11) NULL COMMENT "广告模式 0 动态广告 1 普通广告 2 A+AC",
  `DefaultIdentityId` varchar(255) NULL COMMENT "默认头像",
  `CopyFromTaskId` bigint(20) NULL COMMENT "从哪个任务复制",
  `RuleLogGuid` varchar(255) NULL COMMENT "规则日志唯一Id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
COMMENT "创编广告 广告组"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
