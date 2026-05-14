CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_book_bill` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `dt` date NOT NULL COMMENT "日期",
  `Name` varchar(512) NOT NULL COMMENT "站内书单名称",
  `BillType` int(11) NOT NULL COMMENT "书单类型 1：通用 2：书籍限免 3：章节限免",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index1 (`BillType`) USING BITMAP COMMENT 'index_BillType'
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `dt`)
COMMENT "站内流量测试-书单表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
