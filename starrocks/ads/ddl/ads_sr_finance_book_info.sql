CREATE TABLE `ads_sr_finance_book_info` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `product_type_name` varchar(50) NULL COMMENT "产品分类名称",
  `book_code` varchar(50) NULL COMMENT "书籍代号",
  `book_name` varchar(255) NULL COMMENT "书籍名称",
  `normal_chapter_num_f` int(11) NULL COMMENT "总章节数",
  `font_length` int(11) NULL COMMENT "总字数",
  `site_id2` int(11) NULL COMMENT "语言id",
  `site_name2` varchar(50) NULL COMMENT "语言名称",
  `site_id` int(11) NULL COMMENT "区分新掌中/凤鸣轩",
  `site_name` varchar(50) NULL COMMENT "区分新掌中/凤鸣轩",
  `new_cid` int(11) NULL COMMENT "分类id",
  `new_cname` varchar(255) NULL COMMENT "分类名称",
  `book_nature` int(11) NULL COMMENT "书籍类型id",
  `book_nature_name` varchar(255) NULL COMMENT "书籍类型名称",
  `author_id` int(11) NULL COMMENT "作者id",
  `author_name` varchar(255) NULL COMMENT "作者名称",
  `sexy2` int(11) NULL COMMENT "上下架id",
  `sexy2_status` varchar(50) NULL COMMENT "上下架状态",
  `build_time` date NULL COMMENT "上下架日期",
  `create_time` datetime NULL COMMENT "创建时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `book_id`)
COMMENT "海阅-财务书籍明细"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "2",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);