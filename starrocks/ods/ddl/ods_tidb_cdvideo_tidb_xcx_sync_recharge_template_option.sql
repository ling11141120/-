CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_sync_recharge_template_option` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(100) NOT NULL COMMENT "原表主键_id",
  `template_id` varchar(300) NOT NULL DEFAULT "" COMMENT "充值模板ID",
  `option_snapshot_id` varchar(300) NOT NULL DEFAULT "" COMMENT "充值选项ID",
  `seq` int(11) NOT NULL DEFAULT "0" COMMENT "排序",
  `create_time` datetime NOT NULL COMMENT "创建时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧充值模板id与充值选项id关系表,author:510161"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
