CREATE TABLE `ads_sr_third_party_payment_exposure_tmp` (
  `product_id` int(11) NOT NULL COMMENT "",
  `user_id` bigint(20) NOT NULL COMMENT "",
  `event_tm` datetime NOT NULL COMMENT "",
  `zffs_list` varchar(500) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`product_id`, `user_id`, `event_tm`)
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);