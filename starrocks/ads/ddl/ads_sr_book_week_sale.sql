CREATE TABLE `ads_sr_book_week_sale` (
  `product_id` int(11) NOT NULL COMMENT "",
  `id` int(11) NOT NULL COMMENT "",
  `book_id` bigint(20) NULL COMMENT "",
  `language_id` int(11) NULL COMMENT "",
  `book_nature` int(11) NULL COMMENT "",
  `money_sale` decimal(18, 2) NULL COMMENT "",
  `money_count` bigint(20) NULL COMMENT "",
  `money_person` bigint(20) NULL COMMENT "",
  `money_orgin_sale` decimal(18, 2) NULL COMMENT "",
  `money_orgin_count` bigint(20) NULL COMMENT "",
  `money_orgin_person` bigint(20) NULL COMMENT "",
  `money_pirate_sale` decimal(18, 2) NULL COMMENT "",
  `money_pirate_count` bigint(20) NULL COMMENT "",
  `money_pirate_person` bigint(20) NULL COMMENT "",
  `gift_sale` decimal(18, 2) NULL COMMENT "",
  `gift_count` bigint(20) NULL COMMENT "",
  `gift_person` bigint(20) NULL COMMENT "",
  `reward` decimal(18, 2) NULL COMMENT "",
  `tick_total` bigint(20) NULL COMMENT "",
  `award_money` decimal(18, 2) NULL COMMENT "",
  `award_person` bigint(20) NULL COMMENT "",
  `award_count` bigint(20) NULL COMMENT "",
  `award_reward` decimal(18, 2) NULL COMMENT "",
  `cps_money` decimal(18, 2) NULL COMMENT "",
  `money_package` decimal(18, 2) NULL COMMENT "",
  `start_time` datetime NULL COMMENT "",
  `end_time` datetime NULL COMMENT "",
  `is_del` int(11) NULL COMMENT "",
  `cid` int(11) NULL COMMENT "",
  `cname` varchar(500) NULL COMMENT "",
  `full_stat` int(11) NULL COMMENT "",
  `channel` int(11) NULL COMMENT "",
  `build_time` datetime NULL COMMENT "",
  `normal_chapter_num` int(11) NULL COMMENT "",
  `sexy` int(11) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `id`)
COMMENT "海阅-bookweeksale"
DISTRIBUTED BY HASH(`product_id`, `id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);