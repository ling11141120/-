CREATE TABLE `ods_mysql_zhangzhong_xzz_Author` (
  `AccountId` bigint(20) NOT NULL COMMENT "账号Id",
  `PenName` varchar(900) NULL COMMENT "笔名",
  `RealName` varchar(900) NULL COMMENT "姓名",
  `Status` int(11) NULL COMMENT "状态 0:未审核 1:已审核 2:已解约",
  `GroupId` int(11) NULL COMMENT "组Id",
  `PenNameEn` varchar(65535) NULL COMMENT "英文笔名",
  `EditorId` bigint(20) NULL COMMENT "责编ID",
  `DepartmentType` int(11) NULL COMMENT "部门类型 0内容编辑部 1凤鸣轩"
) ENGINE=OLAP 
PRIMARY KEY(`AccountId`)
COMMENT "新掌中--作者信息表"
DISTRIBUTED BY HASH(`AccountId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AccountId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
