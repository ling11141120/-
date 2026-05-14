CREATE TABLE `ads_sv_new_series_external_campaigns_parameter` (
  `id` int(11) NOT NULL COMMENT "配置id",
  `name` varchar(255) NOT NULL COMMENT "配置名称",
  `parameter_name` varchar(255) NOT NULL COMMENT "参数名称",
  `parameter_weight` int(11) NOT NULL COMMENT "参数权重(倒序权重，数字越小越优先)",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `name`, `parameter_name`)
COMMENT "海剧-自动化-新剧站外测投参数"
DISTRIBUTED BY HASH(`id`, `name`, `parameter_name`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);