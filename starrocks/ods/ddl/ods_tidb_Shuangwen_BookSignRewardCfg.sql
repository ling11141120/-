CREATE TABLE `ods_tidb_Shuangwen_BookSignRewardCfg` (
  `dt` datetime NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Language` int(11) NULL COMMENT "语言id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `RowVersion` bigint(20) NULL COMMENT "版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_ProductId (`product_id`) USING BITMAP COMMENT 'index_Product_Id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
COMMENT "开启满勤签到配置表"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
