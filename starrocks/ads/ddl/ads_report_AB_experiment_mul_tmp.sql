CREATE TABLE `ads_report_AB_experiment_mul_tmp` (
  `dt` date NOT NULL COMMENT "统计周期",
  `types` smallint(6) NOT NULL COMMENT "推荐来源（1榜单-猜你喜欢，2频道-猜你喜欢，3退出弹窗，4串书，5章末推）",
  `product_id` int(11) NOT NULL COMMENT "产品语言",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `is_read` smallint(6) NULL COMMENT "是否阅读",
  `total_read_chpts` bitmap NULL COMMENT "阅读章节数",
  `consume_amount` bigint(20) NULL COMMENT "消耗金额数（阅币礼券赠送币）",
  `consume_chpts` bitmap NULL COMMENT "解锁章节数",
  `consume_money_amount` bigint(20) NULL COMMENT "阅币消耗金额数",
  `charge_money` decimal(38, 6) NULL COMMENT "充值金额（分成前）",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `types`, `product_id`, `user_id`, `book_id`)
COMMENT "算法实验3.0临时表"
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);