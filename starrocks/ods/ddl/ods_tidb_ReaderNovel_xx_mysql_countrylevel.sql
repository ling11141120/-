CREATE TABLE `ods_tidb_ReaderNovel_xx_mysql_countrylevel` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `Level` int(11) NULL COMMENT "国家等级，1：T1国家，2：T2国家",
  `ShortName` varchar(65533) NULL COMMENT "国家缩写",
  `Remark` varchar(65533) NULL COMMENT "备注",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "",
  `row_update_time` datetime NULL COMMENT "更新时间",
  `SyncLanguage` varchar(65533) NULL COMMENT "同步语言",
  `Language` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "row_update_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
