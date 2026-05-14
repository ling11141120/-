CREATE TABLE `ads_bi_sv_recharge_detail_di` (
  `dt` date NOT NULL COMMENT "日期分区",
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `period_type` varchar(50) NOT NULL COMMENT "周期类型",
  `strategy_id` varchar(200) NOT NULL COMMENT "策略ID",
  `recharge_source` varchar(200) NOT NULL COMMENT "充值来源",
  `user_type` varchar(200) NULL COMMENT "用户类型",
  `put_language` varchar(50) NULL COMMENT "投放语言",
  `country_level` varchar(50) NULL COMMENT "国家等级",
  `mt` varchar(50) NULL COMMENT "终端",
  `corever` int(11) NULL COMMENT "core",
  `strategy_name` varchar(200) NULL COMMENT "策略名称",
  `strategy_weight` varchar(200) NULL COMMENT "策略权重",
  `strategy_code` varchar(200) NULL COMMENT "策略代号",
  `exposure_uv` int(11) NULL COMMENT "曝光UV",
  `exposure_pv` int(11) NULL COMMENT "曝光PV",
  `ad_exposure_uv` int(11) NULL COMMENT "广告曝光UV",
  `ad_exposure_pv` int(11) NULL COMMENT "广告曝光PV",
  `ad_amt` decimal(12, 6) NULL COMMENT "广告收益",
  `shop_item_type` varchar(500) NULL COMMENT "档位类型",
  `item_count` varchar(500) NULL COMMENT "充值档位",
  `recharge_un` int(11) NULL COMMENT "充值人数",
  `recharge_times` int(11) NULL COMMENT "充值次数",
  `recharge_amount` decimal(12, 2) NULL COMMENT "充值金额",
  `normal_recharge_amount` decimal(12, 2) NULL COMMENT "充值金额-普通充值",
  `signin_recharge_amount` decimal(12, 2) NULL COMMENT "充值金额-签到卡",
  `svip_recharge_amount` decimal(12, 2) NULL COMMENT "充值金额-SVIP",
  `normal_recharge_times` decimal(12, 2) NULL COMMENT "充值次数-普通充值",
  `signin_recharge_times` decimal(12, 2) NULL COMMENT "充值次数-签到卡",
  `svip_recharge_times` decimal(12, 2) NULL COMMENT "充值次数-SVIP",
  `normal_recharge_un` decimal(12, 2) NULL COMMENT "充值人数-普通充值",
  `signin_recharge_un` decimal(12, 2) NULL COMMENT "充值人数-签到卡",
  `svip_recharge_un` decimal(12, 2) NULL COMMENT "充值人数-SVIP",
  `recharge_un_subscription` decimal(12, 2) NULL COMMENT "充值人数-订阅",
  `etl_ime` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `period_type`, `strategy_id`, `recharge_source`)
COMMENT "海剧充值明细报表"
DISTRIBUTED BY HASH(`dt`, `period_type`, `strategy_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);