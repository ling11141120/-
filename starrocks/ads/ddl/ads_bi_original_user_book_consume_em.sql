CREATE TABLE `ads_bi_original_user_book_consume_em` (
  `years` int(11) NOT NULL COMMENT "年",
  `qtypes` int(11) NOT NULL COMMENT "1：按月的",
  `dt` int(11) NOT NULL COMMENT "月份",
  `site_id` int(11) NOT NULL COMMENT "书籍语言id",
  `book_nature` int(11) NOT NULL COMMENT "书籍类型 3:原创 5:原创拆章",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `money_amount` decimal(10, 2) NULL COMMENT "消耗阅币",
  `vip_amount` decimal(10, 2) NULL COMMENT "消耗vip",
  `gift_amount` decimal(10, 2) NULL COMMENT "消耗礼券",
  `award_amount` decimal(10, 2) NULL COMMENT "赠送币消耗",
  `total_amount` decimal(10, 2) NULL COMMENT "消耗合计",
  `etl_time` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`years`, `qtypes`, `dt`, `site_id`, `book_nature`, `book_id`)
COMMENT "服务端编辑后台-按月、书、原创、原创拆章书籍消耗表"
DISTRIBUTED BY HASH(`years`, `qtypes`, `dt`, `site_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);