CREATE TABLE `dim_srsv_ad_product_rand_info` (
  `dt` date NULL COMMENT "createtime 分区",
  `product` varchar(255) NULL COMMENT "产品id",
  `source2` varchar(255) NULL COMMENT "媒体平台",
  `current_language` varchar(255) NULL COMMENT "语言",
  `code_id` bigint(20) NULL COMMENT "书籍id",
  `ad_optimizer_group` varchar(65533) NULL COMMENT "优化师组",
  `ad_optimizer_uid` varchar(65533) NULL COMMENT "优化师工号",
  `nick_name` varchar(65533) NULL COMMENT "优化师名称",
  `rand_v` decimal(18, 4) NULL COMMENT "随机值",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "广告基建-随机值"
DISTRIBUTED BY HASH(`dt`, `product`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);