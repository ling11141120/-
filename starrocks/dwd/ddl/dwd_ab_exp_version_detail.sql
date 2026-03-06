CREATE TABLE dwd.`dwd_ab_exp_version_detail` (
  `project_id` bigint(20) NOT NULL COMMENT "1-阅读  2-国内短剧 3-海外短剧 4-其他",
  `exp_id` bigint(20) NOT NULL COMMENT "实验id",
  `exp_grp_id` bigint(20) NOT NULL COMMENT "实验组id",
  `exp_grp_type` bigint(20) NOT NULL COMMENT "实验组类型ID: 1-对照组 2-实验组",
  `exp_grp_ver_id` bigint(20) NOT NULL COMMENT "实验版本id",
  `exp_start_time` datetime NULL COMMENT "实验开始时间",
  `exp_end_time` datetime NULL COMMENT "实验结束时间",
  `start_time` datetime NULL COMMENT "实验版本开始时间",
  `end_time` datetime NULL COMMENT "实验版结束时间",
  `exp_name` varchar(500) NULL COMMENT "实验名称",
  `exp_grp_name` varchar(500) NULL COMMENT "实验组名称",
  `etl_time` datetime NULL COMMENT "数据时间"
) ENGINE=OLAP 
PRIMARY KEY(`project_id`, `exp_id`, `exp_grp_id`, `exp_grp_type`, `exp_grp_ver_id`)
COMMENT "海剧-实验所有版本--明细表"
DISTRIBUTED BY HASH(`exp_id`, `exp_grp_ver_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "exp_id, exp_grp_ver_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);