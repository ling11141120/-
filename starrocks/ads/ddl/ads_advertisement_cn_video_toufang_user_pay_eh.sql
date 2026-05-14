CREATE TABLE `ads_advertisement_cn_video_toufang_user_pay_eh` (
  `ad_id` varchar(65533) NOT NULL COMMENT "广告id",
  `date_start` varchar(1048576) NOT NULL COMMENT "小时",
  `spend` decimal(38, 2) NULL COMMENT "投放金额h",
  `ad_name` varchar(65533) NULL COMMENT "广告计划名称",
  `account_id` varchar(65533) NULL COMMENT "账户id",
  `create_tm` varchar(1048576) NULL COMMENT "小时",
  `pay_amount` varchar(65533) NULL COMMENT "充值金额h",
  `nick_name` varchar(1048576) NULL COMMENT "姓名",
  `product_name` varchar(1048576) NULL COMMENT "账户名称",
  `campaign_name` varchar(128) NULL COMMENT "广告项目名称",
  `pay_rate` varchar(128) NULL COMMENT "小时ROI",
  `tf_h` varchar(128) NULL COMMENT "总消耗",
  `roi_rate` varchar(128) NULL COMMENT "规则ROI",
  `spend_sum` varchar(128) NULL COMMENT "",
  `pay_amount_sum` varchar(128) NULL COMMENT "总消耗",
  `sum_roi` varchar(128) NULL COMMENT "总ROI",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`ad_id`, `date_start`)
COMMENT "投放ROI报警"
DISTRIBUTED BY HASH(`ad_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);