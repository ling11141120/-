CREATE TABLE `dws_content_translate_product_info_di` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `bill_date` int(11) NOT NULL COMMENT "产品id",
  `to_language` int(11) NOT NULL COMMENT "语言",
  `author_id` int(11) NOT NULL COMMENT "译员id",
  `pen_name` varchar(255) NOT NULL COMMENT "笔名",
  `real_name` varchar(255) NOT NULL COMMENT "姓名",
  `month_target` int(11) NULL COMMENT "月度产能目标",
  `book_product` int(11) NULL COMMENT "网文产能",
  `short_video_product` decimal(18, 6) NULL COMMENT "短剧产能",
  `project` int(11) NULL COMMENT "1:网文，2：短剧",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `bill_date`, `to_language`, `author_id`, `pen_name`, `real_name`)
COMMENT "阅读内容-二教产能看板（编辑后台-新稿酬审核数据源（网文及短剧项目）"
DISTRIBUTED BY HASH(`dt`, `author_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
