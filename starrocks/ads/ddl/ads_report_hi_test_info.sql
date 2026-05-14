CREATE TABLE `ads_report_hi_test_info` (
  `dt` date NOT NULL COMMENT "事件分区",
  `product_id` int(11) NULL COMMENT "产品id",
  `corever` int(11) NULL COMMENT "corever",
  `mt` int(11) NULL COMMENT "终端",
  `reg_country` varchar(512) NULL COMMENT "手机串码",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `message` varchar(512) NULL COMMENT "high点测试信息",
  `chapter_id` bigint(20) NULL COMMENT "书籍章节id",
  `chapter_index` int(11) NULL COMMENT "章节序号",
  `item_id` int(11) NULL COMMENT "配置id，开发用来识别哪个配置的",
  `tag_num` int(11) NULL COMMENT "目标用户数",
  `read_num` int(11) NULL COMMENT "阅读人数",
  `con_num` int(11) NULL COMMENT "消耗人数",
  `amount` decimal(10, 4) NULL COMMENT "消耗数额",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "simple后台 hi点测试报表 黄文"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);