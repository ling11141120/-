CREATE TABLE `ods_tidb_readernovel_tidb_xx_novel_vipbook` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `Language` int(11) NULL COMMENT "语言",
  `VipSign` int(11) NULL COMMENT "VIP标识 1 VIP书(白名单+规则书) 2 未定义(vip黑名单的书)",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
