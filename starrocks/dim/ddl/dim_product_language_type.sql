CREATE TABLE `dim_product_language_type` (
  `id` int(11) NOT NULL COMMENT "主键id",
  `product_id` int(11) NULL COMMENT "产品id",
  `product_name` varchar(50) NULL COMMENT "产品名称",
  `lang_id` int(11) NULL COMMENT "语言id",
  `site_id` int(11) NULL COMMENT "书籍语言id",
  `lang_code` varchar(50) NULL COMMENT "语言简写",
  `lang_name` varchar(50) NULL COMMENT "语言名称",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "产品-语言类型"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);