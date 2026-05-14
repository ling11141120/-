CREATE TABLE `dws_trade_short_video_user_payorder_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `sex` int(11) NULL COMMENT "性别",
  `mt` int(11) NULL COMMENT "最新平台号,1为ios 4为安卓",
  `source_chl` varchar(1000) NULL COMMENT "渠道值",
  `corever` int(11) NULL COMMENT "core,默认1",
  `current_language2` int(11) NULL COMMENT "包初始语言",
  `current_language` int(11) NULL COMMENT "最新用户使用语言",
  `reg_country` varchar(1000) NULL COMMENT "注册国家",
  `ad_quality` int(11) NULL COMMENT "归因用户质量",
  `first_recharge` int(11) NULL COMMENT "当天首充金额",
  `first_recharge_tm` datetime NULL COMMENT "当天首充时间",
  `last_recharge` int(11) NULL COMMENT "当天最后充值金额",
  `last_recharge_tm` datetime NULL COMMENT "当天最后充值时间",
  `max_recharge` int(11) NULL COMMENT "当天最大充值金额",
  `sum_recharge` bigint(20) NULL COMMENT "当天总充值金额",
  `sum_base_amount` bigint(20) NULL COMMENT "分成后的金额",
  `cnt_recharge` bigint(20) NULL COMMENT "当天充值次数",
  `first_ref_recharge` int(11) NULL COMMENT "当天首充退款金额",
  `first_ref_recharge_tm` datetime NULL COMMENT "当天首充退款时间",
  `last_ref_recharge` int(11) NULL COMMENT "当天最后退款金额",
  `last_ref_recharge_tm` datetime NULL COMMENT "当天最后退款时间",
  `max_ref_recharge` int(11) NULL COMMENT "当天最大退款金额",
  `sum_ref_recharge` bigint(20) NULL COMMENT "当天退款总金额",
  `cnt_ref_recharge` bigint(20) NULL COMMENT "当天退款次数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "短剧 用户充值每天汇总表"
DISTRIBUTED BY HASH(`dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
