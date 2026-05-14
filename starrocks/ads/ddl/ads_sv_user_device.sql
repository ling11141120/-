CREATE TABLE `ads_sv_user_device` (
  `manufacturer` varchar(100) NOT NULL COMMENT "设备制造商",
  `model` varchar(100) NOT NULL COMMENT "设备型号",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`manufacturer`, `model`)
COMMENT "海剧-海剧用户设备信息-处理小米渠道包支付异常"
DISTRIBUTED BY HASH(`manufacturer`, `model`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);