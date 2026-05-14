CREATE TABLE `ads_bi_ad_new_user_value_ed` (
  `dt` date NOT NULL COMMENT "广告投放日期（西五区日期）",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `md5_ad_id` varchar(65533) NOT NULL COMMENT "广告id,md5加密",
  `ad_id` varchar(65533) NOT NULL COMMENT "广告id",
  `install_date` varchar(65533) NULL COMMENT "广告投放日期（西五区日期）字符串格式",
  `reg_num` bigint(20) NULL COMMENT "总注册人数",
  `reg_num_new` bigint(20) NULL COMMENT "纯新用户注册人数",
  `day0_amt_new` decimal(24, 8) NULL COMMENT "day0纯新用户收入（扣点后）,单位：美元",
  `day1_amt_new` decimal(24, 8) NULL COMMENT "day1纯新用户收入（扣点后）,单位：美元",
  `day2_amt_new` decimal(24, 8) NULL COMMENT "day2纯新用户收入（扣点后）,单位：美元",
  `day3_amt_new` decimal(24, 8) NULL COMMENT "day3纯新用户收入（扣点后）,单位：美元",
  `day4_amt_new` decimal(24, 8) NULL COMMENT "day4纯新用户收入（扣点后）,单位：美元",
  `day5_amt_new` decimal(24, 8) NULL COMMENT "day5纯新用户收入（扣点后）,单位：美元",
  `day6_amt_new` decimal(24, 8) NULL COMMENT "day6纯新用户收入（扣点后）,单位：美元",
  `day7_amt_new` decimal(24, 8) NULL COMMENT "day7纯新用户收入（扣点后）,单位：美元",
  `day0_amt` decimal(24, 8) NULL COMMENT "day0用户收入（扣点后）,单位：美元",
  `day1_amt` decimal(24, 8) NULL COMMENT "day1用户收入（扣点后）,单位：美元",
  `day2_amt` decimal(24, 8) NULL COMMENT "day2用户收入（扣点后）,单位：美元",
  `day3_amt` decimal(24, 8) NULL COMMENT "day3用户收入（扣点后）,单位：美元",
  `day4_amt` decimal(24, 8) NULL COMMENT "day4用户收入（扣点后）,单位：美元",
  `day5_amt` decimal(24, 8) NULL COMMENT "day5用户收入（扣点后）,单位：美元",
  `day6_amt` decimal(24, 8) NULL COMMENT "day6用户收入（扣点后）,单位：美元",
  `day7_amt` decimal(24, 8) NULL COMMENT "day7用户收入（扣点后）,单位：美元",
  `ios_day0_amt` decimal(24, 8) NULL COMMENT "ios day0用户收入（扣点后）,单位：美元",
  `ios_day0_amt_new` decimal(24, 8) NULL COMMENT "ios day0新用户收入（扣点后）,单位：美元",
  `reg_num_ios` bigint(20) NULL COMMENT "ios 注册人数",
  `reg_num_new_ios` bigint(20) NULL COMMENT "ios 纯新用户注册人数",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `md5_ad_id`)
COMMENT "广告推广纯新用户价值监控表"
DISTRIBUTED BY HASH(`product_id`, `md5_ad_id`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ad_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);