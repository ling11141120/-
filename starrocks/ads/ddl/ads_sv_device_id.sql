CREATE TABLE `ads_sv_device_id` (
  `unique_cd_reader_id` varchar(300) NOT NULL COMMENT "唯一读卡器ID，UNI索引"
) ENGINE=OLAP 
PRIMARY KEY(`unique_cd_reader_id`)
COMMENT "海剧设备id"
DISTRIBUTED BY HASH(`unique_cd_reader_id`) BUCKETS 100 
PROPERTIES (
"replication_num" = "2",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);