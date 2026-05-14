CREATE TABLE `ads_temp_workday_calendar` (
  `work_date` date NULL COMMENT "日期",
  `workday_name` varchar(50) NULL COMMENT "工作日",
  `is_workday` varchar(20) NULL COMMENT "是否工作日",
  `remark` varchar(500) NULL COMMENT "备注"
) ENGINE=OLAP 
DUPLICATE KEY(`work_date`)
COMMENT "临时-工作日历"
DISTRIBUTED BY HASH(`work_date`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);