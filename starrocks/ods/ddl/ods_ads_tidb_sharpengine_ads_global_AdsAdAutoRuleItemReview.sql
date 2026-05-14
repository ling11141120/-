CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsAdAutoRuleItemReview` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `PlanId` bigint(20) NULL COMMENT "方案Id",
  `RuleId` bigint(20) NULL COMMENT "规则Id",
  `ItemType` int(11) NULL COMMENT "规则配置类型 0应用对象 1指标",
  `ItemKey` varchar(1000) NULL COMMENT "字段名",
  `ItemValue` varchar(30000) NULL COMMENT "字段值",
  `MinValue` varchar(1000) NULL COMMENT "最小值",
  `MaxValue` varchar(1000) NULL COMMENT "最大值",
  `DayValue` int(11) NULL COMMENT "Day N",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "复盘广告自动关闭规则配置项,author:102094"
DISTRIBUTED BY HASH(`Id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
