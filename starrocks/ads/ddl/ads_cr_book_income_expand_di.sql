CREATE TABLE `ads_cr_book_income_expand_di` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `md5_key` varchar(65533) NOT NULL COMMENT "md5key",
  `book_id` varchar(65533) NULL COMMENT "国阅书籍id",
  `original_id` bigint(20) NULL COMMENT "编辑后台书籍原始ID",
  `income` decimal(18, 2) NULL COMMENT "收入",
  `expend` decimal(18, 2) NULL COMMENT "支出",
  `distribute_expend` decimal(18, 2) NULL COMMENT "分销支出",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "国阅收支数据"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);