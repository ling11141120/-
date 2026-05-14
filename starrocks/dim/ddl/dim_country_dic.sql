CREATE TABLE `dim_country_dic` (
  `country_json` varchar(65533) NOT NULL COMMENT "配置信息",
  `country` varchar(65533) NOT NULL COMMENT "国家",
  `code` varchar(65533) NULL COMMENT "简称"
) ENGINE=OLAP 
PRIMARY KEY(`country_json`, `country`)
COMMENT "国家简称表"
DISTRIBUTED BY HASH(`country_json`, `country`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);