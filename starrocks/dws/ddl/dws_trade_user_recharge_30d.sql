CREATE TABLE `dws_trade_user_recharge_30d` (
  `month` int(11) NOT NULL COMMENT "createtime获取对应month",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NOT NULL COMMENT "corever",
  `current_language` int(11) NOT NULL COMMENT "当前语言",
  `current_language2` int(11) NOT NULL COMMENT "注册时语言",
  `appver` varchar(50) NOT NULL COMMENT "版本号",
  `mt` int(11) NOT NULL COMMENT "平台",
  `ver` varchar(50) NOT NULL COMMENT "服务端版本号",
  `reg_country` varchar(50) NOT NULL COMMENT "注册时国家",
  `shop_item` varchar(128) NOT NULL COMMENT "充值类型（0，普通充值，800签到卡，801，802月卡，810vip会员卡，830福利包，840新福利包)",
  `subpay_type` varchar(50) NOT NULL COMMENT "支付渠道",
  `daysnum` int(11) NULL COMMENT "当月的天数",
  `charge_money` decimal(20, 6) NULL COMMENT "分成后充值金额",
  `charge_itemcount` int(11) NULL COMMENT "分成前充值金额",
  `charge_count` int(11) NULL COMMENT "充值次数",
  `new_charge_count` int(11) NULL COMMENT "当月新增用户的充值人数",
  `new_charge_money` decimal(20, 6) NULL COMMENT "当月新增用户的分成后充值金额",
  `new_charge_itemcount` int(11) NULL COMMENT "当月新增用户的分成前充值金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`month`, `product_id`, `corever`, `current_language`, `current_language2`, `appver`, `mt`, `ver`, `reg_country`, `shop_item`, `subpay_type`)
COMMENT "用户充值30日统计表"
DISTRIBUTED BY HASH(`month`, `product_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
