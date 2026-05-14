CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_group_tag` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `Name` varchar(255) NOT NULL COMMENT "标签名称",
  `LangId` int(11) NOT NULL COMMENT "语言 1 :cn  n2 :ft  n3 :en  n4 :sp  n5 :pt  n6 :fr  n7 :ru  n9 :jp...",
  `Status` tinyint(4) NOT NULL COMMENT "状态",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `Code` varchar(50) NULL COMMENT "人群包标识",
  `IsSync` tinyint(4) NULL COMMENT "是否同步app",
  `GroupType` int(11) NOT NULL COMMENT "人群包类型 1: 静态包_导入UID  n2: 静态包_系统生成  n3: 动态包_系统生成  n4: 特殊人群包_系统生成",
  `GroupSyncTime` datetime NULL COMMENT "同步时间",
  `GroupExecutionTime` datetime NULL COMMENT "执行时间",
  `SecondLangId` int(11) NOT NULL COMMENT "二级语言",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "tag中台人群包信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
