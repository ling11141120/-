CREATE TABLE `alg_firstpay_feature_tmp` (
  `sex` int(11) NULL COMMENT "性别",
  `emailsuffix` varchar(65533) NULL COMMENT "邮箱地址",
  `regcountry` varchar(65533) NULL COMMENT "注册国家",
  `mt` int(11) NULL COMMENT "平台",
  `productid` int(11) NULL COMMENT "产品id",
  `corever` int(11) NULL COMMENT "包体",
  `chl` varchar(65533) NULL COMMENT "渠道值",
  `chl2` varchar(65533) NULL COMMENT "渠道值",
  `bookid` varchar(65533) NULL COMMENT "广告bookid",
  `adstype` varchar(65533) NULL COMMENT "用户广告标签ADSTYPE",
  `adsquality` int(11) NULL COMMENT "用户广告标签",
  `device` varchar(65533) NULL COMMENT "设备",
  `sysreleasever` varchar(65533) NULL COMMENT "固件版本",
  `ram` int(11) NULL COMMENT "手机内存",
  `brand` varchar(65533) NULL COMMENT "手机品牌",
  `currentlanguage` int(11) NULL COMMENT "语言",
  `currentlanguage2` int(11) NULL COMMENT "语言",
  `pay_amt` int(11) NULL COMMENT "支付金额",
  `pay_index` int(11) NULL COMMENT "支付金额",
  `pay_num` bigint(20) NOT NULL COMMENT "充值row_num",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`sex`, `emailsuffix`)
COMMENT "算法-充值金额分类汇总表"
DISTRIBUTED BY HASH(`productid`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);