CREATE TABLE `ods_tidb_short_video_log_log_reinstalllog` (
  `Id` bigint(20) NOT NULL COMMENT "编号id",
  `CreateTime` datetime NOT NULL COMMENT "记录时间",
  `AppId` int(11) NULL COMMENT "应用程序id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `Core` int(11) NULL COMMENT "Core",
  `Mt` int(11) NULL COMMENT "mt",
  `PreAppId` int(11) NULL COMMENT "上一次的AppId",
  `PreCore` int(11) NULL COMMENT "上一次的Core",
  `PreMt` int(11) NULL COMMENT "上一次的mt",
  `UniqueCdReaderId` varchar(255) NULL COMMENT "设备信息",
  `Status` int(11) NULL DEFAULT "0" COMMENT "ads使用,判断是否被用过了",
  `PreLoginTime` datetime NULL COMMENT "上一次登陆时间",
  `Days` float NULL COMMENT "流失天数",
  `ReInstallType` int(11) NULL DEFAULT "0" COMMENT "再次安装类型",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `CreateTime`)
COMMENT "短剧--用户重安装记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);
