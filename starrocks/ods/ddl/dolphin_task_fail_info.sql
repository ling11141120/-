CREATE TABLE `dolphin_task_fail_info` (
  `id` int(11) NOT NULL COMMENT "",
  `name` varchar(100) NULL COMMENT "值班人员姓名",
  `phone` varchar(100) NULL COMMENT "值班人员手机号",
  `if_qiye` varchar(10) NULL COMMENT "是否起夜，0非  1是",
  `create_date` date NULL COMMENT "数据生成日期 yyyy-MM-dd",
  `create_time` varchar(100) NULL COMMENT "数据生成时间 yyyy-MM-dd HH:mm",
  INDEX index_if_qiye (`if_qiye`) USING BITMAP COMMENT '是否起夜索引'
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "数仓值班起夜率数据-同步海豚库中的数据"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);
