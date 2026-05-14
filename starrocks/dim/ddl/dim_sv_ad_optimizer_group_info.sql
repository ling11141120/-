CREATE TABLE `dim_sv_ad_optimizer_group_info` (
  `ad_optimizer_uid` varchar(50) NOT NULL COMMENT "优化师id",
  `product` varchar(50) NULL COMMENT "项目",
  `ad_optimizer_group` varchar(50) NULL COMMENT "优化师组",
  `ad_optimizer_name` varchar(50) NULL COMMENT "优化师名称"
) ENGINE=OLAP 
PRIMARY KEY(`ad_optimizer_uid`)
DISTRIBUTED BY HASH(`ad_optimizer_uid`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);