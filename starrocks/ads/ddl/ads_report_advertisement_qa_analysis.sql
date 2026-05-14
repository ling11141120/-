CREATE TABLE `ads_report_advertisement_qa_analysis` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NOT NULL COMMENT "core",
  `dau` int(11) NOT NULL COMMENT "活跃用户",
  `ads_user` int(11) NULL COMMENT "广告用户数（来源userwatchvideo3log）",
  `crash_1d` decimal(10, 4) NULL COMMENT "1日崩溃率",
  `crash_7d` decimal(10, 4) NULL COMMENT "7日崩溃率",
  `crash_all` decimal(10, 4) NULL COMMENT "崩溃率",
  `crash_today` decimal(10, 4) NULL COMMENT "全版本当日崩溃率",
  `anr_1d` decimal(10, 4) NULL COMMENT "1日anr率",
  `anr_7d` decimal(10, 4) NULL COMMENT "7日anr率",
  `anr_all` decimal(10, 4) NULL COMMENT "anr率",
  `anr_today` decimal(10, 4) NULL COMMENT "全版本当日anr率",
  `total_memory` int(11) NULL COMMENT "总内存数",
  `device_num` int(11) NULL COMMENT "设备数",
  `available_memory` int(11) NULL COMMENT "可用内存数",
  `available_memory_device_id` int(11) NULL COMMENT "可用内存命中设备数",
  `total_device_id` int(11) NULL COMMENT "命中人数（命中设备数）",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `corever`)
COMMENT "qa需求-广告降权数据总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `corever`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);