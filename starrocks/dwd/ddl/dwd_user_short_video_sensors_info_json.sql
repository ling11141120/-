CREATE TABLE `dwd_user_short_video_sensors_info_json` (
  `account` varchar(1048576) NOT NULL COMMENT "",
  `jon` varchar(1048576) NULL COMMENT "",
  `etl_time` datetime NOT NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`account`)
DISTRIBUTED BY HASH(`account`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);