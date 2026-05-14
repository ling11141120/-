CREATE TABLE `dim_book_bill_info` (
  `Id` int(11) NOT NULL COMMENT "自增id",
  `dt` date NOT NULL COMMENT "日期",
  `bill_id` int(11) NULL COMMENT "书单id",
  `weight` int(11) NULL COMMENT "流量权重",
  `begin_time` datetime NULL COMMENT "开始时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `free_chapter` int(11) NULL COMMENT "免费章节",
  `lang_id` int(11) NULL COMMENT "语言id",
  `del_status` tinyint(4) NULL COMMENT "处理状态",
  `create_time` datetime NULL COMMENT "表单书籍信息创建时间",
  `update_time` datetime NULL COMMENT "表单书籍信息更新时间",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `name` varchar(512) NULL COMMENT "站内书单名称",
  `bill_type` int(11) NULL COMMENT "书单类型 1：通用 2：书籍限免 3：章节限免",
  `book_bill_create_time` datetime NULL COMMENT "书单创建时间",
  `book_bill_update_time` datetime NULL COMMENT "书单更新时间",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `dt`)
COMMENT "站内流量测试-表单书籍表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "bill_id, create_time, end_time, begin_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);