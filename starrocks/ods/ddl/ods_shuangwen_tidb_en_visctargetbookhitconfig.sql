CREATE TABLE `ods_shuangwen_tidb_en_visctargetbookhitconfig` (
  `Id` int(11) NOT NULL COMMENT "编号",
  `ConfigYear` int(11) NOT NULL COMMENT "年份",
  `ConfigMonth` int(11) NULL COMMENT "年份",
  `ConfigType` int(11) NOT NULL COMMENT "0 爆款书 1爆款代号",
  `ConfigTarget` int(11) NULL COMMENT "目标",
  `SpendMetrics` decimal(18, 0) NULL COMMENT "花费指标-美金",
  `AddTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `DelStatus` int(11) NOT NULL COMMENT "是否删除 1是",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "爆款书/代号目标配置表,author:272516"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
