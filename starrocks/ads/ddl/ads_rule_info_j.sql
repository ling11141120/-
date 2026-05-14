CREATE TABLE `ads_rule_info_j` (
  `guize_id` bigint(20) NULL COMMENT "规则Id",
  `name` varchar(500) NULL COMMENT "规则名称",
  `type` varchar(500) NULL COMMENT "操作",
  `product` varchar(500) NULL COMMENT "项目",
  `target_type` varchar(500) NULL COMMENT "广告组别",
  `is_firstday` varchar(500) NULL COMMENT "广告开启日期",
  `language` varchar(500) NULL COMMENT "投放语言",
  `source` varchar(500) NULL COMMENT "媒体",
  `cac` varchar(1000) NULL COMMENT "今日达标率(广告组)",
  `r0` varchar(1000) NULL COMMENT "当日D0CAC(广告组)",
  `bf1_r0` varchar(1000) NULL COMMENT "昨日达标率(广告组)",
  `hn_regnum` varchar(1000) NULL COMMENT "付费人数(广告组)",
  `hn_cost` varchar(1000) NULL COMMENT "当日花费(广告组)",
  `hn_ib` varchar(1000) NULL COMMENT "初始预算(广告组)",
  `hn_ir` varchar(1000) NULL COMMENT "当日IR(广告组)",
  `hn_hour` varchar(1000) NULL COMMENT "投放时长(小时)(广告组)",
  `hn_payers` varchar(1000) NULL COMMENT "当日花费比例(广告组)",
  `d1` varchar(1000) NULL COMMENT "当日花费比例(广告组)"
) ENGINE=OLAP 
DUPLICATE KEY(`guize_id`)
COMMENT "规则"
DISTRIBUTED BY HASH(`guize_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);