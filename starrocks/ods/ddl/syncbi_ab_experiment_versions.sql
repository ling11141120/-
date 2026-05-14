CREATE TABLE `syncbi_ab_experiment_versions` (
  `id` bigint(20) NOT NULL COMMENT "ID",
  `is_default` tinyint(4) NULL DEFAULT "1" COMMENT "0是默认版本 1非默认",
  `version_number` varchar(128) NOT NULL COMMENT "版本号",
  `version_name` varchar(128) NOT NULL COMMENT "版本名称",
  `version_type` smallint(6) NOT NULL COMMENT "版本类型：1-对照组 2-实验组",
  `version_description` varchar(65533) NULL COMMENT "版本描述",
  `traffic_allocation` double NULL COMMENT "流量分配",
  `experiment_version` bigint(20) NULL COMMENT "版本",
  `experiment_id` bigint(20) NOT NULL COMMENT "所属实验ID",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(128) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "更新时间",
  `update_user` varchar(128) NULL COMMENT "更新人",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "实验版本表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "version_number, id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
