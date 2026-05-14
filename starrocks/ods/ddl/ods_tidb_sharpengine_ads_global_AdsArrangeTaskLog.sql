CREATE TABLE `ods_tidb_sharpengine_ads_global_AdsArrangeTaskLog` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `Priority` int(11) NULL COMMENT "优先级",
  `DateKey` varchar(1024) NULL COMMENT "日期",
  `ProjectCode` int(11) NULL COMMENT "项目类型 1-海阅 2-海剧",
  `SourceChl` varchar(1024) NULL COMMENT "媒体",
  `ObjectId` varchar(1024) NULL COMMENT "广告Id",
  `AccountId` varchar(1024) NULL COMMENT "账号",
  `Optimizer` varchar(1024) NULL COMMENT "优化师",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `AccountTz` int(11) NULL COMMENT "时区",
  `PriorityType` int(11) NULL COMMENT "类型",
  `StartTime` datetime NULL COMMENT "开启时间",
  `Status` int(11) NULL COMMENT "状态 0 待执行 1 成功 2 失败",
  `ResponseContent` varchar(1048576) NULL COMMENT "响应内容",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `BookId` bigint(20) NULL COMMENT "书籍Id",
  `Round` int(11) NULL COMMENT "轮次",
  `AdPriority` int(11) NULL COMMENT "广告实际优先级",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编新组开启日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
