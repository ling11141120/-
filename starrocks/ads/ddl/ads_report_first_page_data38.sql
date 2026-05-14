CREATE TABLE `ads_report_first_page_data38` (
  `date_types` int(11) NOT NULL COMMENT "日期类型",
  `charge_money` decimal(20, 2) NULL COMMENT "充值金额（美元）",
  `charge_money_rmb` decimal(20, 2) NULL COMMENT "充值金额（人民币）",
  `charge_order` bigint(20) NULL COMMENT "充值的订单数",
  `charge_num` bigint(20) NULL COMMENT "充值的人数",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`date_types`)
COMMENT "沙盘--首页--数据集38"
DISTRIBUTED BY HASH(`date_types`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "date_types",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);