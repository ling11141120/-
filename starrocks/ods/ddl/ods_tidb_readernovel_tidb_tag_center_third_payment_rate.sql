CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_third_payment_rate` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `PayType` int(11) NULL COMMENT "支付类型（3alipay,14weixin,22unipin,23stripe,25paypal,26paymentwall,27payssion,28payermax,29xsolla,30dukpay,1000000boa,1000001mycard,1000002ebanx）",
  `Payment` varchar(600) NULL COMMENT "支付方式",
  `PaymentId` varchar(600) NULL COMMENT "支付Id",
  `PaymentWay` varchar(600) NULL COMMENT "支付渠道",
  `AccountLocation` varchar(300) NULL COMMENT "账号归属地",
  `Country` varchar(300) NULL COMMENT "国家",
  `PayMethod` int(11) NULL COMMENT "支付类型（0统一，1本地，2跨境）",
  `PayRate` decimal(18, 2) NULL COMMENT "支付费率",
  `FixedTax` decimal(18, 2) NULL COMMENT "固定税费",
  `BoundaryPoint` decimal(18, 2) NULL COMMENT "固定税费分界点",
  `MinimumAmount` decimal(18, 2) NULL COMMENT "最小支付金额",
  `BaseBonus` int(11) NULL COMMENT "基础加赠",
  `Sort` int(11) NULL COMMENT "排序",
  `AppLangId` int(11) NULL COMMENT "app语言",
  `MaxImageUrl` varchar(6000) NULL COMMENT "大图",
  `MinImageUrl` varchar(6000) NULL COMMENT "小图",
  `Status` int(11) NULL COMMENT "状态（0关闭，1启用）",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `Core` varchar(50) NULL COMMENT "Core",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "第三方支付费率表 author:195666"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
