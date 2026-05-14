CREATE TABLE `ads_cv_gdt_ad_roi_warning` (
  `stat_date_h` datetime NOT NULL COMMENT "统计区间,开始时间",
  `ad_id` varchar(500) NOT NULL COMMENT "广告id",
  `ad_name` varchar(500) NULL COMMENT "广告名",
  `nick_name` varchar(500) NULL COMMENT "昵称",
  `product_name` varchar(500) NULL COMMENT "产品",
  `campaign_name` varchar(500) NULL COMMENT "活动名称",
  `account_id` varchar(500) NULL COMMENT "账户id",
  `ding_user_id` varchar(500) NULL COMMENT "钉钉账户id",
  `bf_1_h_start` datetime NULL COMMENT "前1小时区间开始时间",
  `bf_1_h_end` datetime NULL COMMENT "前1小时区间结束时间",
  `bf_1_h_consume` decimal(20, 4) NULL COMMENT "前1小时区间消耗",
  `bf_1_h_ad_income` decimal(20, 4) NULL COMMENT "前1小时区间广告收入",
  `bf_1_h_ad_roi` decimal(20, 4) NULL COMMENT "前1小时区间广告ROI",
  `bf_1_h_recharge_income` decimal(20, 4) NULL COMMENT "前1小时区间充值收入",
  `bf_1_h_recharge_roi` decimal(20, 4) NULL COMMENT "前1小时区间充值ROI",
  `bf_2_h_start` datetime NULL COMMENT "前2小时区间开始时间",
  `bf_2_h_end` datetime NULL COMMENT "前2小时区间结束时间",
  `bf_2_h_consume` decimal(20, 4) NULL COMMENT "前2小时区间消耗",
  `bf_2_h_ad_income` decimal(20, 4) NULL COMMENT "前2小时区间广告收入",
  `bf_2_h_ad_roi` decimal(20, 4) NULL COMMENT "前2小时区间广告ROI",
  `bf_2_h_recharge_income` decimal(20, 4) NULL COMMENT "前2小时区间充值收入",
  `bf_2_h_recharge_roi` decimal(20, 4) NULL COMMENT "前2小时区间充值ROI",
  `bf_3_h_start` datetime NULL COMMENT "前3小时区间开始时间",
  `bf_3_h_end` datetime NULL COMMENT "前3小时区间结束时间",
  `bf_3_h_consume` decimal(20, 4) NULL COMMENT "前3小时区间消耗",
  `bf_3_h_ad_income` decimal(20, 4) NULL COMMENT "前3小时区间广告收入",
  `bf_3_h_ad_roi` decimal(20, 4) NULL COMMENT "前3小时区间广告ROI",
  `bf_3_h_recharge_income` decimal(20, 4) NULL COMMENT "前3小时区间充值收入",
  `bf_3_h_recharge_roi` decimal(20, 4) NULL COMMENT "前3小时区间充值ROI",
  `day_consume` decimal(20, 4) NULL COMMENT "当日消耗",
  `day_ad_income` decimal(20, 4) NULL COMMENT "当日广告收入",
  `day_ad_roi` decimal(20, 4) NULL COMMENT "当日广告ROI",
  `day_recharge_income` decimal(20, 4) NULL COMMENT "当日充值收入",
  `day_recharge_roi` decimal(20, 4) NULL COMMENT "当日充值ROI",
  `etl_tm` datetime NULL COMMENT "数据etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`stat_date_h`, `ad_id`)
COMMENT "国剧--腾讯广点通广告ROI告警"
DISTRIBUTED BY HASH(`stat_date_h`, `ad_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ad_id, stat_date_h",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);