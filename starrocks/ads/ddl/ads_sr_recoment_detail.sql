CREATE TABLE `ads_sr_recoment_detail` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "",
  `book_id` bigint(20) NOT NULL COMMENT "书本id",
  `language` int(11) NOT NULL COMMENT "语言",
  `title` varchar(600) NULL COMMENT "标题",
  `recomment_order` int(11) NULL COMMENT "推荐顺序",
  `update_time` datetime NULL COMMENT "更新时间",
  `publish_time` datetime NULL COMMENT "发布时间",
  `position_id` bigint(20) NULL COMMENT "书籍位置id",
  `is_delete` int(11) NULL COMMENT "是否删除",
  `row_update_time` datetime NULL COMMENT "行更新信息",
  `sync_language` varchar(600) NULL COMMENT "无用",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `id`, `book_id`, `language`)
DISTRIBUTED BY HASH(`product_id`, `id`, `book_id`, `language`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);