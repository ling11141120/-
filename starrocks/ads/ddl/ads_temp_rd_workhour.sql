CREATE TABLE `ads_temp_rd_workhour` (
  `year_no` varchar(10) NOT NULL COMMENT "年度",
  `month_no` varchar(10) NULL COMMENT "月份",
  `employee_name` varchar(50) NULL COMMENT "姓名",
  `rd_code` varchar(50) NULL COMMENT "RD编码",
  `project_name` varchar(200) NULL COMMENT "项目名称",
  `work_hours` decimal(12, 2) NULL COMMENT "工时",
  `attendance_days` decimal(12, 2) NULL COMMENT "当月出勤天数",
  `rd_workhour_alloc_rate` decimal(10, 4) NULL COMMENT "研发工时分配率"
) ENGINE=OLAP 
DUPLICATE KEY(`year_no`, `month_no`, `employee_name`, `rd_code`, `project_name`)
COMMENT "临时-RD项目工时分配"
DISTRIBUTED BY HASH(`year_no`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);