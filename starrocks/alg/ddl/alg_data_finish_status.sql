CREATE TABLE `alg_data_finish_status` (
  `tbl_nm` varchar(50) NOT NULL COMMENT "表名",
  `date_time` date NOT NULL COMMENT "更新时间",
  `etl_tm` datetime NULL COMMENT "统计时间"
) ENGINE=OLAP 
PRIMARY KEY(`tbl_nm`, `date_time`)
COMMENT "更新状态表"
DISTRIBUTED BY HASH(`tbl_nm`, `date_time`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);