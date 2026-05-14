CREATE TABLE `ods_adsTidb_MaterialScore` (
  `MaterialId` bigint(20) NOT NULL COMMENT "素材Id",
  `Option1Score` decimal(10, 2) NOT NULL COMMENT "素材前6秒左右or前10%剧情的精彩程度",
  `Option2Score` decimal(10, 2) NOT NULL COMMENT "内容衔接程度",
  `Option3Score` decimal(10, 2) NOT NULL COMMENT "结尾钩子的吸引程度",
  `Option4Score` decimal(10, 2) NOT NULL COMMENT "素材观感质量、画面整体观感度",
  `AvgScore` decimal(10, 2) NOT NULL COMMENT "平均值",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `Creator` varchar(500) NULL COMMENT "创建人",
  `CreatorUid` varchar(500) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Updater` varchar(500) NULL COMMENT "更新人",
  `UpdaterUid` varchar(500) NULL COMMENT "更新人账号ID",
  `sr_createtime` datetime NULL COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`MaterialId`)
COMMENT "素材剪辑任务评分表 author:102094(何妨)"
DISTRIBUTED BY HASH(`MaterialId`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
