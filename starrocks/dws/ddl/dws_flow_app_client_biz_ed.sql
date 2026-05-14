CREATE TABLE `dws_flow_app_client_biz_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `app_id` varchar(65533) NOT NULL COMMENT "app_id",
  `corever` varchar(1048576) NOT NULL COMMENT "core",
  `mt` varchar(1048576) NOT NULL COMMENT "设备",
  `product_id` varchar(1048576) NOT NULL COMMENT "产品id",
  `app_ver` varchar(65533) NOT NULL COMMENT "版本",
  `biz_type` varchar(65533) NOT NULL COMMENT "类型",
  `biz_book_id` varchar(65533) NOT NULL COMMENT "书籍id",
  `biz_chapter_id` varchar(65533) NOT NULL COMMENT "章节id",
  `cnt` bigint(20) NOT NULL COMMENT "数量",
  `etl` datetime NULL COMMENT "清洗时间 "
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `app_id`, `corever`, `mt`, `product_id`, `app_ver`, `biz_type`, `biz_book_id`, `biz_chapter_id`)
COMMENT "客户端上报错误"
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
