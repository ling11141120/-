CREATE TABLE `ods_tidb_readernovel_tidb_xx_cusservicework` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `riqi` datetime NULL COMMENT "日期",
  `operateName` varchar(300) NULL COMMENT "客服",
  `backCount` varchar(300) NULL COMMENT "回复条数",
  `backUserCount` varchar(300) NULL COMMENT "回复用户数",
  `missCount` varchar(300) NULL COMMENT "忽略数",
  `startTime` datetime NULL COMMENT "开始时间",
  `endTime` datetime NULL COMMENT "结束时间",
  `Score` varchar(300) NULL COMMENT "评分数",
  `avgScore` varchar(300) NULL COMMENT "平均分",
  `scoreLevelF` varchar(300) NULL COMMENT "5 分",
  `scoreLevelT` varchar(300) NULL COMMENT "3 分",
  `scoreLevelO` varchar(300) NULL COMMENT "1 分",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
