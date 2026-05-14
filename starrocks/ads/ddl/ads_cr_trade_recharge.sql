CREATE TABLE `ads_cr_trade_recharge` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `date_types` varchar(50) NOT NULL COMMENT "统计类型,today:当日充值，last_day：昨日同期充值，cur_month：本月充值，last_month：上月同期充值，cur_quarter：本季度充值，last_quarter：上季度同期充值，last_whole_quarter：上季度总充值",
  `self_type` smallint(6) NOT NULL COMMENT "自营类别 0：总 ",
  `charge_amt` decimal(10, 2) NULL DEFAULT "0" COMMENT "分成后(指扣完支付渠道手续费的)充值金额-美元",
  `charge_amt_rmb` decimal(10, 2) NULL DEFAULT "0" COMMENT "分成后(指扣完支付渠道手续费的)充值金额-人民币",
  `charge_cnt` int(11) NULL DEFAULT "0" COMMENT "充值次数",
  `charge_unt` int(11) NULL DEFAULT "0" COMMENT "充值人数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `date_types`, `self_type`)
COMMENT "国阅小程序阅读 按日 按月 按季度实时查询充值数据"
DISTRIBUTED BY HASH(`product_id`, `date_types`, `self_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);