CREATE TABLE `ads_report_author_target_progress` (
  `dt` date NOT NULL COMMENT "查询日期",
  `site_id` smallint(6) NOT NULL COMMENT "语言id",
  `author_id` bigint(20) NOT NULL COMMENT "作者id",
  `role_type` smallint(6) NOT NULL COMMENT "角色",
  `author_name` varchar(65533) NULL COMMENT "作者名称",
  `day_target` bigint(20) NOT NULL COMMENT "日目标",
  `month_target` bigint(20) NOT NULL COMMENT "月目标",
  `font_curmonth_reach` bigint(20) NULL COMMENT "本月达成",
  `cur_month_reach` decimal(18, 4) NULL COMMENT "本月达成率",
  `cur_target` bigint(20) NULL COMMENT "本月应达成目标",
  `cur_reach_rate` decimal(18, 4) NULL COMMENT "当前达成率",
  `font_diff` bigint(20) NULL COMMENT "达成字数差额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_site_id (`site_id`) USING BITMAP COMMENT '语言id索引',
  INDEX index_role_type (`role_type`) USING BITMAP COMMENT '角色索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `author_id`, `role_type`)
COMMENT "翻译人员目标进度管理表"
DISTRIBUTED BY HASH(`site_id`, `author_id`, `role_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "author_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);