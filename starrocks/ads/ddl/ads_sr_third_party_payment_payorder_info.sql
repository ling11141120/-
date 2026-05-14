CREATE TABLE `ads_sr_third_party_payment_payorder_info` (
  `dt` date NOT NULL COMMENT "日期分区",
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `user_id` varchar(50) NOT NULL COMMENT "用户ID",
  `order_id` varchar(255) NOT NULL COMMENT "订单ID",
  `zffs` varchar(200) NULL COMMENT "本次支付方式-subpay_type匹配的二级渠道PaymentWay",
  `last_zffs` varchar(200) NULL COMMENT "上次支付方式-上次订单的subpay_type匹配的二级渠道",
  `core` varchar(50) NULL COMMENT "core版本",
  `mt` varchar(50) NULL COMMENT "终端",
  `shop_item` varchar(200) NULL COMMENT "充值类型",
  `package_id` varchar(200) NULL COMMENT "用于解析策略ID、充值来源",
  `sensors_data` varchar(2000) NULL COMMENT "用于解析策略ID、充值来源",
  `subscribe_status` int(11) NULL COMMENT "订阅状态-用于判断是否是续订",
  `reg_country` varchar(200) NULL COMMENT "国家",
  `user_type` varchar(200) NULL COMMENT "用户类型",
  `current_language2` int(11) NULL COMMENT "投放语言",
  `zffs_list` varchar(500) NULL COMMENT "本次zffs_list-曝光的支付方式列表(取前三位)",
  `next_zffs_list` varchar(500) NULL COMMENT "下次zffs_list-该用户下一笔订单匹配到的本次zffs_list",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `order_id`)
COMMENT "海阅三方支付曝光顺序链路报表-订单表"
PARTITION BY RANGE(`dt`)
(PARTITION p202511 VALUES [("2025-11-01"), ("2025-12-01")),
PARTITION p202512 VALUES [("2025-12-01"), ("2026-01-01")),
PARTITION p202601 VALUES [("2026-01-01"), ("2026-02-01")),
PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);