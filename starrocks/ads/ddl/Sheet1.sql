CREATE TABLE `Sheet1` (
  `短剧代号` varchar(255) NULL COMMENT "",
  `短剧名称` varchar(255) NULL COMMENT "",
  `来源` varchar(255) NULL COMMENT "",
  `拍摄费用USD` double NULL COMMENT "",
  `拍摄完成日期` date NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`短剧代号`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);