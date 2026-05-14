CREATE TABLE `ads_cr_book_sale_di` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `cn_book_id` bigint(20) NOT NULL COMMENT "国内书籍id",
  `cn_book_name` varchar(65533) NULL COMMENT "书籍名称",
  `cn_book_code` varchar(65533) NULL COMMENT "书籍代号",
  `partner_name` varchar(65533) NULL COMMENT "合作商名称",
  `to_book_ids` varchar(65533) NULL COMMENT "翻译后的书籍id",
  `money_amt` decimal(18, 2) NULL COMMENT "收入",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `cn_book_id`)
COMMENT "国内书籍收入信息表"
DISTRIBUTED BY HASH(`dt`, `cn_book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);