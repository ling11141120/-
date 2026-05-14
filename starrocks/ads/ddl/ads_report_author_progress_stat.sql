CREATE TABLE `ads_report_author_progress_stat` (
  `dt` date NOT NULL COMMENT "查询日期",
  `site_id` smallint(6) NOT NULL COMMENT "语言id",
  `role_type` smallint(6) NOT NULL COMMENT "角色",
  `author_num` bigint(20) NULL COMMENT "人数",
  `cur_target_total` bigint(20) NULL COMMENT "本月应达成总目标",
  `curmonth_reach_total` bigint(20) NULL COMMENT "本月总达成",
  `total_reach_rate` decimal(18, 4) NULL COMMENT "当前达成率",
  `unreach_author_num` bigint(20) NULL COMMENT "未达成人数",
  `unreach_num_rate` decimal(18, 4) NULL COMMENT "未达成人数占比",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_site_id (`site_id`) USING BITMAP COMMENT '语言id索引',
  INDEX index_role_type (`role_type`) USING BITMAP COMMENT '角色索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `site_id`, `role_type`)
COMMENT "各语言翻译人员进度统计表"
DISTRIBUTED BY HASH(`site_id`, `role_type`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);