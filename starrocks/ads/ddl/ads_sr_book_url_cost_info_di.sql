CREATE TABLE `ads_sr_book_url_cost_info_di` (
  `dt` date NOT NULL COMMENT "日期(分时区)",
  `md5_key` varchar(65533) NOT NULL COMMENT "md5",
  `product_id` int(11) NOT NULL COMMENT "项目id",
  `source` varchar(255) NOT NULL COMMENT "渠道",
  `pageid` bigint(20) NOT NULL COMMENT "pageid",
  `ad_id` varchar(1024) NOT NULL COMMENT "广告id",
  `url` varchar(65533) NOT NULL COMMENT "url",
  `book_id` bigint(20) NOT NULL COMMENT "书id",
  `cost_amount` decimal(16, 2) NULL COMMENT "投放花费",
  `reg_num` int(11) NULL COMMENT "注册数",
  `view_num` int(11) NULL COMMENT "浏览数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "每日书籍广告url花费、激活信息"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);