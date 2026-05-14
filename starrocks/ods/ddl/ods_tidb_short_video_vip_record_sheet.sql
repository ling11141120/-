CREATE TABLE `ods_tidb_short_video_vip_record_sheet` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `AccountId` bigint(20) NULL COMMENT "用户账号ID",
  `ExpireTime` bigint(20) NULL COMMENT "过期时间",
  `CreateTime` bigint(20) NULL COMMENT "创建时间",
  `ProductId` bigint(20) NULL COMMENT "支付配置表Id，阅读那的Id",
  `regionId` int(11) NULL COMMENT "归属区域 id，1：香港，2：北美；",
  `Type` int(11) NULL COMMENT "1 月卡  2 季卡 3 年卡",
  `Price` varchar(300) NULL COMMENT "价格",
  `GoodsOptionId` bigint(20) NULL COMMENT "商品价值方案ID",
  `ItemId` varchar(300) NULL COMMENT "申请ID",
  `Mt` int(11) NULL COMMENT "支付渠道，区分ios 1， android 4",
  `OrderMark` int(11) NULL COMMENT "订单标识1正常2取消续订",
  `PayOrderId` bigint(20) NULL COMMENT "订单号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-VIP购买记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
