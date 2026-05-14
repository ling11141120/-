CREATE TABLE `ods_tidb_sharpengine_ads_global_admobadsources` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `Name` varchar(65533) NULL COMMENT "名字",
  `AdSourceId` varchar(65533) NULL COMMENT "广告来源id",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "admob广告来源表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
