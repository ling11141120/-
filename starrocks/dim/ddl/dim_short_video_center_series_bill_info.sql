CREATE TABLE `dim_short_video_center_series_bill_info` (
  `product_id` int(11) NOT NULL COMMENT "产品id：6833",
  `bill_id` bigint(20) NOT NULL COMMENT "书单id(剧目id)",
  `Weight` int(11) NULL COMMENT "权重",
  `begin_time` datetime NULL COMMENT "推荐开始时间",
  `end_time` datetime NULL COMMENT "推荐结束时间",
  `lang_id` int(11) NULL COMMENT "语言",
  `del_status` tinyint(4) NULL COMMENT "是否删除",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `series_id` bigint(20) NULL COMMENT "剧集id",
  `name` varchar(100) NULL COMMENT "名称",
  `bill_type` int(11) NULL COMMENT "书单类型（1：通用）",
  `etl_tm` datetime NULL COMMENT "更新时间",
  INDEX index_LangId (`lang_id`) USING BITMAP COMMENT 'index_LangId'
) ENGINE=OLAP 
DUPLICATE KEY(`product_id`, `bill_id`)
COMMENT "海外短剧-剧目单明细"
DISTRIBUTED BY HASH(`product_id`, `bill_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "bill_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);