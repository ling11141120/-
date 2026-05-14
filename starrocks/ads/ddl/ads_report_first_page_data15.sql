CREATE TABLE `ads_report_first_page_data15` (
  `create_date` date NULL COMMENT "日期",
  `dau` bigint(20) NULL COMMENT "dau",
  `new_num` bigint(20) NULL COMMENT "新增用户",
  `charge_num` bigint(20) NULL COMMENT "充值人数",
  `charge_money` decimal(20, 4) NULL COMMENT "充值金额",
  `first_charge_num` bigint(20) NULL COMMENT "首充用户数",
  `new_charge_money` decimal(20, 4) NULL COMMENT "新增付费用户充值总额",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`create_date`)
COMMENT "沙盘--首页--数据集15"
DISTRIBUTED BY HASH(`create_date`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_date",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);