CREATE TABLE `ads_content_external_buy_book_stat` (
  `dt` date NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "书籍ID",
  `book_name` varchar(65533) NULL COMMENT "书籍名称",
  `book_code` varchar(200) NULL COMMENT "书籍代号、书籍编码",
  `story_type` int(11) NULL DEFAULT "0" COMMENT "是否为短篇  0：非短篇， 1：短篇",
  `site_id` bigint(20) NULL COMMENT "书籍语言ID",
  `language_name` varchar(100) NULL COMMENT "书籍语言，简体/繁体/英语/西语/葡语/法语/印尼语/泰语/俄语/韩语",
  `source_book_id` bigint(20) NULL COMMENT "源书籍ID",
  `source_book_name` varchar(65533) NULL COMMENT "源书籍名称",
  `published_words` bigint(20) NULL COMMENT "已发布字数",
  `putaway_date` datetime NULL COMMENT "上架时间",
  `read_coin_amount` decimal(20, 2) NULL COMMENT "阅币消耗金额（元）",
  `ad_cost_amount` decimal(20, 2) NULL COMMENT "广告投放成本（元）",
  `translate_cost_amount` decimal(20, 2) NULL COMMENT "翻译成本（元）",
  `copyright_cost_amount` decimal(20, 2) NULL COMMENT "版权采买成本（元）",
  `copyright_fc_amount` decimal(20, 2) NULL COMMENT "版权分成金额（元）",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "内容域--外采书籍ROI看板需求"
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-12",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);