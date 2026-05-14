CREATE TABLE `ads_sr_marketing_plan` (
  `source_chl` varchar(128) NOT NULL COMMENT "媒体",
  `book_id` varchar(128) NOT NULL COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `code_stage` int(11) NULL COMMENT "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶",
  `code_lv` varchar(20) NULL COMMENT "最高阶段投放等级 B|A|S|SS",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`source_chl`, `book_id`)
COMMENT "海阅-超前点播章节策略自动化"
DISTRIBUTED BY HASH(`source_chl`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);