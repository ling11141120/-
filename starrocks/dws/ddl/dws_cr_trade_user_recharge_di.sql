CREATE TABLE `dws_cr_trade_user_recharge_di` (
  `dt` date NOT NULL COMMENT "日期，根据createtime转化",
  `product_id` bigint(20) NOT NULL COMMENT "充值产品编号",
  `user_id` varchar(65533) NOT NULL COMMENT "用户id",
  `self_type` smallint(6) NOT NULL COMMENT "自营类别 0：总 ",
  `shop_item` varchar(255) NOT NULL COMMENT "充值项",
  `app_id` varchar(65533) NULL COMMENT "小程序id",
  `plat_form` varchar(65533) NULL COMMENT "平台：weixin - 微信，toutiao - 抖音, 默认 none",
  `corever2` int(11) NULL COMMENT "core",
  `current_language2` int(11) NULL COMMENT "当前语言",
  `mt2` int(11) NULL COMMENT "设备",
  `reg_country` varchar(65533) NULL COMMENT "注册时国家",
  `reg_tm` date NULL COMMENT "注册日期",
  `chl2` varchar(65533) NULL COMMENT "来源",
  `os` varchar(255) NULL COMMENT "系统",
  `fst_charge_date` date NULL COMMENT "首充日期",
  `fst_charge_amt` decimal(24, 6) NULL COMMENT "首充金额，美元(分成后(指扣完支付渠道手续费的)，汇率按1：7)",
  `re_days` int(11) NULL COMMENT "距离首充天数",
  `reg_days` int(11) NULL COMMENT "距离注册天数",
  `charge_amt` decimal(24, 6) NULL COMMENT "分成后(指扣完支付渠道手续费的)充值金额-美元",
  `charge_amt_rmb` decimal(24, 6) NULL COMMENT "分成后(指扣完支付渠道手续费的)充值金额-人民币",
  `charge_cnt` int(11) NULL COMMENT "充值次数",
  `charge_item_amt` decimal(24, 6) NULL COMMENT "分成前充值金额(美金，汇率按1：7)",
  `etl_tm` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `self_type`, `shop_item`)
COMMENT "国内小程序阅读-交易域用户充值每日汇总表"
DISTRIBUTED BY HASH(`product_id`, `user_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
