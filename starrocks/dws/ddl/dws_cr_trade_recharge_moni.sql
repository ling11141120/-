CREATE TABLE `dws_cr_trade_recharge_moni` (
  `month` int(11) NOT NULL COMMENT "createtime获取对应month",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `self_type` smallint(6) NOT NULL COMMENT "自营类别 0：总 ",
  `shop_item` varchar(255) NOT NULL COMMENT "充值项",
  `app_id` varchar(65533) NOT NULL COMMENT "小程序id",
  `plat_form` varchar(65533) NOT NULL COMMENT "平台：weixin - 微信，toutiao - 抖音, 默认 none",
  `corever2` int(11) NOT NULL COMMENT "core",
  `current_language2` int(11) NOT NULL COMMENT "注册时语言",
  `mt2` int(11) NOT NULL COMMENT "设备",
  `reg_country` varchar(65533) NOT NULL COMMENT "注册时国家",
  `os` varchar(255) NOT NULL COMMENT "系统",
  `daysnum` int(11) NULL COMMENT "当月的天数",
  `charge_amt` decimal(24, 6) NULL COMMENT "分成后(指扣完支付渠道手续费的)充值金额-美元",
  `charge_amt_rmb` decimal(24, 6) NULL COMMENT "分成后(指扣完支付渠道手续费的)充值金额-人民币",
  `charge_item_amt` decimal(24, 6) NULL COMMENT "分成前充值金额(美金，汇率按1：7)",
  `charge_cnt` int(11) NULL COMMENT "充值次数",
  `new_charge_cnt` int(11) NULL COMMENT "当月新增用户的充值次数",
  `new_charge_amt` decimal(20, 6) NULL COMMENT "当月新增用户的分成后充值金额",
  `new_charge_item_amt` int(11) NULL COMMENT "当月新增用户的分成前充值金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`month`, `product_id`, `self_type`, `shop_item`, `app_id`, `plat_form`, `corever2`, `current_language2`, `mt2`, `reg_country`, `os`)
COMMENT "国内小程序阅读-按月充值统计表"
DISTRIBUTED BY HASH(`month`, `product_id`, `self_type`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);
