CREATE TABLE `ods_tidb_short_video_log_usermoneylog` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `Amount` int(11) NULL COMMENT "总数",
  `RemainAmount` int(11) NULL COMMENT "剩余数量",
  `BookId` bigint(20) NULL COMMENT "剧id",
  `ChapterIds` varchar(65533) NULL COMMENT "集ID",
  `ChapterName` varchar(3000) NULL COMMENT "集名称",
  `CreateTime` datetime NULL COMMENT "",
  `PayType` int(11) NULL COMMENT "类型",
  `MT` int(11) NULL COMMENT "机型",
  `Seq` bigint(20) NULL COMMENT "",
  `VipType` int(11) NULL COMMENT "",
  `OriginCoin` int(11) NULL COMMENT "",
  `VipDisPrice` int(11) NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "应用id",
  `PositionId` varchar(200) NULL COMMENT "",
  `AppGameId` bigint(20) NULL COMMENT "",
  `SendId` varchar(1000) NULL COMMENT "sendid",
  `ChapterNos` varchar(65533) NULL COMMENT "章节序号列表",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "用户消费记录日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
