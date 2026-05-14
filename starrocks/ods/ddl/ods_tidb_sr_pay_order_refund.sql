CREATE TABLE `ods_tidb_sr_pay_order_refund` (
  `Id` int(11) NOT NULL COMMENT "id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `Account` varchar(1024) NULL COMMENT "用户账号",
  `OrderId` varchar(65533) NULL COMMENT "订单id",
  `CooOrderId` varchar(65533) NULL COMMENT "合作支付订单号",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CooExtInfo` varchar(65533) NULL COMMENT "",
  `Sku` varchar(65533) NULL COMMENT "",
  `PackageName` varchar(65533) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "core",
  `RefundProcessStatus` int(11) NULL COMMENT "",
  `RefundDoneTime` datetime NULL COMMENT "",
  `ServerRefundStatus` int(11) NULL COMMENT "退款状态",
  `ServerRefundTime` datetime NULL COMMENT "退款时间",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "同步时间",
  `sr_updatetime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "用户退款退订记录"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
