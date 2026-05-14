CREATE TABLE `ods_tidb_readernovel_tidb_xx_chatevaluate` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `ChatGuid` varchar(40) NULL COMMENT "书籍ID",
  `Remark` varchar(1024) NULL COMMENT "添加进书架时书的名称",
  `TagStr` varchar(200) NULL COMMENT "评价标签",
  `Type` int(11) NULL COMMENT "评价等级",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CoreVer` int(11) NULL COMMENT "corever",
  `MT` int(11) NULL COMMENT "平台",
  `Ver` int(11) NULL COMMENT "版本号",
  `OperatorName` varchar(50) NULL COMMENT "操作者",
  `Language` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "小安客服评价"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
