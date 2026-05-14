CREATE TABLE `ods_tidb_Fmx_Author` (
  `AccountId` bigint(20) NOT NULL COMMENT "账号Id",
  `PenName` varchar(900) NULL COMMENT "笔名",
  `RealName` varchar(900) NULL COMMENT "姓名",
  `Status` int(11) NULL COMMENT "状态 0:未审核 1:已审核 2:已解约",
  `GroupId` int(11) NULL COMMENT "组Id",
  `AcccountName` varchar(65535) NULL COMMENT "",
  `AccountName` varchar(65535) NULL COMMENT "",
  `AuthorGuid` varchar(65535) NULL COMMENT "",
  `Account` varchar(65535) NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`AccountId`)
COMMENT "凤鸣轩--作者信息表"
DISTRIBUTED BY HASH(`AccountId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AccountId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
