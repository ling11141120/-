CREATE TABLE `dwm_abtest_content_product_recommend_distinct_stat_hi` (
  `dt_hour` datetime NOT NULL COMMENT "日期小时",
  `project_id` int(11) NOT NULL COMMENT "项目ID",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `grp_users` bitmap BITMAP_UNION NULL COMMENT "实验组用户id",
  `read_or_watch_users` bitmap BITMAP_UNION NULL COMMENT "阅读或者观看用户id",
  `consume_users` bitmap BITMAP_UNION NULL COMMENT "消费用户id",
  `etl_time` datetime REPLACE NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
AGGREGATE KEY(`dt_hour`, `project_id`, `exp_id`, `exp_grp_id`, `product_id`)
COMMENT "AB测试-内容推荐业务-英文阅读-去重指标--中间表-小时增量"
DISTRIBUTED BY HASH(`dt_hour`, `project_id`, `exp_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "project_id, exp_id, exp_grp_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
