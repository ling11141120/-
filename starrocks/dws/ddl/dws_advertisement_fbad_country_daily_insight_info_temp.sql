CREATE TABLE `dws_advertisement_fbad_country_daily_insight_info_temp` (
  `dt` date NULL COMMENT "事件时间",
  `product_id` varchar(50) NULL COMMENT "产品id",
  `country` varchar(255) NULL COMMENT "投放国家",
  `country_level` int(11) NULL COMMENT "国家等级",
  `source_chl` varchar(255) NULL COMMENT "媒体值",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `mt` int(11) NULL COMMENT "平台",
  `core` int(11) NULL COMMENT "core",
  `product_tp` int(11) NULL COMMENT "1:阅读 2:海剧",
  `cost_amt` decimal(10, 2) NULL COMMENT "投放花费",
  `click_cnt` int(11) NULL COMMENT "链接点击数",
  `impression_cnt` int(11) NULL COMMENT "展示数",
  `source_reg_unt` int(11) NULL COMMENT "媒体注册数",
  `pay_amt` decimal(10, 2) NULL COMMENT "媒体收入",
  `pay_cnt` int(11) NULL COMMENT "充值次数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间",
  INDEX index_product_tp (`product_tp`) USING BITMAP COMMENT 'index_product_tp'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "ads广告媒体维度花费临时表"
DISTRIBUTED BY HASH(`dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
