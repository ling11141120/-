CREATE TABLE `ads_temp_employee_project_seq` (
  `employee_name` varchar(50) NULL COMMENT "姓名",
  `project_name` varchar(200) NULL COMMENT "项目名称",
  `seq_no` decimal(10, 2) NULL COMMENT "占比"
) ENGINE=OLAP 
DUPLICATE KEY(`employee_name`, `project_name`)
COMMENT "临时-人员项目占比"
DISTRIBUTED BY HASH(`employee_name`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);