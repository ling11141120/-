CREATE TABLE `dws_read_readbook_by_usertype_mid` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_type` varchar(50) NOT NULL COMMENT "用户类型",
  `has_charge` smallint(6) NOT NULL COMMENT "是否充值",
  `mt` int(11) NOT NULL COMMENT "终端",
  `corever` int(11) NOT NULL COMMENT "core",
  `is_online` smallint(6) NOT NULL COMMENT "是否留存用户（7天）",
  `read_user_cnt` bigint(20) NULL COMMENT "阅读人数",
  `read_book_cnt` bigint(20) NULL COMMENT "阅读书籍数",
  `read_chanter_cnt` bigint(20) NULL COMMENT "阅读章节数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_type`, `has_charge`, `mt`, `corever`, `is_online`)
COMMENT "区分用户类型的阅读指标中间表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `corever`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
