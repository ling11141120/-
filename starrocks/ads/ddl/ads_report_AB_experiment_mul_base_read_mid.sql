CREATE TABLE `ads_report_AB_experiment_mul_base_read_mid` (
  `dt` date NOT NULL COMMENT "统计周期",
  `source_types` smallint(6) NOT NULL COMMENT "推荐来源（1榜单-猜你喜欢，2频道-猜你喜欢，3退出弹窗，4串书，5章末推,6末页推）",
  `product_id` int(11) NOT NULL COMMENT "产品语言",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `source_types`, `product_id`, `user_id`, `book_id`)
COMMENT "算法ab实验曝光并有阅读基础中间表"
DISTRIBUTED BY HASH(`dt`, `source_types`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);