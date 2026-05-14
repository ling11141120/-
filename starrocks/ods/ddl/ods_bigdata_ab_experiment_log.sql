CREATE TABLE `ods_bigdata_ab_experiment_log` (
  `id` bigint(20) NOT NULL COMMENT "ID",
  `experiment_id` bigint(20) NULL COMMENT "实验表id",
  `product_id` bigint(20) NULL COMMENT "",
  `ab_hash_key` varchar(755) NULL COMMENT "",
  `version` bigint(20) NULL COMMENT "",
  `experiment_name` varchar(384) NULL COMMENT "实验名称",
  `experiment_description` varchar(65533) NULL COMMENT "实验描述",
  `experiment_tags` varchar(384) NULL COMMENT "实验标签",
  `experiment_duration` int(11) NULL COMMENT "实验时长",
  `experiment_traffic` double NULL COMMENT "实验流量",
  `traffic_exclusivity` smallint(6) NULL COMMENT "流量是否互斥",
  `traffic_activation_method` smallint(6) NULL COMMENT "流量生效方式",
  `status` smallint(6) NULL COMMENT "实验状态",
  `start_time` datetime NULL COMMENT "启动时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `debug_progress` smallint(6) NULL COMMENT "调试进度",
  `experiment_audience` varchar(65533) NULL COMMENT "",
  `experiment_owners` varchar(65533) NULL COMMENT "",
  `experiment_metrics` varchar(65533) NULL COMMENT "",
  `experiment_versions` varchar(65533) NULL COMMENT "",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(384) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "更新时间",
  `update_user` varchar(384) NULL COMMENT "更新人",
  `log_time` datetime NULL COMMENT "",
  `has_warning` smallint(6) NULL COMMENT "实验是否已告警 1-以告警 0-未告警",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "AB测试实验日志表"
DISTRIBUTED BY HASH(`id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "experiment_id, version",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
