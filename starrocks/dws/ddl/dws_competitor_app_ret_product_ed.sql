CREATE TABLE `dws_competitor_app_ret_product_ed` (
  `dt` date NOT NULL COMMENT "",
  `country_code` varchar(65533) NOT NULL COMMENT "国家码",
  `device_code` varchar(65533) NOT NULL COMMENT "设备码",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `retention_days` bigint(20) NOT NULL COMMENT "留存天数",
  `product_name` varchar(65533) NULL COMMENT "产品名称",
  `unified_product_name` varchar(65533) NULL COMMENT "统一产品名",
  `Id` bigint(20) NOT NULL COMMENT "",
  `granularity` varchar(65533) NOT NULL COMMENT "时间维度",
  `end_date` datetime NOT NULL COMMENT "",
  `est_retention_value` decimal(15, 6) NULL COMMENT "留存率",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `country_code`, `device_code`, `product_id`, `retention_days`)
COMMENT "app统计留存数表_添加了产品名称"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
