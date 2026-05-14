CREATE TABLE `series_reco_ab_report_data` (
  `dt` date NOT NULL COMMENT "日期",
  `page_id` varchar(2048) NOT NULL COMMENT "推荐资源位",
  `exp_grp_name` varchar(2048) NOT NULL COMMENT "分组名称",
  `uv` bigint(20) NULL COMMENT "推荐人数",
  `read_uv` bigint(20) NULL COMMENT "看剧人数",
  `csum_uv` bigint(20) NULL COMMENT "消费人数",
  `read_chpts` bigint(20) NULL COMMENT "看剧总集数",
  `csum_num` bigint(20) NULL COMMENT "消费总次数",
  `csum_total` bigint(20) NULL COMMENT "消费总金额",
  `read_cvr` decimal(38, 19) NULL COMMENT "看剧转化率",
  `csum_cvr` decimal(38, 19) NULL COMMENT "消费转化率",
  `avg_csum` decimal(16, 6) NULL COMMENT "人均消金额"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `page_id`, `exp_grp_name`)
COMMENT "海剧-内容推荐各位置实验AB数据"
DISTRIBUTED BY HASH(`dt`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);