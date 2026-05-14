CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_activity_main` (
  `Id` int(11) NOT NULL COMMENT "",
  `Name` varchar(1500) NULL COMMENT "活动名称",
  `StartTime` datetime NOT NULL COMMENT "开始时间",
  `EndTime` datetime NOT NULL COMMENT "结束时间",
  `Status` int(11) NOT NULL COMMENT "状态 1 开启，2 关闭",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `LangId` int(11) NOT NULL COMMENT "语言id",
  `ActityType` int(11) NOT NULL COMMENT "活动类型 1：定向充值，2：push,3:edm充值活动,4:推书活动活动(指定书籍),5:其他活动,6:消费活动 7:组合活动，8:推书活动活动(书单)，9:充值档位活动，10:新福利包档位活动, 11:svip档位活动，12:抽奖活动，13:限免卡活动，14:限免卡档位活动",
  `SecondType` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `CombinPageId` int(11) NULL DEFAULT "0" COMMENT "组合页面id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
