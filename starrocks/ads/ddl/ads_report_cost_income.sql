CREATE TABLE `ads_report_cost_income` (
  `dt` date NOT NULL COMMENT "年分区字段：日期",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `book_name` varchar(65533) NULL COMMENT "中文书名",
  `origin_book_name` varchar(65533) NULL COMMENT "源书书名",
  `object_book_name` varchar(65533) NULL COMMENT "目标书名",
  `promotion_status` smallint(6) NULL COMMENT "推广状态:1-主推，2-测试推广，3-未推广",
  `object_book_type` int(11) NULL COMMENT "图书书籍类型,0-网文 1-短剧",
  `is_cost_rate` int(11) NULL COMMENT "是否计算成本率,0-否 1-是",
  `cost_amt_7` decimal(18, 4) NULL COMMENT "近7天成本金额，单位：人民币",
  `amount_7` decimal(18, 4) NULL COMMENT "近7天收入，单位：人民币",
  `cost_amt_30` decimal(18, 4) NULL COMMENT "近30天成本金额，单位：人民币",
  `amount_30` decimal(18, 4) NULL COMMENT "近30天收入，单位：人民币",
  `cost_amt_curmon` decimal(18, 4) NULL COMMENT "本月成本金额，单位：人民币",
  `amount_curmon` decimal(18, 4) NULL COMMENT "本月收入，单位：人民币",
  `cost_amt_YTD` decimal(18, 4) NULL COMMENT "累计成本金额，单位：人民币",
  `amount_YTD` decimal(18, 4) NULL COMMENT "累计收入，单位：人民币",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `book_id`)
COMMENT "翻译书籍费率表"
DISTRIBUTED BY HASH(`product_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);