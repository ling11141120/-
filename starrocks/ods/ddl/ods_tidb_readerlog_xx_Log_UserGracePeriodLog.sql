CREATE TABLE `ods_tidb_readerlog_xx_Log_UserGracePeriodLog` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `OrderId` varchar(1000) NULL COMMENT "订单id",
  `ItemId` varchar(1000) NULL COMMENT "itemid",
  `PayType` varchar(1000) NULL COMMENT "googleplay /appstore",
  `MerchandiseType` int(11) NULL COMMENT "810: SVIP 840：新福利包，850：VIP",
  `GracePeriodBeginTime` datetime NULL COMMENT "宽限期开始时间",
  `GracePeriodEndTime` datetime NULL COMMENT "宽限期结束时间",
  `OrderRenewTime` datetime NULL COMMENT " 订单续订时间",
  `RecordType` int(11) NULL COMMENT "记录类型 0 进入宽限期 1 宽限期订单续订",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `AppId` int(11) NULL COMMENT "应用id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "海阅-用户宽限期日志 author:062958"
DISTRIBUTED BY HASH(`Id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
