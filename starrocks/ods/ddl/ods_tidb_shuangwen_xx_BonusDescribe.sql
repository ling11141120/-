CREATE TABLE `ods_tidb_shuangwen_xx_BonusDescribe` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "奖金包详细Id",
  `BonusId` int(11) NOT NULL COMMENT "奖金包Id",
  `ExceedLength` int(11) NOT NULL COMMENT "奖金包字数限制",
  `FixedPrice` decimal(18, 2) NOT NULL COMMENT "奖金包详细固定奖金",
  `Price` decimal(18, 2) NOT NULL COMMENT "奖金包详细浮动单价",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "奖金包详情表"
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
