CREATE TABLE `ods_tidb_sr_shuangwen_tidb_fr_objectbookcnsummary` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `cn_bookid` bigint(20) NULL COMMENT "中文书籍id",
  `to_bookid` bigint(20) NULL COMMENT "目标书籍id",
  `to_langid` int(11) NULL COMMENT "目标语言id",
  `from_bookid` bigint(20) NULL COMMENT "来源书籍id",
  `from_langid` int(11) NULL COMMENT "来源语言id",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "中文翻译书籍映射表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "to_bookid, to_langid, cn_bookid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
