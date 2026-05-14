CREATE TABLE `ads_sv_finance_series_info_1` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `series_code` varchar(50) NULL COMMENT "短剧代号",
  `series_name` varchar(1000) NULL COMMENT "短剧名称",
  `all_epis` int(11) NULL COMMENT "总集数",
  `language` int(11) NULL COMMENT "语言id",
  `language_name` varchar(50) NULL COMMENT "语言名称",
  `type_name` varchar(255) NULL COMMENT "分类名称",
  `rightsholder_id` bigint(20) NULL COMMENT "版权方id",
  `source_series_id` bigint(20) NULL COMMENT "源剧id",
  `source_series_name` varchar(255) NULL COMMENT "源剧名称",
  `source_language` int(11) NULL COMMENT "源剧语言id",
  `source_language_name` varchar(50) NULL COMMENT "源剧语言名称",
  `begin_date` date NULL COMMENT "源剧合作开始日期",
  `end_date` date NULL COMMENT "源剧合作结束日期",
  `publish_status` int(11) NULL COMMENT "上下架id",
  `publish_status_name` varchar(50) NULL COMMENT "上下架状态",
  `publish_edat` date NULL COMMENT "上下架日期",
  `local_type` int(11) NULL COMMENT "来源id",
  `local_type_name` varchar(50) NULL COMMENT "来源类型名称",
  `create_time` datetime NULL COMMENT "创建时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `series_id`)
COMMENT "海剧-财务短剧明细"
DISTRIBUTED BY HASH(`product_id`, `series_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "2",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);