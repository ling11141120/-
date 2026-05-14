CREATE TABLE `alg_sample_update_repay_pay_info_tmp` (
  `dt` date NULL COMMENT "",
  `user_id` bigint(20) NULL COMMENT "",
  `sex` tinyint(4) NULL COMMENT "",
  `emailsuffix` varchar(1048576) NULL COMMENT "",
  `regcountry` varchar(1048576) NULL COMMENT "",
  `mt` int(11) NULL COMMENT "",
  `productid` int(11) NULL COMMENT "",
  `corever` int(11) NULL COMMENT "",
  `chl` varchar(1048576) NULL COMMENT "",
  `chl2` varchar(1048576) NULL COMMENT "",
  `bookid` varchar(1048576) NULL COMMENT "",
  `adstype` varchar(1048576) NULL COMMENT "",
  `adsquality` int(11) NULL COMMENT "",
  `device` varchar(1048576) NULL COMMENT "",
  `sysreleasever` varchar(1048576) NULL COMMENT "",
  `ram` int(11) NULL COMMENT "",
  `brand` varchar(1048576) NULL COMMENT "",
  `currentlanguage` int(11) NULL COMMENT "",
  `currentlanguage2` int(11) NULL COMMENT "",
  `itemcount` int(11) NULL COMMENT "",
  `pay_index` bigint(20) NULL COMMENT "",
  `pay_num` bigint(20) NOT NULL COMMENT "",
  `etl_tm` datetime NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `user_id`, `sex`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);