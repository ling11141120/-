CREATE TABLE `ads_read_readtime_cnt_l1d` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` varchar(65533) NOT NULL COMMENT "产品id",
  `type_vaule` varchar(65533) NOT NULL COMMENT "类型值 1 用户 2clientip 3 UniqueCdReaderId  4 read ",
  `user_id` varchar(65533) NULL COMMENT "userid",
  `types` int(11) NULL COMMENT "类型值 1 用户 2clientip 3 UniqueCdReaderId  4 read ",
  `type_name` varchar(65533) NULL COMMENT "类型名称 类型值 1 用户 2clientip 3 UniqueCdReaderId  4 read ",
  `mt` varchar(65533) NULL COMMENT "mt",
  `app_ver` varchar(65533) NULL COMMENT "app_ver",
  `cnt` int(11) NULL COMMENT "章节数量未去重",
  `percentile_cnt` int(11) NULL COMMENT "阅读章节中位数",
  `avg_times` decimal(20, 4) NULL COMMENT "平均每章阅读时长",
  `times` int(11) NULL COMMENT "总阅读时长",
  `etl_tm` varchar(65533) NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `type_vaule`)
DISTRIBUTED BY HASH(`type_vaule`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);