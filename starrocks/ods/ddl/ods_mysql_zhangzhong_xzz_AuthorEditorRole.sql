CREATE TABLE `ods_mysql_zhangzhong_xzz_AuthorEditorRole` (
  `Id` bigint(20) NOT NULL COMMENT "自增Id",
  `EditorName` varchar(900) NULL COMMENT "笔名",
  `UserId` bigint(20) NOT NULL COMMENT "用户Id",
  `RealName` varchar(900) NULL COMMENT "真实姓名",
  `Status` int(11) NULL COMMENT "状态0启用 1禁用",
  `CreateTime` datetime NULL COMMENT "新增时间",
  `DepartmentType` int(11) NULL COMMENT "部门类型 0内容编辑部 1凤鸣轩",
  `ShowType` int(11) NULL COMMENT "0展示 1不展示"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "新掌中--作者角色表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
