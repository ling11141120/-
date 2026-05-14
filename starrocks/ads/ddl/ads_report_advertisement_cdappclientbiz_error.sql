CREATE TABLE `ads_report_advertisement_cdappclientbiz_error` (
  `dt` date NULL COMMENT "事件时间",
  `product_id` int(11) NULL COMMENT "产品ID",
  `create_time` date NULL COMMENT "事件时间",
  `count_type` int(11) NULL COMMENT "1：小时数据 2：按天数据",
  `mt` varchar(10) NULL COMMENT "终端",
  `corever` int(11) NULL COMMENT "corever",
  `adid` varchar(65533) NULL COMMENT "广告ID",
  `ad_position` varchar(65533) NULL COMMENT "广告位置",
  `error_type` varchar(65533) NULL COMMENT "错误类型",
  `error_code` varchar(65533) NULL COMMENT "错误码",
  `ad_inter_mediary` varchar(65533) NULL COMMENT "广告中介(广告来源)",
  `place_ment_id` varchar(65533) NULL COMMENT "放置id",
  `nums` int(11) NULL COMMENT "人数",
  `times` int(11) NULL COMMENT "时长",
  `etl_time` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `create_time`)
COMMENT "沙盘-广告错误报表数据"
DISTRIBUTED BY HASH(`dt`, `product_id`, `create_time`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "adid, create_time, error_type, error_code",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);