CREATE TABLE `ods_cv_ad_cdvideo_tidb_xcx_user_ad_ecpm` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "用户ID",
  `CreateTime` datetime NULL COMMENT "用户广告预估收入数据生成时间",
  `Amount` bigint(20) NULL COMMENT "金额（10万分之一元）",
  `VideoUserId` varchar(128) NULL COMMENT "国剧用户ID",
  `AdId` varchar(128) NULL COMMENT "广告ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据生成时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "用户广告预估收入表（大概每3分钟生成一条用户广告预估收入表）"
DISTRIBUTED BY HASH(`Id`) BUCKETS 4 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
