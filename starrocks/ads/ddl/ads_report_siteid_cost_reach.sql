CREATE TABLE `ads_report_siteid_cost_reach` (
  `dt` date NOT NULL COMMENT "日期",
  `site_id` smallint(6) NOT NULL COMMENT "语言id",
  `grade_type` smallint(6) NOT NULL COMMENT "档位- 0:S,1:A,2:B,3:C,4:D",
  `cost_rate_target` decimal(19, 2) NOT NULL COMMENT "成本达标率目标",
  `cost_reach_rate` decimal(18, 4) NULL COMMENT "成本达标率",
  `gap` decimal(18, 4) NULL COMMENT "成本达标率差值",
  `cost_no_reach` bigint(20) NULL COMMENT "未达标的书本数",
  `cost_reach` bigint(20) NULL COMMENT "达标的书本数",
  `total_book_num` bigint(20) NULL COMMENT "总书本数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_site_id (`site_id`) USING BITMAP COMMENT '语言id索引',
  INDEX index_grade_type (`grade_type`) USING BITMAP COMMENT '挡位索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `grade_type`)
COMMENT "编辑书籍多语言成本达标率表"
DISTRIBUTED BY HASH(`site_id`, `grade_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);