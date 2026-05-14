CREATE TABLE `ads_ad_user_space_conversion` (
  `dt` datetime NOT NULL COMMENT "时间",
  `login_id` varchar(60) NOT NULL COMMENT "登录id",
  `ad_position_id` varchar(60) NULL COMMENT "广告位id",
  `ad_strategy_id` varchar(60) NULL COMMENT "ad_strategy_id",
  `main_strategy_id` varchar(60) NULL COMMENT "使用类型",
  `ad_type` varchar(60) NULL COMMENT "广告类型",
  `period_type` varchar(60) NULL COMMENT "周期类型",
  `user_type` varchar(60) NULL COMMENT "用户类型",
  `put_language` varchar(60) NULL COMMENT "投放语言",
  `country_leve` varchar(60) NULL COMMENT "国家等级",
  `mt` varchar(60) NULL COMMENT "终端",
  `corever` varchar(60) NULL COMMENT "core",
  `impression_pv` int(11) NULL COMMENT "曝光pv",
  `click_pv` int(11) NULL COMMENT "点击pv",
  `watch_completion_pv` int(11) NULL COMMENT "观看完成pv",
  `ad_revenue_amount` decimal(12, 6) NULL COMMENT "广告收益",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `login_id`)
COMMENT "用户广告位转化明细"
DISTRIBUTED BY HASH(`login_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);