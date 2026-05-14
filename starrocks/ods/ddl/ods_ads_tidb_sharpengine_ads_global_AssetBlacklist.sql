CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AssetBlacklist` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `AssetGuid` varchar(1000) NULL COMMENT "素材唯一标识",
  `BlacklistType` int(11) NULL COMMENT "黑名单类型 1=自动|2=手动",
  `ViolationCount` int(11) NULL COMMENT "违规次数",
  `CreateBy` varchar(500) NULL COMMENT "创建人",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告-素材黑名单表,Auther:102094"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
