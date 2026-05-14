CREATE TABLE `dim_middleman_rate` (
  `middleman_id` varchar(65533) NOT NULL COMMENT "机构id",
  `cdreader_rate` decimal(24, 6) NULL COMMENT "扣除机构分成后畅读分层",
  `middleman_type` smallint(6) NULL COMMENT "机构类型，1：畅读自身；2：分销机构",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`middleman_id`)
COMMENT "机构维度表"
DISTRIBUTED BY HASH(`middleman_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "middleman_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);