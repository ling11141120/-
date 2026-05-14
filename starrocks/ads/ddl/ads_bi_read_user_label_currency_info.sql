CREATE TABLE `ads_bi_read_user_label_currency_info` (
  `dt` date NOT NULL COMMENT "活跃时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_tps` int(11) NOT NULL COMMENT "用户类型 1:新用户,2:rmt用户,3:老用户,4:无登录行为用户",
  `core` int(11) NOT NULL COMMENT "corever",
  `user_attribute` int(11) NOT NULL COMMENT "用户属性 1:svip用户,2:白嫖用户,3:普通用户",
  `unt` bitmap NULL COMMENT "用户数量",
  `pay_amt` int(11) NULL COMMENT "分成前充值总额",
  `grant_money_amt` int(11) NULL COMMENT "发放阅币数量",
  `grant_gift_amt` int(11) NULL COMMENT "发放礼券数量",
  `exp_gift_amt` int(11) NULL COMMENT "过期礼券数量",
  `csm_amt` decimal(18, 6) NULL COMMENT "消耗阅币数量",
  `csm_gift_amt` decimal(18, 6) NULL COMMENT "消耗礼券数量",
  `etl_tm` datetime NULL COMMENT "清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_tps`, `core`, `user_attribute`)
COMMENT "阅读-按天、不同用户类型的阅币、礼券充值发放消耗过期汇总数据"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);