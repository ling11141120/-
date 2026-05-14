CREATE TABLE `dwd_grant_medalitem` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `pid` bigint(20) NOT NULL DEFAULT "0" COMMENT "",
  `medal_num` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `expire_tm` datetime NOT NULL COMMENT "",
  `source` varchar(955) NULL COMMENT "",
  `send_num` int(11) NULL COMMENT "",
  `send_tm` datetime NULL COMMENT "",
  `source_key` varchar(955) NULL COMMENT "",
  `app_id_account` int(11) NULL COMMENT "项目id，core，语言",
  `mt` int(11) NULL COMMENT "平台 0未知 1iphone 4安卓 9书城",
  `is_has_charge` tinyint(4) NULL COMMENT "是否充过值",
  `corever` int(11) NULL COMMENT "版本号",
  `current_language` int(11) NULL COMMENT "用户当前语言",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `reg_country` varchar(65533) NULL COMMENT "注册时国家",
  `regdate` datetime NULL COMMENT "用户的注册时间",
  `prod_id` varchar(65533) NULL COMMENT "产品id",
  `device_guid` varchar(65533) NULL COMMENT "设备guid",
  `app_ver` varchar(65533) NULL COMMENT "app版本",
  `ver` int(11) NULL COMMENT "客户端版本号",
  `ads_type` varchar(60) NULL COMMENT "用户广告标签adstype",
  `ads_quality` int(11) NULL COMMENT "用户广告标签",
  `is_negative_user` int(11) NULL COMMENT "是否白嫖用户",
  `etl_tm` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);