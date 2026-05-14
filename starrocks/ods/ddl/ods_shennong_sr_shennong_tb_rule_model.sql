CREATE TABLE `ods_shennong_sr_shennong_tb_rule_model` (
  `model` varchar(255) NOT NULL COMMENT "机型",
  `ruleId` varchar(255) NOT NULL COMMENT "命中规则",
  `updateTime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`model`, `ruleId`)
COMMENT "规则命中机型信息"
DISTRIBUTED BY HASH(`model`, `ruleId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
