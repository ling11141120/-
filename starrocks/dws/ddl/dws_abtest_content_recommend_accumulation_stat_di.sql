CREATE TABLE `dws_abtest_content_recommend_accumulation_stat_di` (
  `dt` date NOT NULL COMMENT "日期",
  `project_id` int(11) NOT NULL COMMENT "项目ID",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `exp_name` varchar(65533) NOT NULL COMMENT "实验名称",
  `exp_grp_type` int(11) NOT NULL COMMENT "实验组类型",
  `exp_grp_name` varchar(65533) NOT NULL COMMENT "实验组名称",
  `traffic_allocation` decimal(20, 4) NULL COMMENT "流量占比",
  `ifd_reco_total_act_cnt` int(11) NULL COMMENT "总阅读章节数（总观看集数）",
  `ifd_reco_total_unlock_cnt` int(11) NULL COMMENT "总解锁章节数（总解锁集数）",
  `ifd_reco_total_consume` decimal(20, 4) NULL COMMENT "总消费",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `project_id`, `exp_id`, `exp_grp_id`)
COMMENT "AB测试-内容推荐--可累加指标--天汇总表"
DISTRIBUTED BY HASH(`dt`, `project_id`, `exp_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "project_id, exp_id",
"colocate_with" = "recomend_dt_join_group",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
