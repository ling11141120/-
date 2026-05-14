CREATE TABLE `ads_sr_alg_book_feature_di` (
  `dt` date NOT NULL COMMENT "统计数据时间",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `channel` int(11) NULL COMMENT "频道",
  `new_cid` int(11) NULL COMMENT "分类id",
  `read_uv_1d` bigint(20) NULL COMMENT "近一天阅读人数",
  `csum_uv_1d` bigint(20) NULL COMMENT "近一天消耗人数",
  `start_read_chpts_1d` bigint(20) NULL COMMENT "近一天开始阅读章节数",
  `end_read_chpts_1d` bigint(20) NULL COMMENT "近一天结束阅读章节数",
  `csum_num_1d` bigint(20) NULL COMMENT "近一天消耗章节数",
  `csum_total_1d` bigint(20) NULL COMMENT "近一天消耗总数",
  `read_uv_3d` bigint(20) NULL COMMENT "近三天阅读人数",
  `csum_uv_3d` bigint(20) NULL COMMENT "近三天消耗人数",
  `start_read_chpts_3d` bigint(20) NULL COMMENT "近三天开始阅读章节数",
  `end_read_chpts_3d` bigint(20) NULL COMMENT "近三天结束阅读章节数",
  `csum_num_3d` bigint(20) NULL COMMENT "近三天消耗章节数",
  `csum_total_3d` bigint(20) NULL COMMENT "近三天消耗总数",
  `read_uv_7d` bigint(20) NULL COMMENT "近七天阅读人数",
  `csum_uv_7d` bigint(20) NULL COMMENT "近七天消耗人数",
  `start_read_chpts_7d` bigint(20) NULL COMMENT "近七天开始阅读章节数",
  `end_read_chpts_7d` bigint(20) NULL COMMENT "近七天结束阅读章节数",
  `csum_num_7d` bigint(20) NULL COMMENT "近七天消耗章节数",
  `csum_total_7d` bigint(20) NULL COMMENT "近七天消耗总数",
  `read_uv_30d` bigint(20) NULL COMMENT "近三十天阅读人数",
  `csum_uv_30d` bigint(20) NULL COMMENT "近三十天消耗人数",
  `start_read_chpts_30d` bigint(20) NULL COMMENT "近三十天开始阅读章节数",
  `end_read_chpts_30d` bigint(20) NULL COMMENT "近三十天结束阅读章节数",
  `csum_num_30d` bigint(20) NULL COMMENT "近三十天消耗章节数",
  `csum_total_30d` bigint(20) NULL COMMENT "近三十天消耗总数",
  `read_uv` bigint(20) NULL COMMENT "阅读人数",
  `csum_uv` bigint(20) NULL COMMENT "消耗人数",
  `start_read_chpts` bigint(20) NULL COMMENT "开始阅读章节数",
  `end_read_chpts` bigint(20) NULL COMMENT "结束阅读章节数",
  `csum_num` bigint(20) NULL COMMENT "消耗章节数",
  `csum_total` bigint(20) NULL COMMENT "消耗总数",
  `etl_tm` datetime NOT NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "海阅-算法书籍特征表"
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 105 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);