CREATE TABLE `dws_cr_ad_advertising_cost_di` (
  `dt` date NOT NULL COMMENT "日期（createtime）",
  `type` int(11) NOT NULL COMMENT "投放渠道类型（1facbook,2其他渠道）3:国内短剧",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NOT NULL COMMENT "corever",
  `current_language2` int(11) NOT NULL COMMENT "投放语言",
  `mt` int(11) NOT NULL COMMENT "平台（终端）",
  `cost_amt` decimal(10, 2) NULL COMMENT "投放金额",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `type`, `product_id`, `corever`, `current_language2`, `mt`)
COMMENT "国内小程序阅读-按天投放广费用表"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);
