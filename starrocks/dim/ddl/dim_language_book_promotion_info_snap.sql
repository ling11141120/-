CREATE TABLE `dim_language_book_promotion_info_snap` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` smallint(6) NOT NULL COMMENT "语言名称",
  `book_id` bigint(20) NOT NULL COMMENT "目标语言书籍id",
  `cname` varchar(65533) NULL COMMENT "中文书名",
  `from_book_Name` varchar(65533) NULL COMMENT "来源语言书籍名称",
  `to_book_name` varchar(65533) NULL COMMENT "目标语言书籍名称",
  `object_book_type` int(11) NULL COMMENT "图书书籍类型,0-网文 1-短剧",
  `is_cost_rate` int(11) NULL COMMENT "是否计算成本率,0-否 1-是",
  `promotion_tp` smallint(6) NULL COMMENT "推广类型:1-主推，2-测试推广，3-未推广",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_site_id (`site_id`) USING BITMAP COMMENT '语言id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `book_id`)
COMMENT "各语种翻译书籍维度表"
DISTRIBUTED BY HASH(`site_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);