CREATE TABLE `alg_short_video_series_info_0604` (
  `series_code` varchar(50) NOT NULL COMMENT "代号",
  `series_id` varchar(50) NOT NULL COMMENT "剧id",
  `language_id` int(11) NULL COMMENT "语言id",
  `series_name` varchar(500) NULL COMMENT "剧名称",
  `series_level` varchar(50) NULL COMMENT "剧内容等级",
  `series_type_old` varchar(2000) NULL COMMENT "分类（旧）",
  `x` varchar(200) NULL COMMENT "",
  `series_type_new` varchar(2000) NULL COMMENT "分类",
  `description` varchar(30000) NULL COMMENT "简介"
) ENGINE=OLAP 
PRIMARY KEY(`series_code`, `series_id`)
DISTRIBUTED BY HASH(`series_code`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);