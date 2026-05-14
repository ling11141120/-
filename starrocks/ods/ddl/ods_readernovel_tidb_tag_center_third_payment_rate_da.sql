CREATE TABLE `ods_readernovel_tidb_tag_center_third_payment_rate_da` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `PayType` int(11) NOT NULL COMMENT "支付类型（3alipay,14weixin,22unipin,23stripe,25paypal,26paymentwall,27payssion,28payermax,29xsolla,30dukpay,1000000boa,1000001mycard,1000002ebanx）",
  `Payment` varchar(755) NOT NULL COMMENT "支付方式",
  `PaymentId` varchar(755) NOT NULL COMMENT "支付Id",
  `PaymentWay` varchar(755) NOT NULL COMMENT "支付渠道",
  `AccountLocation` varchar(755) NULL COMMENT "账号归属地",
  `Country` varchar(755) NOT NULL COMMENT "国家",
  `PayMethod` int(11) NOT NULL COMMENT "支付类型（0统一，1本地，2跨境）",
  `PayRate` decimal(18, 2) NOT NULL COMMENT "支付费率",
  `FixedTax` decimal(18, 2) NOT NULL COMMENT "固定税费",
  `BoundaryPoint` decimal(18, 2) NULL COMMENT "固定税费分界点",
  `MinimumAmount` decimal(18, 2) NULL COMMENT "最小支付金额",
  `BaseBonus` int(11) NOT NULL COMMENT "基础加赠",
  `Sort` int(11) NOT NULL COMMENT "排序",
  `AppLangId` int(11) NOT NULL COMMENT "app语言",
  `MaxImageUrl` varchar(65533) NOT NULL COMMENT "大图",
  `MinImageUrl` varchar(65533) NOT NULL COMMENT "小图",
  `Status` int(11) NOT NULL COMMENT "状态（0关闭，1启用）",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `sr_createtime` datetime NULL COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海阅海剧-三方支付费率表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
