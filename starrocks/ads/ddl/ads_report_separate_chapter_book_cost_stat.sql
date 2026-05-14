CREATE TABLE `ads_report_separate_chapter_book_cost_stat` (
  `dt` date NOT NULL COMMENT "年分区字段：日期",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `root_book_id` bigint(20) NULL COMMENT "book_id的根书籍id",
  `book_name` varchar(65533) NULL COMMENT "中文书名",
  `book_code` varchar(50) NULL COMMENT "书籍代号",
  `origin_book_name` varchar(65533) NULL COMMENT "源书书名",
  `object_book_name` varchar(65533) NULL COMMENT "目标书名",
  `if_root_book` int(11) NULL COMMENT "是否是根书 1是 0否",
  `publish_length` bigint(20) NULL COMMENT "发布字数",
  `cost_amt_7` decimal(18, 4) NULL COMMENT "近7天成本金额，单位：人民币",
  `amount_7` decimal(18, 4) NULL COMMENT "近7天收入，单位：人民币",
  `cost_amt_30` decimal(18, 4) NULL COMMENT "近30天成本金额，单位：人民币",
  `amount_30` decimal(18, 4) NULL COMMENT "近30天收入，单位：人民币",
  `cost_amt_curmon` decimal(18, 4) NULL COMMENT "本月成本金额，单位：人民币",
  `amount_curmon` decimal(18, 4) NULL COMMENT "本月收入，单位：人民币",
  `separate_chapter_book_income` decimal(18, 4) NULL COMMENT "拆章书本月收入，单位：人民币",
  `cost_amt_YTD` decimal(18, 4) NULL COMMENT "累计成本金额，单位：人民币",
  `amount_YTD` decimal(18, 4) NULL COMMENT "累计收入，单位：人民币",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `book_id`)
COMMENT "内容域--拆章书成本统计表"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);