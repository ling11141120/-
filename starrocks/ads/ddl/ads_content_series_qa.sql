CREATE TABLE `ads_content_series_qa` (
  `series_id` bigint(20) NOT NULL COMMENT "剧集id",
  `type_id` int(11) NOT NULL COMMENT "类型: 1 QA   2 QC",
  `series_code` varchar(65533) NULL COMMENT "源剧代码",
  `series_name` varchar(65533) NULL COMMENT "短剧名",
  `putaway_date` datetime NULL COMMENT "上架时间",
  `auditor` varchar(200) NOT NULL COMMENT "审核员",
  `auditor_time` datetime NOT NULL COMMENT "QA/QC时间"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`, `type_id`)
COMMENT "内容域--短剧--QA/QC时间"
DISTRIBUTED BY HASH(`series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);