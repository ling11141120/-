CREATE TABLE `alg_sample_update_repay_user_info_tmp` (
  `user_id` bigint(20) NULL COMMENT "",
  `sex` tinyint(4) NULL COMMENT "",
  `regcountry` varchar(1048576) NULL COMMENT "",
  `mt` int(11) NULL COMMENT "",
  `productid` int(11) NULL COMMENT "",
  `corever` int(11) NULL COMMENT "",
  `bookid` varchar(1048576) NULL COMMENT "",
  `adstype` varchar(1048576) NULL COMMENT "",
  `adsquality` int(11) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`user_id`, `sex`, `regcountry`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);