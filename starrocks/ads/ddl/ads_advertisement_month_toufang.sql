CREATE TABLE `ads_advertisement_month_toufang` (
  `datetypes` int(11) NOT NULL COMMENT "时间维度统计类型：1：本月 2：上个月",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `month_spend` decimal(20, 6) NULL COMMENT "投放金额(同期投放)",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_datetypes (`datetypes`) USING BITMAP COMMENT 'datetypes索引'
) ENGINE=OLAP 
PRIMARY KEY(`datetypes`, `product_id`)
COMMENT "沙盘首页-广告域月份同期投放表"
DISTRIBUTED BY HASH(`datetypes`, `product_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);