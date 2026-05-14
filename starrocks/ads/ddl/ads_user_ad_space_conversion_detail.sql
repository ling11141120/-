CREATE TABLE `ads_user_ad_space_conversion_detail` (
  `dt` datetime NOT NULL COMMENT "时间",
  `login_id` varchar(60) NOT NULL COMMENT "登录id",
  `ad_position_id` varchar(60) NULL COMMENT "广告位id",
  `ad_strategy_id` varchar(60) NULL COMMENT "ad_strategy_id",
  `main_strategy_id` varchar(60) NULL COMMENT "使用类型",
  `event` varchar(60) NULL COMMENT "event",
  `ad_type` varchar(60) NULL COMMENT "广告类型",
  `impression_pv` int(11) NULL COMMENT "曝光pv",
  `click_pv` int(11) NULL COMMENT "点击pv",
  `ad_revenue_amount` decimal(12, 6) NULL COMMENT "广告收益",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `login_id`)
COMMENT "用户广告位转化明细"
DISTRIBUTED BY HASH(`login_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);