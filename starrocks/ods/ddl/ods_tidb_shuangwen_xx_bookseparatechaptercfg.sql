CREATE TABLE `ods_tidb_shuangwen_xx_bookseparatechaptercfg` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `CopyBookId` int(11) NOT NULL COMMENT "来源书id",
  `BookId` int(11) NOT NULL COMMENT "新书id",
  `LimitWord` int(11) NOT NULL COMMENT "限制字数",
  `PartWords` int(11) NOT NULL COMMENT "分布字数",
  `Status` int(11) NOT NULL COMMENT "状态",
  `LastUpdateTime` datetime NULL COMMENT "更新时间",
  `Language` int(11) NOT NULL COMMENT "语言",
  `CreateTime` datetime NOT NULL COMMENT "新增时间",
  `IsFromNovelBook` int(11) NULL COMMENT "是否来自novelbook",
  `IsPublishTimeSync` int(11) NOT NULL COMMENT "是否同步发布时间",
  `RowVersion` bigint(20) NULL COMMENT "数据版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "拆章配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
