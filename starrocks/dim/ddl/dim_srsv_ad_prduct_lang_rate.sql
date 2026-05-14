CREATE TABLE `dim_srsv_ad_prduct_lang_rate` (
  `product` varchar(50) NOT NULL COMMENT "项目语言",
  `lang_id` int(11) NOT NULL COMMENT "语言id",
  `lang` varchar(50) NOT NULL COMMENT "语言",
  `lang_rate` decimal(10, 2) NULL COMMENT "语言系数",
  `group_spend` int(11) NULL COMMENT "专属组周花费",
  `sunday_rate` decimal(10, 2) NULL COMMENT "周日系数",
  `friday_rate` decimal(10, 2) NULL COMMENT "周五系数",
  `base_rate` decimal(10, 2) NULL COMMENT "席位底数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product`, `lang_id`)
COMMENT "广告基建，语言参数"
DISTRIBUTED BY HASH(`product`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);