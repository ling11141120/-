CREATE TABLE `dim_ads_source_abbr` (
  `ads_name` varchar(50) NOT NULL COMMENT "广告来源-广告平台 (adomob,topon,max)",
  `ads_source` varchar(200) NOT NULL COMMENT "admob广告源,可通过这个反推是哪家具体的广告",
  `ads_source_abbr` varchar(200) NULL COMMENT "admob广告源缩写"
) ENGINE=OLAP 
PRIMARY KEY(`ads_name`, `ads_source`)
COMMENT "admob广告源映射表"
DISTRIBUTED BY HASH(`ads_name`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);