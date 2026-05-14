CREATE TABLE `ads_trade_month_recharge_toufang` (
  `month` int(11) NOT NULL COMMENT "月份",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `charge_money` decimal(20, 6) NULL COMMENT "分成后充值金额",
  `charge_itemcount` int(11) NULL COMMENT "分成前充值金额",
  `Spend` decimal(20, 6) NULL COMMENT "投放金额(推广费用)",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`month`, `product_id`)
COMMENT "混合域每月充值投放指标表"
DISTRIBUTED BY HASH(`month`, `product_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);