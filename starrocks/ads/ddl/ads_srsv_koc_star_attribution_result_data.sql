CREATE TABLE `ads_srsv_koc_star_attribution_result_data` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `institution_id` int(11) NOT NULL COMMENT "机构id",
  `star_id` int(11) NOT NULL COMMENT "达人id",
  `koc_code` varchar(100) NOT NULL COMMENT "koc口令",
  `user_type` int(11) NOT NULL COMMENT "用户类型",
  `user_id` bigint(20) NOT NULL COMMENT "用户类型,1新用户",
  `reg_country` varchar(100) NULL COMMENT "注册国家",
  `ip` varchar(100) NULL COMMENT "ip",
  `create_time` datetime NULL COMMENT "创建时间",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `institution_id`, `star_id`, `koc_code`, `user_type`, `user_id`)
COMMENT "KOC达人口令统计转化报表"
DISTRIBUTED BY HASH(`dt`, `institution_id`, `star_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);