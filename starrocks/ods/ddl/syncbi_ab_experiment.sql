CREATE TABLE `syncbi_ab_experiment` (
  `id` bigint(20) NOT NULL COMMENT "ID",
  `version` bigint(20) NULL COMMENT "",
  `ab_hash_key` varchar(255) NULL COMMENT "",
  `project_name` varchar(128) NULL COMMENT "",
  `project_id` bigint(20) NULL COMMENT "1-阅读  2-国内短剧 3-海外短剧 4-其他",
  `experiment_name` varchar(128) NULL COMMENT "实验名称",
  `experiment_description` varchar(65533) NULL COMMENT "实验描述",
  `experiment_tags` varchar(128) NULL COMMENT "实验标签",
  `experiment_duration` int(11) NULL COMMENT "实验时长",
  `experiment_traffic` double NULL COMMENT "实验流量",
  `traffic_exclusivity` smallint(6) NULL COMMENT "流量是否互斥 1-是 0-否",
  `traffic_activation_method` smallint(6) NULL COMMENT "流量生效方式 1-立即生效 0-否",
  `status` smallint(6) NULL COMMENT "实验状态：0-调试中 1-运行中 2-已结束 ",
  `start_time` datetime NULL COMMENT "启动时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `debug_progress` smallint(6) NULL COMMENT "调试进度",
  `experiment_audience` varchar(65533) NULL COMMENT "",
  `experiment_owners` varchar(65533) NULL COMMENT "",
  `experiment_metrics` varchar(65533) NULL COMMENT "",
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "创建时间",
  `create_user` varchar(128) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "更新时间",
  `update_user` varchar(128) NULL COMMENT "更新人",
  `has_warning` smallint(6) NULL DEFAULT "0" COMMENT "实验是否已告警 1-以告警 0-未告警",
  `is_delete` tinyint(4) NULL DEFAULT "0" COMMENT "",
  `parent_id` bigint(20) NULL COMMENT "",
  `display_order` varchar(255) NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "AB测试实验信息表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "project_id, id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
