CREATE TABLE `ads_audit_operation_data` (
  `ym` date NOT NULL COMMENT "年月",
  `project_id` varchar(500) NOT NULL COMMENT "项目",
  `mau` int(11) NULL COMMENT "平均月活",
  `user_num` int(11) NULL COMMENT "累积注册用户数"
) ENGINE=OLAP 
PRIMARY KEY(`ym`, `project_id`)
DISTRIBUTED BY HASH(`ym`, `project_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);