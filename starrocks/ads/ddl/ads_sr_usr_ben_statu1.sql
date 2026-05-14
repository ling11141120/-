CREATE TABLE `ads_sr_usr_ben_statu1` (
  `dt` date NOT NULL COMMENT "日期",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `ben_type` int(11) NOT NULL COMMENT "权益类型(810svip,840新福利包,850vip)",
  `rel_ord` varchar(10000) NULL COMMENT "关联订单",
  `ben_ocr_tm` datetime NULL COMMENT "权益生效时间",
  `ben_end_tm` datetime NULL COMMENT "权益失效时间",
  `h_alc_amt` decimal(10, 4) NULL COMMENT "每小时分摊金额",
  `ulk_chap_num` int(11) NULL COMMENT "解锁章节字数"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`)
COMMENT "海阅读用户权益状态表"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);