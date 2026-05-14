CREATE TABLE `dws_advertisement_fbad_install_info_temp` (
  `dt` date NULL COMMENT "事件时间",
  `install_date` datetime NULL COMMENT "事件时间小时",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `product_id` int(11) NULL COMMENT "产品id",
  `mt` int(11) NULL COMMENT "平台",
  `core` int(11) NULL COMMENT "core",
  `product_tp` int(11) NULL COMMENT "1:阅读 2:海剧",
  `ad_id` varchar(255) NULL COMMENT "广告id",
  `source` varchar(255) NULL COMMENT "媒体值",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `current_language2` int(11) NULL COMMENT "投放语言",
  `country` varchar(255) NULL COMMENT "投放国家",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间",
  INDEX index_product_tp (`product_id`) USING BITMAP COMMENT 'index_product_id'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `install_date`)
COMMENT "ads广告fb install信息临时表"
DISTRIBUTED BY HASH(`dt`, `install_date`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id, install_date",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
