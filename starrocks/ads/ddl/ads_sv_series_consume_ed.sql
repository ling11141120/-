CREATE TABLE `ads_sv_series_consume_ed` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `md5_key` varchar(65533) NOT NULL COMMENT "md5_key",
  `product_id` bigint(20) NULL COMMENT "产品id",
  `series_id` bigint(20) NULL COMMENT "视频id",
  `language` int(11) NULL COMMENT "语言",
  `series_ref_type_id` bigint(20) NULL COMMENT "剧分类id",
  `series_type_id` bigint(20) NULL COMMENT "剧集类型id",
  `consume_coin` bigint(20) NULL COMMENT "币消耗",
  `consume_bonus` bigint(20) NULL COMMENT "券消耗",
  `etl_time` datetime NULL COMMENT "处理时间",
  INDEX index_ProductId (`product_id`) USING BITMAP COMMENT 'index_product_id',
  INDEX index_language (`language`) USING BITMAP COMMENT 'index_language'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "海剧剧每天消费表"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "series_type_id, series_ref_type_id, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);