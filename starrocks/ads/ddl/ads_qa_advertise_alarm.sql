CREATE TABLE `ads_qa_advertise_alarm` (
  `dt` date NULL COMMENT "日期(事件时间)",
  `product_id` int(11) NULL COMMENT "产品id",
  `ProductTypeName` varchar(65533) NULL COMMENT "产品名",
  `mt` varchar(65533) NULL COMMENT "设备",
  `corever` varchar(65533) NULL COMMENT "core",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `user_type` varchar(65533) NULL COMMENT "用户类型",
  `f3` varchar(65533) NULL COMMENT "归因来源",
  `total_num` bigint(20) NULL COMMENT "总人数",
  `read_num` bigint(20) NULL COMMENT "首次人数",
  `read_rate` decimal(20, 4) NULL COMMENT "阅读一致率",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "广告拉起,阅读一致率，钉钉告警"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);