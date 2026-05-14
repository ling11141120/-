CREATE TABLE `ads_cr_recharge_cost_moni` (
  `month` int(11) NOT NULL COMMENT "createtime获取对应month",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `charge_amt` decimal(24, 6) NULL DEFAULT "0" COMMENT "分成后指扣完支付渠道手续费的)充值金额-美元",
  `charge_amt_rmb` decimal(24, 6) NULL DEFAULT "0" COMMENT "分成后指扣完支付渠道手续费的)充值金额-人民币",
  `charge_item_amt` decimal(24, 6) NULL DEFAULT "0" COMMENT "分成前充值金额(美金，汇率按1：7)",
  `cost_amt` decimal(24, 6) NULL DEFAULT "0" COMMENT "投放花费",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`month`, `product_id`)
COMMENT "国内小程序阅读-按月充值投放统计表"
DISTRIBUTED BY HASH(`month`, `product_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);