CREATE TABLE `ads_sr_edm_automated_recommend_1` (
  `batch_id` int(11) NOT NULL COMMENT "",
  `user_id` int(11) NOT NULL COMMENT "",
  `lang_id` int(11) NOT NULL COMMENT "",
  `second_lang_id` int(11) NOT NULL COMMENT "二级语言",
  `value` varchar(65533) NULL COMMENT "",
  `etl_time` datetime NULL COMMENT "etl时间",
  INDEX index_etl_time (`etl_time`) USING BITMAP
) ENGINE=OLAP 
PRIMARY KEY(`batch_id`, `user_id`, `lang_id`, `second_lang_id`)
COMMENT "海阅-海阅EDM日常推荐自动化数据支持"
DISTRIBUTED BY HASH(`batch_id`, `user_id`, `lang_id`, `second_lang_id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "2",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);