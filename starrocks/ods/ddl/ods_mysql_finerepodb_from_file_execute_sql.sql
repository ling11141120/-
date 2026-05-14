CREATE TABLE `ods_mysql_finerepodb_from_file_execute_sql` (
  `database_name` varchar(255) NOT NULL COMMENT "",
  `table_name` varchar(1000) NULL COMMENT "",
  `file_short_name` varchar(1000) NULL COMMENT "文件短路径名称",
  `file_name` varchar(1000) NULL COMMENT "文件名称",
  `sql` varchar(65533) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT "dt",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`database_name`, `table_name`)
COMMENT "finebReport sql 数据"
DISTRIBUTED BY HASH(`database_name`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
