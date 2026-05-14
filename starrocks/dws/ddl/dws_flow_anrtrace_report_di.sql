CREATE TABLE `dws_flow_anrtrace_report_di` (
  `dt` date NOT NULL COMMENT "事件分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NOT NULL COMMENT "包体",
  `mt` varchar(50) NOT NULL COMMENT "终端",
  `appver` varchar(50) NOT NULL COMMENT "版本号",
  `report_cnt` int(11) NULL COMMENT "上报次数",
  `device_cnt` int(11) NULL COMMENT "设备数",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `corever`, `mt`, `appver`)
COMMENT "阅读-（anr跟踪事件）  广告阻止事件上报次数汇总"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
