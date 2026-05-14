CREATE TABLE `ads_koc_srsv_book_spend_rankings_da` (
  `dt` date NOT NULL COMMENT "日期",
  `product_type` int(11) NOT NULL COMMENT "项目类型，1：海阅 2：海剧",
  `rn` int(11) NOT NULL COMMENT "排行",
  `product_id` int(11) NULL COMMENT "项目id",
  `book_id` bigint(20) NULL COMMENT "书id",
  `total_spend` decimal(16, 2) NULL COMMENT "投放花费",
  `total_recharge_amount` decimal(16, 2) NULL COMMENT "充值总额",
  `conversion_rate` decimal(16, 2) NULL COMMENT "转化率",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_type`, `rn`)
COMMENT "koc项目,海阅海剧投放花费书/剧排行"
DISTRIBUTED BY HASH(`product_type`, `rn`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);