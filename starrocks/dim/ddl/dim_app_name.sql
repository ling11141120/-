CREATE TABLE `dim_app_name` (
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `core_version` int(11) NOT NULL COMMENT "核心版本",
  `app_name` varchar(255) NOT NULL COMMENT "APP名称",
  `language_name` varchar(100) NOT NULL COMMENT "语言名称",
  `remark` varchar(255) NULL COMMENT "说明"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `core_version`)
COMMENT "app应用名称维表"
DISTRIBUTED BY HASH(`product_id`, `core_version`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);