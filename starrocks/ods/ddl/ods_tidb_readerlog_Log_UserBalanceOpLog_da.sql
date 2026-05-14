CREATE TABLE `ods_tidb_readerlog_Log_UserBalanceOpLog_da` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `UserId` bigint(20) NOT NULL DEFAULT "0" COMMENT "用户id",
  `Mt` int(11) NOT NULL DEFAULT "0" COMMENT "Mt",
  `Core` int(11) NOT NULL DEFAULT "0" COMMENT "Core版本",
  `DeviceId` varchar(255) NULL COMMENT "设备",
  `Coins` int(11) NOT NULL DEFAULT "0" COMMENT "阅币数量",
  `AwardCoins` int(11) NOT NULL DEFAULT "0" COMMENT "赠送币数量",
  `Gifts` int(11) NOT NULL DEFAULT "0" COMMENT "礼券数量",
  `OpType` int(11) NOT NULL DEFAULT "0" COMMENT "操作类型 1:冻结 2:解冻",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `AppId` int(11) NULL COMMENT "应用id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "阅读-用户余额冻结表"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "UserId, CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
