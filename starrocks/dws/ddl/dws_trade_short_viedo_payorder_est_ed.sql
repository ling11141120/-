CREATE TABLE `dws_trade_short_viedo_payorder_est_ed` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `md5_key` varchar(65533) NOT NULL COMMENT "主键",
  `corever` int(11) NULL COMMENT "corever",
  `current_language` int(11) NULL COMMENT "当前语言",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `mt` int(11) NULL COMMENT "平台",
  `reg_country` varchar(50) NULL COMMENT "注册时国家",
  `reg_time` datetime NULL COMMENT "用户注册时间",
  `sub_pay_type` varchar(50) NULL COMMENT "支付渠道",
  `first_charge_day` date NULL COMMENT "首充日期",
  `first_charge_money` decimal(18, 4) NULL COMMENT "首充金额",
  `re_days` int(11) NULL COMMENT "首充天数（充值时间-首次充值时间）",
  `reg_days` int(11) NULL COMMENT "付费留存天数（充值时间-注册时间）",
  `charge_money` decimal(18, 4) NULL COMMENT "分成后充值金额",
  `charge_count` int(11) NULL COMMENT "充值次数",
  `charge_itemcount` int(11) NULL COMMENT "分成前充值金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `md5_key`)
COMMENT "按天轻度汇总表：短剧用户充值统计表(西五区)"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
