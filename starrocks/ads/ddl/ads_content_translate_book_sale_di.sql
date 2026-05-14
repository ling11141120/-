CREATE TABLE `ads_content_translate_book_sale_di` (
  `dt` int(11) NOT NULL COMMENT "日期",
  `cn_book_id` bigint(20) NOT NULL COMMENT "中文书籍id",
  `to_language_id` int(11) NOT NULL COMMENT "翻译后的语言id",
  `book_name` varchar(65533) NULL COMMENT "书籍名称",
  `book_code` varchar(65533) NULL COMMENT "书籍编码",
  `month_str` varchar(65533) NULL COMMENT "月份字符串",
  `partner_name` varchar(65533) NULL COMMENT "合作商名称",
  `company_name` varchar(65533) NULL COMMENT "公司名称",
  `money_amt` decimal(18, 2) NULL COMMENT "收入",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `cn_book_id`, `to_language_id`)
COMMENT "国内书籍收入信息表"
DISTRIBUTED BY HASH(`dt`, `cn_book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);