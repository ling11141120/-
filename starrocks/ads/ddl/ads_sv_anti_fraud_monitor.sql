CREATE TABLE `ads_sv_anti_fraud_monitor` (
  `id` varchar(32) NOT NULL COMMENT "主键：md5(user_id+core)",
  `dt` date NULL COMMENT "首次触发日期",
  `user_id` bigint(20) NULL COMMENT "用户ID",
  `core` int(11) NULL COMMENT "core版本",
  `rule_type` int(11) NULL COMMENT "规则类型：1-广告频次异常",
  `trigger_value` int(11) NULL COMMENT "触发值（1分钟内最大广告次数）",
  `status` tinyint(4) NULL COMMENT "处理状态：0-待处理，1-已处理",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "ETL时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧-网赚防刷监控表"
DISTRIBUTED BY HASH(`id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);