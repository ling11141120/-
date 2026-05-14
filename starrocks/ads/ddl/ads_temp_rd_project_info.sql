CREATE TABLE `ads_temp_rd_project_info` (
  `year_no` varchar(10) NOT NULL COMMENT "年度",
  `rd_code` varchar(50) NULL COMMENT "RD编码",
  `project_name` varchar(200) NULL COMMENT "项目名称",
  `project_period` varchar(100) NULL COMMENT "项目建设期"
) ENGINE=OLAP 
DUPLICATE KEY(`year_no`, `rd_code`, `project_name`)
COMMENT "临时-RD项目立项信息"
DISTRIBUTED BY HASH(`year_no`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);