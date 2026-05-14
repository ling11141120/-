CREATE TABLE `ods_tidb_sharpengine_pay_PayorderNotify` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CooOrderId` varchar(128) NULL COMMENT "合作支付订单号",
  `Sku` varchar(128) NULL COMMENT "品类",
  `PackageId` varchar(128) NULL COMMENT "包Id",
  `PayType` varchar(255) NULL COMMENT "支付类型,appstore,googleplay",
  `RawCooOrderId` varchar(128) NULL COMMENT "原始订单号",
  `OrderData` varchar(65533) NULL COMMENT "原始订单信息",
  `OrderType` int(11) NULL DEFAULT "0" COMMENT "订单类型,订阅1/普通订单2",
  `UserId` bigint(20) NULL DEFAULT "0" COMMENT "可能的用户Id",
  `OrderId` varchar(128) NULL COMMENT "可能的订单号",
  `ProductId` int(11) NULL DEFAULT "0" COMMENT "产品id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "订单通知表,主要是处理订单取消订阅"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
