CREATE TABLE `ads_bi_cv_advertise_spend_di` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `cost_amount` decimal(20, 6) NULL COMMENT "花费",
  `reg_num` bigint(20) NULL COMMENT "注册人数",
  `total_income` decimal(20, 6) NULL COMMENT "广告收入",
  `day0_income` decimal(20, 6) NULL COMMENT "day0广告收入+充值收入",
  `day0_roi` decimal(20, 4) NULL COMMENT "day0_roi,(day0广告收入+充值收入)/花费",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`)
COMMENT "国剧新增投放、广告相关"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);