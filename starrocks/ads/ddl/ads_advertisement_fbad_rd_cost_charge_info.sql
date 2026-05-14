CREATE TABLE `ads_advertisement_fbad_rd_cost_charge_info` (
  `dt` date NULL COMMENT "事件时间",
  `country` varchar(255) NULL COMMENT "投放国家",
  `country_level` int(11) NULL COMMENT "国家等级",
  `source_chl` varchar(255) NULL COMMENT "媒体值",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `mt` int(11) NULL COMMENT "平台",
  `cost_amt` decimal(10, 2) NULL COMMENT "投放花费",
  `click_cnt` int(11) NULL COMMENT "链接点击数",
  `impression_cnt` int(11) NULL COMMENT "展示数",
  `source_reg_unt` int(11) NULL COMMENT "媒体注册数",
  `pay_amt` decimal(10, 2) NULL COMMENT "媒体收入",
  `pay_cnt` int(11) NULL COMMENT "充值次数",
  `reg_unt` int(11) NULL COMMENT "本地注册数",
  `h24_amt` decimal(18, 2) NULL COMMENT "本地H24收入",
  `d7_amt` decimal(18, 2) NULL COMMENT "本地D7收入",
  `d30_amt` decimal(18, 2) NULL COMMENT "本地D30收入",
  `d90_amt` decimal(18, 2) NULL COMMENT "本地D90收入",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间",
  INDEX index_mt (`mt`) USING BITMAP COMMENT 'index_mt'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "阅读-ads广告媒体国家维度花费充值表，西五区"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, country, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);