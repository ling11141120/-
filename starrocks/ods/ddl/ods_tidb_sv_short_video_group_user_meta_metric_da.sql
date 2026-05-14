CREATE TABLE `ods_tidb_sv_short_video_group_user_meta_metric_da` (
  `id` int(11) NOT NULL COMMENT "主键id",
  `project` varchar(512) NULL COMMENT "项目",
  `name` varchar(512) NULL COMMENT "名称",
  `data_type` varchar(512) NULL COMMENT "数据类型",
  `default_value` varchar(512) NULL COMMENT "默认值",
  `description` varchar(512) NULL COMMENT "描述",
  `metric_type` int(11) NULL DEFAULT "0" COMMENT "指标类型：0其他1单日累计2历史累计",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "真实字段元数据表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
