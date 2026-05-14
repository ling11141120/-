CREATE TABLE `ods_mysql_finerepodb_fine_homepage_expand` (
  `id` varchar(255) NOT NULL COMMENT "",
  `androidPadHomePage` varchar(1000) NULL COMMENT "",
  `androidPhoneHomePage` varchar(1000) NULL COMMENT "",
  `iPadHomePage` varchar(1000) NULL COMMENT "",
  `iPhoneHomePage` varchar(1000) NULL COMMENT "",
  `pcHomePage` varchar(1000) NULL COMMENT "",
  `type` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "finebReport 首页数据"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
