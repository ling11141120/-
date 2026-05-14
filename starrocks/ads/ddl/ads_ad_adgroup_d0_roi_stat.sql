CREATE TABLE `ads_ad_adgroup_d0_roi_stat` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` bigint(20) NOT NULL COMMENT "产品ID",
  `ad_set_id` varchar(65533) NOT NULL COMMENT "广告组ID",
  `ad_set_name` varchar(65533) NULL COMMENT "广告组名称",
  `d0_ad_income` decimal(20, 2) NULL COMMENT "d0的广告收入",
  `cost_amount` decimal(20, 2) NULL COMMENT "当日花费",
  `d0_roi` decimal(20, 4) NULL COMMENT "d0的roi",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `ad_set_id`)
COMMENT "广告域--广告组D0的ROI统计"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, ad_set_id, product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);