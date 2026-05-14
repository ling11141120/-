CREATE TABLE `ads_sv_lookalike_user_label_di` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `login_days` bigint(20) NULL COMMENT "登录天数",
  `login_re` datetime NULL COMMENT "用户最近登录时间",
  `charge_re` datetime NULL COMMENT "用户最近充值时间",
  `first_recharge` decimal(20, 2) NULL COMMENT "首次充值金额",
  `total_recharge` decimal(20, 2) NULL COMMENT "累计充值金额",
  `recharge_avg` decimal(20, 2) NULL COMMENT "平均充值金额,用户充值成功的总金额/用户充值成功的总次数",
  `coin_consumption` decimal(20, 2) NULL COMMENT "用户消耗付费货币总额",
  `coin_cnt` decimal(20, 2) NULL COMMENT "用户在最近一次登录后的付费货币余额，（状态值，取跑数时对应的余额）",
  `total_consumption` bigint(20) NULL COMMENT "用户累计解锁的剧集数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "用户分群lookalike标签表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "etl_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);