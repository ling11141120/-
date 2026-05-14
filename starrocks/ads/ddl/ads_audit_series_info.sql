CREATE TABLE `ads_audit_series_info` (
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `source_series_id` bigint(20) NULL COMMENT "源剧id",
  `series_name` varchar(500) NULL COMMENT "短剧名称",
  `series_code` varchar(500) NULL COMMENT "短剧代号",
  `series_type` varchar(500) NULL COMMENT "短剧分类",
  `publish_time` datetime NULL COMMENT "上架时间",
  `publish_status` int(11) NULL COMMENT "上架状态",
  `ending` int(11) NULL COMMENT "是否完结（连载中 已完结）",
  `last_epis` int(11) NULL COMMENT "发布剧集数",
  `source` varchar(500) NULL COMMENT "来源",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`series_id`)
COMMENT "moboreader审计短剧库"
DISTRIBUTED BY HASH(`series_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);