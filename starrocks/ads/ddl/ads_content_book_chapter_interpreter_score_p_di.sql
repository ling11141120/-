CREATE TABLE `ads_content_book_chapter_interpreter_score_p_di` (
  `dt` date NOT NULL COMMENT "反馈时间-天",
  `author_id` bigint(20) NOT NULL COMMENT "作者id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `chapter_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NOT NULL COMMENT "语言id",
  `author_name` varchar(200) NULL COMMENT "译名",
  `role_type` int(11) NULL COMMENT "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查",
  `feed_back_type` int(11) NULL COMMENT "反馈类型: 0、质检反馈子句；1、质检抽查；2、一校抽查；3、三校抽查； 10、质检反馈章节",
  `book_name` varchar(500) NULL COMMENT "书籍名称",
  `chapter_name` varchar(500) NULL COMMENT "章节名称",
  `score` decimal(20, 2) NULL COMMENT "分数",
  `create_time` datetime NULL COMMENT "反馈时间",
  `etl_time` datetime NULL COMMENT "etl清洗时间 "
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `author_id`, `book_id`, `chapter_id`)
COMMENT "内容域--书籍章节译员分数明细表"
PARTITION BY RANGE(`dt`)
(PARTITION p2020 VALUES [("2020-01-01"), ("2021-01-01")),
PARTITION p2021 VALUES [("2021-01-01"), ("2022-01-01")),
PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`author_id`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);