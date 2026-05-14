CREATE TABLE `ads_bi_book_chap5_ret_rt_info` (
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NULL COMMENT "语言id",
  `new_cid` int(11) NULL COMMENT "分类id",
  `new_cname` varchar(100) NULL COMMENT "分类名称",
  `chap5_read_num` int(11) NULL COMMENT "第五章阅读人数",
  `ttl_chap_read_num` int(11) NULL COMMENT "总阅读人数",
  `chap5_ret_rt` decimal(10, 4) NULL COMMENT "第五章留存率"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "bi-书籍第5章留存信息表"
PARTITION BY RANGE(`dt`)
(PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
PARTITION p20260508 VALUES [("2026-05-08"), ("2026-05-09")),
PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")))
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "1",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "9",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);