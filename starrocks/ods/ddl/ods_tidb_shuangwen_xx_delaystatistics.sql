CREATE TABLE `ods_tidb_shuangwen_xx_delaystatistics` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `BookName` varchar(65533) NOT NULL COMMENT "书籍名称",
  `ChapterId` int(11) NOT NULL COMMENT "章节Id",
  `ChapterName` varchar(65533) NOT NULL COMMENT "章节名称",
  `PersonnelId` int(11) NOT NULL COMMENT "人员Id",
  `PersonnelName` varchar(65533) NOT NULL COMMENT "人员名称",
  `DelayTime` int(11) NULL COMMENT "超时时间",
  `Percents` decimal(18, 2) NULL COMMENT "外校百分比",
  `StatisticsType` int(11) NOT NULL COMMENT "统计类别（1译员超时，2外校超时，3外校编辑百分比，4自校超时）",
  `StatisticsTine` datetime NOT NULL COMMENT "统计时间",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `RemindStatus` int(11) NOT NULL COMMENT "处理状态（0未处理，1提醒，2释放）",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "超时记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
