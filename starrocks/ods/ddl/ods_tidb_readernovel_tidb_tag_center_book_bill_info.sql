CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_bill_info` (
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `dt` date NOT NULL COMMENT "日期",
  `BillId` int(11) NOT NULL COMMENT "书单id",
  `Weight` int(11) NOT NULL COMMENT "流量权重",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `FreeChapter` int(11) NOT NULL COMMENT "免费章节",
  `LangId` int(11) NOT NULL COMMENT "语言id",
  `DelStatus` tinyint(4) NOT NULL COMMENT "处理状态",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index1 (`BillId`) USING BITMAP COMMENT 'index_BillType'
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `dt`)
COMMENT "站内流量测试-表单书籍表"
DISTRIBUTED BY HASH(`Id`, `dt`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
