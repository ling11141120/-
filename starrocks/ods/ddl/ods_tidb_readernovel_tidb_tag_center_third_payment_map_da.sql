CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_third_payment_map_da` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `PayType` int(11) NOT NULL COMMENT "支付类型（3alipay,14weixin,22unipin,23stripe,25paypal,26paymentwall,27payssion,28payermax,29xsolla,30dukpay,1000000boa,1000001mycard,1000002ebanx）",
  `Payment` varchar(300) NOT NULL COMMENT "支付方式",
  `PaymentId` varchar(384) NOT NULL COMMENT "支付Id",
  `PaymentWay` varchar(600) NOT NULL COMMENT "支付渠道",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海阅海剧第三方支付映射表 author:195666"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
