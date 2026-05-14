CREATE TABLE `ads_user_sensors_adcontrol` (
  `dt` date NOT NULL COMMENT "日期",
  `lang` varchar(65533) NOT NULL COMMENT "语言",
  `corever` int(11) NOT NULL COMMENT "core",
  `device_id` varchar(65533) NOT NULL COMMENT "设备id",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `lang`, `corever`, `device_id`)
COMMENT "anr降权广告数据"
DISTRIBUTED BY HASH(`dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);