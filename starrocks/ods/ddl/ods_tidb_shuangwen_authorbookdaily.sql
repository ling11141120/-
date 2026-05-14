CREATE TABLE `ods_tidb_shuangwen_authorbookdaily` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `dt` date NOT NULL COMMENT "日期，根据staticdate转换",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `StaticDate` datetime NULL COMMENT "日期",
  `MoneySale` decimal(18, 2) NULL COMMENT "总收入",
  `Reward` decimal(18, 2) NULL COMMENT "打赏",
  `OtherSale` decimal(18, 2) NULL COMMENT "其他",
  `AuthorSale` decimal(18, 2) NULL COMMENT "作者收入",
  `AuthorSaleRate` varchar(500) NULL COMMENT "阶梯比率",
  `AuthorSaleActual` decimal(18, 2) NULL COMMENT "作者实际收入",
  `Language` int(11) NULL COMMENT "DEFAULT 3 语言",
  `RowVersion` bigint(20) NULL COMMENT "时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_language (`Language`) USING BITMAP COMMENT '语言索引',
  INDEX index_productid (`productid`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "作者书籍日常收入统计表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, BookId, StaticDate",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
