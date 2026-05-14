CREATE TABLE `ads_srsv_cpm_ir_conversion_formula_parameter` (
  `project` varchar(200) NULL COMMENT "项目类型 海阅|海剧",
  `project_code` int(11) NULL COMMENT "项目类型 1=海阅|2=海剧",
  `source` varchar(200) NULL COMMENT "来源",
  `mt` int(11) NULL COMMENT "mt",
  `language_name` varchar(200) NULL COMMENT "语言名称",
  `language_id` int(11) NULL COMMENT "语言id",
  `language` varchar(200) NULL COMMENT "语言简称",
  `formula` varchar(500) NULL COMMENT "",
  `func` varchar(500) NULL COMMENT "",
  `cpm_limit` varchar(500) NULL COMMENT "",
  `a` decimal(12, 6) NULL COMMENT "",
  `b` decimal(12, 6) NULL COMMENT "",
  `X_start` int(11) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`project`, `project_code`)
COMMENT "CPM_IR转化公式参数"
DISTRIBUTED BY HASH(`project`, `project_code`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);