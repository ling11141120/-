CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_push_statistic` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `PushType` int(11) NULL COMMENT "push类型（0push,1私信）",
  `PushId` int(11) NULL COMMENT "推送Id",
  `ActivityId` int(11) NULL COMMENT "活动Id",
  `ActionId` int(11) NULL COMMENT "活动策略Id",
  `LangId` int(11) NULL COMMENT "语言",
  `StatisticTime` datetime NULL COMMENT "统计时间",
  `AllUserCount` int(11) NULL COMMENT "总人群包用户",
  `TimeUserCount` int(11) NULL COMMENT "时区推送用户",
  `TokenUserCount` int(11) NULL COMMENT "有token用户",
  `PushUserCount` int(11) NULL COMMENT "推送用户",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
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
