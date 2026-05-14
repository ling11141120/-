CREATE TABLE `ads_content_book_spotcheck_data_board_p_di` (
  `id` bigint(20) NOT NULL COMMENT "书籍ID",
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `create_time` datetime NOT NULL COMMENT "抽查时间",
  `book_code` varchar(65533) NULL COMMENT "书籍编码",
  `book_name` varchar(65533) NULL COMMENT "书籍名称",
  `language_name` varchar(65533) NULL COMMENT "书籍语言",
  `p_level` varchar(65533) NULL COMMENT "书籍P级标签",
  `role_type` int(11) NULL COMMENT "角色类型:1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查",
  `spot_check_words` bigint(20) NULL COMMENT "抽查字数",
  `chapter_name` varchar(65533) NULL COMMENT "章节名称",
  `author_name` varchar(65533) NULL COMMENT "译名",
  `real_name` varchar(65533) NULL COMMENT "姓名",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `dt`, `book_id`)
COMMENT "内容域--书籍抽查数据看板"
PARTITION BY RANGE(`dt`)
(PARTITION p2020 VALUES [("2020-01-01"), ("2021-01-01")),
PARTITION p2021 VALUES [("2021-01-01"), ("2022-01-01")),
PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")))
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-12",
"dynamic_partition.end" = "2",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);