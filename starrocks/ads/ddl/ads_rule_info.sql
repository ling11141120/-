CREATE TABLE `ads_rule_info` (
  `batch` bigint(20) NOT NULL COMMENT "批次",
  `guize_id` bigint(20) NULL COMMENT "规则Id",
  `name` varchar(500) NULL COMMENT "规则名称",
  `type` varchar(500) NULL COMMENT "操作",
  `product` varchar(500) NULL COMMENT "项目",
  `target_type` varchar(500) NULL COMMENT "广告组别",
  `is_firstday` int(11) NULL COMMENT "广告开启日期",
  `language` varchar(500) NULL COMMENT "投放语言",
  `source` varchar(500) NULL COMMENT "媒体",
  `d1_min` decimal(12, 4) NULL COMMENT "",
  `d1_max` decimal(12, 4) NULL COMMENT "",
  `d2_min` decimal(12, 4) NULL COMMENT "",
  `d2_max` decimal(12, 4) NULL COMMENT "",
  `d3_min` decimal(12, 4) NULL COMMENT "",
  `d3_max` decimal(12, 4) NULL COMMENT "",
  `d4_min` decimal(12, 4) NULL COMMENT "",
  `d4_max` decimal(12, 4) NULL COMMENT "",
  `d5_min` decimal(12, 4) NULL COMMENT "",
  `d5_max` decimal(12, 4) NULL COMMENT "",
  `d6_min` decimal(12, 4) NULL COMMENT "",
  `d6_max` decimal(12, 4) NULL COMMENT "",
  `d7_min` decimal(12, 4) NULL COMMENT "",
  `d7_max` decimal(12, 4) NULL COMMENT "",
  `d8_min` decimal(12, 4) NULL COMMENT "",
  `d8_max` decimal(12, 4) NULL COMMENT "",
  `d9_min` decimal(12, 4) NULL COMMENT "",
  `d9_max` decimal(12, 4) NULL COMMENT "",
  `d10_min` decimal(12, 4) NULL COMMENT "",
  `d10_max` decimal(12, 4) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`batch`, `guize_id`)
COMMENT "规则"
DISTRIBUTED BY HASH(`batch`, `guize_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "guize_id, product, name, target_type, is_firstday, language, source, type",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);