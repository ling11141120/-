CREATE TABLE `ods_tidb_short_video_center_video_channel` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `StrategyCode` varchar(300) NULL COMMENT "策略代号",
  `Name` varchar(600) NOT NULL COMMENT "名称",
  `TitleId` bigint(20) NULL COMMENT "标题库Id",
  `ChannelType` int(11) NULL COMMENT "频道属性：1发现 2自定义",
  `RepetitionType` int(11) NULL COMMENT "频道全页排重类型：1 排重、2不排重",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `ApplyType` int(11) NOT NULL DEFAULT "1" COMMENT "应用场景：1 首页",
  `TemplateId` bigint(20) NULL COMMENT "模板Id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "频道管理表信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
