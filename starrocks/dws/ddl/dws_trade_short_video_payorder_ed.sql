CREATE TABLE `dws_trade_short_video_payorder_ed` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `product_id` smallint(6) NOT NULL COMMENT "产品名称",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `pay_amt` decimal(24, 8) NULL COMMENT "分成前总充值（不考虑退款因素）",
  `received_amt` decimal(24, 8) NULL COMMENT "分成后总充值（不考虑退款因素）",
  `refund_amt` decimal(24, 8) NULL COMMENT "总退款(分成前,存在跨天退款的情况)",
  `refund_real_amt` decimal(24, 8) NULL COMMENT "总退款(分成后，存在跨天退款的情况)",
  `pay_cnt` bigint(20) NULL COMMENT "总充值次数（不考虑退款因素）",
  `refund_cnt` bigint(20) NULL COMMENT "总退款次数",
  `max_pay_amt` decimal(24, 8) NULL COMMENT "当天的分成前最大充值金额（不考虑退款因素)",
  `min_pay_amt` decimal(24, 8) NULL COMMENT "当天的分成前最小充值金额（不考虑退款因素）",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海外短剧交易域用户粒度剧集充值1日汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
