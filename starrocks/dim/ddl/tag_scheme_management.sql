CREATE TABLE `tag_scheme_management` (
  `scheme_id` int(11) NOT NULL COMMENT "方案id",
  `plan_code` varchar(300) NULL COMMENT "策略代号",
  `scheme_name` varchar(65533) NULL COMMENT "方案名称",
  `is_vip_adSource` int(11) NULL COMMENT "是否VIP引流（0否，1是）",
  `use_type` int(11) NULL COMMENT "使用类型",
  `scheme_type` int(11) NULL COMMENT "方案属性",
  `dt` datetime NULL COMMENT "时间",
  `Flow` int(11) NULL COMMENT "流量类型",
  `status` int(11) NULL COMMENT "状态",
  `weight` int(11) NULL COMMENT "权重",
  `create_time` datetime NULL COMMENT "创建时间",
  `apply_type` int(11) NULL COMMENT "应用类型",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`scheme_id`)
COMMENT "TAG方案管理"
DISTRIBUTED BY HASH(`scheme_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);