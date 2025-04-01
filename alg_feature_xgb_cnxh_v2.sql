CREATE TABLE `alg_feature_xgb_cnxh_v1` (
  `dt` date NULL COMMENT "日期",
  `book_id` bigint(20) NULL COMMENT "书籍ID",
  `total_read_chpts` bigint(20) NULL COMMENT "总阅读章节数",
  `total_consume_count` bigint(20) NULL COMMENT "总消费次数",
  `total_consume` bigint(20) NULL COMMENT "总消费",
  `channel` bigint(20) NULL COMMENT "渠道",
  `new_cid` bigint(20) NULL COMMENT "",
  `read_uv_1d` bigint(20) NULL COMMENT "1天阅读uv",
  `csum_uv_1d` bigint(20) NULL COMMENT "1天消费uv",
  `start_read_chpts_1d` bigint(20) NULL COMMENT "开始阅读",
  `end_read_chpts_1d` bigint(20) NULL COMMENT "结束阅读",
  `csum_num_1d` bigint(20) NULL COMMENT "消费pv",
  `csum_total_1d` bigint(20) NULL COMMENT "消费金额",
  `read_uv_3d` bigint(20) NULL COMMENT "3天阅读uv",
  `csum_uv_3d` bigint(20) NULL COMMENT "3天消费uv",
  `start_read_chpts_3d` bigint(20) NULL COMMENT "3天开始阅读",
  `end_read_chpts_3d` bigint(20) NULL COMMENT "3天结束阅读",
  `csum_num_3d` bigint(20) NULL COMMENT "3天消费pv",
  `csum_total_3d` bigint(20) NULL COMMENT "3天消费金额",
  `read_uv_7d` bigint(20) NULL COMMENT "7天阅读uv",
  `csum_uv_7d` bigint(20) NULL COMMENT "7天阅读数",
  `start_read_chpts_7d` bigint(20) NULL COMMENT "7天开始阅读章节",
  `end_read_chpts_7d` bigint(20) NULL COMMENT "7天结束阅读章节",
  `csum_num_7d` bigint(20) NULL COMMENT "7天消费",
  `csum_total_7d` bigint(20) NULL COMMENT "7天花费",
  `read_uv_30d` bigint(20) NULL COMMENT "30天阅读",
  `csum_uv_30d` bigint(20) NULL COMMENT "30天消费",
  `start_read_chpts_30d` bigint(20) NULL COMMENT "30天阅读开始数",
  `end_read_chpts_30d` bigint(20) NULL COMMENT "30天阅读结束数",
  `csum_num_30d` bigint(20) NULL COMMENT "30天消费",
  `csum_total_30d` bigint(20) NULL COMMENT "30天消费金额",
  `read_uv` bigint(20) NULL COMMENT "阅读",
  `csum_uv` bigint(20) NULL COMMENT "消费",
  `start_read_chpts` bigint(20) NULL COMMENT "开始阅读",
  `end_read_chpts` bigint(20) NULL COMMENT "结束阅读",
  `csum_num` bigint(20) NULL COMMENT "消费数",
  `csum_total` bigint(20) NULL COMMENT "消费金额"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 16 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);


//dasd;klsdf;asdfjk'asdfsdf kjuashd. 