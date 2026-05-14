CREATE TABLE `dws_trade_short_video_subscribe_payorder_a` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `product_id` smallint(6) NOT NULL COMMENT "产品名称",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `total_subscribe_amt` decimal(24, 8) NULL COMMENT "累计订阅金额（不考虑退款因素）",
  `first_subscribe_amt` decimal(24, 8) NULL COMMENT "首次订阅金额",
  `first_subscribe_tp` smallint(6) NULL COMMENT "首次订阅类型",
  `first_subscribe_tm` datetime NULL COMMENT "首次订阅时间",
  `last_subscribe_amt` decimal(24, 8) NULL COMMENT "最后订阅金额",
  `last_subscribe_tp` smallint(6) NULL COMMENT "最后订阅类型",
  `last_subscribe_tm` datetime NULL COMMENT "最后订阅时间",
  `total_subscribe_cnt` bigint(20) NULL COMMENT "累计订阅次数（不考虑退款因素）",
  `total_subscribe_refund_cnt` bigint(20) NULL COMMENT "累计退订次数",
  `is_mul_subscribe` smallint(6) NULL COMMENT "有无多项订阅",
  `has_subscribe` bigint(20) NULL COMMENT "历史有无订阅",
  `first_recharge_amt` decimal(24, 8) NULL COMMENT "首次充值金额",
  `first_recharge_tm` datetime NULL COMMENT "首次充值时间",
  `total_recharge_amt` decimal(24, 8) NULL COMMENT "累计充值金额",
  `total_refund_amt` decimal(24, 8) NULL COMMENT "累计退款金额",
  `total_recharge_cnt` bigint(20) NULL COMMENT "累计充值次数",
  `total_refund_cnt` bigint(20) NULL COMMENT "累计退款次数",
  `recharge_avg` decimal(24, 8) NULL COMMENT "平均充值金额",
  `recharge_max` bigint(20) NULL COMMENT "最大充值金额",
  `month_recharge_max` bigint(20) NULL COMMENT "近一个月最大充值金额",
  `last_recharge_amt` bigint(20) NULL COMMENT "最后充值金额",
  `last_recharge_tm` datetime NULL COMMENT "最近充值时间",
  `charge_mode` bigint(20) NULL COMMENT "充值众数（不考虑退款因素）",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海外短剧交易域用户粒度订阅充值累计表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 210 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
