CREATE TABLE `ods_tidb_readerlog_xx_Log_TagPushRecordLog` (
  `productid` int(11) NOT NULL COMMENT "产品ID",
  `Id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `PushId` int(11) NULL COMMENT "推送id",
  `TitleId` int(11) NULL COMMENT "标题id",
  `ActivityId` int(11) NULL COMMENT "活动id",
  `SendType` int(11) NULL COMMENT "发送类型",
  `UtcOffset` int(11) NULL COMMENT "时区偏移",
  `PushUserGroupCount` int(11) NULL COMMENT "推送策略人群包总数量",
  `MergeAndFilterAfterUserCount` int(11) NULL COMMENT "合并推送用户数量",
  `TimeZoneUserCount` int(11) NULL COMMENT "推送时区用户数",
  `SendCount` int(11) NULL COMMENT "发送数量",
  `TokenLossRate` decimal(14, 4) NULL COMMENT "token折损率",
  `BusinessLossRate` decimal(14, 4) NULL COMMENT "业务折损率",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "push发送统计"
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
