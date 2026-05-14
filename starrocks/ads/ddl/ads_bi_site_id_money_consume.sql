CREATE TABLE `ads_bi_site_id_money_consume` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` int(11) NOT NULL COMMENT "",
  `money_amount` decimal(10, 2) NULL COMMENT "阅币消耗金额",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`)
COMMENT "服务端编辑后台-书籍语言维度阅币消耗表"
DISTRIBUTED BY HASH(`dt`, `site_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);