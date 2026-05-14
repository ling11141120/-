CREATE TABLE `ads_sr_series_income_dn` (
  `current_language2` int(11) NOT NULL COMMENT "投放语言",
  `mt` int(11) NOT NULL COMMENT "终端",
  `source` varchar(500) NOT NULL COMMENT "媒体值",
  `book_id` varchar(255) NOT NULL COMMENT "书籍id",
  `code` varchar(255) NOT NULL COMMENT "源剧代码",
  `days` int(11) NOT NULL COMMENT "当前时间-投放时间",
  `dn` int(11) NOT NULL COMMENT "dn",
  `reg_num` int(11) NULL COMMENT "reg_num",
  `amount` decimal(10, 2) NULL COMMENT "金额",
  `payers_num` int(11) NULL COMMENT "payers_num",
  `payers_num2` int(11) NULL COMMENT "payers_num2",
  `days_rank` int(11) NULL COMMENT "（当前时间-投放时间）排序，剔除无投放的日期",
  `etl_tm` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`current_language2`, `mt`, `source`, `book_id`, `code`, `days`, `dn`)
COMMENT "海剧按天收入表-120天内"
DISTRIBUTED BY HASH(`current_language2`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);