CREATE TABLE `ads_temp_employee_info` (
  `id` varchar(30) NOT NULL COMMENT "序号",
  `company` varchar(100) NULL COMMENT "公司",
  `level1_department` varchar(100) NULL COMMENT "1级部门",
  `employee_name` varchar(50) NULL COMMENT "姓名",
  `position_name` varchar(100) NULL COMMENT "职位",
  `hire_date` datetime NULL COMMENT "入职时间",
  `certificate_no` varchar(50) NULL COMMENT "证件号码",
  `gender` varchar(10) NULL COMMENT "性别",
  `leave_date` datetime NULL COMMENT "离职时间"
) ENGINE=OLAP 
DUPLICATE KEY(`id`)
COMMENT "临时-员工信息"
DISTRIBUTED BY HASH(`id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);