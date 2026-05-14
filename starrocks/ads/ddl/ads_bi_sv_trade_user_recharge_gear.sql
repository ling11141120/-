CREATE TABLE `ads_bi_sv_trade_user_recharge_gear` (
  `dt` date NULL COMMENT "统计周期",
  `period_type` varchar(20) NULL COMMENT "统计周期类型,ctt/rmt,rmt(拉活用户)",
  `product_id` int(11) NULL COMMENT "产品id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `reg_language` int(11) NULL COMMENT "投放语言（注册语言）",
  `source_chl` varchar(1000) NULL COMMENT "最新渠道",
  `reg_country` varchar(65533) NULL COMMENT "注册国家",
  `country_level` varchar(65533) NULL COMMENT "国家等级,注册国家对应",
  `mt` int(11) NULL COMMENT "平台",
  `corever` int(11) NULL COMMENT "core",
  `user_type` varchar(50) NULL COMMENT "用户类型",
  `shop_item` varchar(65533) NULL COMMENT "充值类型",
  `recharge_gear` int(11) NULL COMMENT "充值档位（充值金额）",
  `is_first_charge` int(11) NULL COMMENT "是否首次充值 1：是 ，0：否",
  `vip_type` int(11) NULL COMMENT "vip类型,1 月卡 2 季卡 3 年卡 4 周卡",
  `charge_cnt` bigint(20) NULL COMMENT "充值次数",
  `before_charge` bigint(20) NULL COMMENT "充值金额（分成前）",
  `after_charge` decimal(18, 2) NULL COMMENT "充值金额（分成后）",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `period_type`, `product_id`, `user_id`)
COMMENT "交易域用户充值档位、结构表"
DISTRIBUTED BY HASH(`period_type`, `product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_type, mt, reg_language, corever, period_type",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);