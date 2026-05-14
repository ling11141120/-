CREATE TABLE `ads_sv_series_type_filter_rank` (
  `dt` date NOT NULL COMMENT "日期",
  `series_type_id` bigint(20) NOT NULL COMMENT "标签id",
  `series_type_name` varchar(200) NOT NULL COMMENT "标签名称",
  `consume_value` int(11) NULL COMMENT "消费观看币数量",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_type_id`)
COMMENT "海剧-标签筛选榜单"
DISTRIBUTED BY HASH(`dt`, `series_type_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);