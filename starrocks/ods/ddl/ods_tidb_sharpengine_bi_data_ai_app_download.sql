CREATE TABLE `ods_tidb_sharpengine_bi_data_ai_app_download` (
  `dt` date NOT NULL COMMENT "开始日期",
  `country_code` varchar(5) NOT NULL COMMENT "国家码",
  `device_code` varchar(50) NOT NULL COMMENT "设备码",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `granularity` varchar(50) NOT NULL COMMENT "时间维度",
  `end_date` datetime NOT NULL COMMENT "结束日期",
  `est_download` int(11) NULL COMMENT "下载量",
  `est_organic_download` int(11) NULL COMMENT "自然下载量",
  `est_organic_featured_download` int(11) NULL COMMENT "自然下载量",
  `est_organic_search_download` int(11) NULL COMMENT "自然搜索下载量",
  `est_paid_ads_download` int(11) NULL COMMENT "付费广告下载量",
  `est_paid_channel_download` int(11) NULL COMMENT "付费频道下载量",
  `est_paid_search_download` int(11) NULL COMMENT "付费搜索下载量",
  `updatetime` datetime NOT NULL COMMENT "更新时间",
  `inittime` datetime NOT NULL COMMENT "写入时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `country_code`, `device_code`, `product_id`)
COMMENT "app统计下载量表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
