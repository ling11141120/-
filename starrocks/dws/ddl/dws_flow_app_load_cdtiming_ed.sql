CREATE TABLE `dws_flow_app_load_cdtiming_ed` (
  `dt` date NOT NULL COMMENT "分区日期",
  `product_id` int(11) NULL COMMENT "产品id",
  `corever` int(11) NULL COMMENT "core",
  `mt` varchar(100) NULL COMMENT "终端",
  `app_ver` varchar(100) NULL COMMENT "app版本",
  `positions` int(11) NULL COMMENT "页面位置",
  `tps` int(11) NULL COMMENT "类型 7为页面加载时长8为接口加载时长",
  `channel_id` int(11) NULL COMMENT "书城特定频道的上报",
  `cd_tms` decimal(24, 3) NULL COMMENT "加载时长(s)",
  `cd_cnt` int(11) NULL COMMENT "加载次数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "event=CDTiming app页面加载时长按维度聚合数据"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
