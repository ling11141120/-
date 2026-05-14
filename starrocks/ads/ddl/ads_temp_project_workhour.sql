CREATE TABLE `ads_temp_project_workhour` (
  `work_year` int(11) NULL COMMENT "年度",
  `work_month` int(11) NULL COMMENT "月份",
  `employee_name` varchar(50) NULL COMMENT "姓名",
  `rd_code` varchar(50) NULL COMMENT "RD编码",
  `project_name` varchar(200) NULL COMMENT "项目名称",
  `work_hours` double NULL COMMENT "工时",
  `attendance_days` double NULL COMMENT "当月出勤天数"
) ENGINE=OLAP 
DUPLICATE KEY(`work_year`, `work_month`, `employee_name`, `rd_code`, `project_name`)
COMMENT "临时-项目工时"
DISTRIBUTED BY HASH(`rd_code`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);