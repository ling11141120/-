CREATE TABLE `dws_sr_ad_book_promotion_user_info_di` (
  `dt` date NOT NULL COMMENT "日期-活动时间",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `chl2` varchar(755) NOT NULL COMMENT "渠道值",
  `campaign` varchar(755) NOT NULL COMMENT "广告系列",
  `source_chl` varchar(755) NOT NULL COMMENT "媒体渠道值",
  `mt` int(11) NOT NULL COMMENT "平台（终端）",
  `core` int(11) NOT NULL COMMENT "corever包体",
  `current_language2` int(11) NOT NULL COMMENT "投放语言",
  `adcamp_id` varchar(755) NULL COMMENT "广告系列id",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "海阅-记录在站外针对全量用户进行推书，用户信息表临时表"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
