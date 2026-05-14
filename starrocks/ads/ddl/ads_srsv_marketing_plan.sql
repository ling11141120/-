CREATE TABLE `ads_srsv_marketing_plan` (
  `project_code` int(11) NOT NULL COMMENT "项目类型 1=海阅|2=海剧",
  `source_chl` varchar(128) NOT NULL COMMENT "媒体",
  `code_id` varchar(128) NOT NULL COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
  `code_stage` int(11) NULL COMMENT "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶",
  `code_lv` varchar(20) NULL COMMENT "最高阶段投放等级 B|A|S|SS",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`project_code`, `source_chl`, `code_id`)
COMMENT "海阅海剧-超前点播章节策略自动化"
DISTRIBUTED BY HASH(`project_code`, `source_chl`, `code_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);