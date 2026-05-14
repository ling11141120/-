CREATE TABLE `ads_srsv_material_rating_probability_pre` (
  `md5_key` varchar(255) NOT NULL COMMENT "md5_key",
  `asset_guid` varchar(65533) NULL COMMENT "素材id",
  `language_name` varchar(65533) NULL COMMENT "语言",
  `code` varchar(65533) NULL COMMENT "短剧code",
  `materia_uid` varchar(500) NULL COMMENT "剪辑师工号",
  `materia_name` varchar(1000) NULL COMMENT "素材名称",
  `bm_compelete_time` datetime NULL COMMENT "",
  `project_code` int(11) NULL COMMENT "",
  `source_chl` varchar(65533) NULL COMMENT "媒体",
  `source_chl_type` int(11) NULL COMMENT "",
  `language_asset` varchar(255) NULL COMMENT "素材语言或语言分类",
  `asset_type` varchar(255) NULL COMMENT "是否定制",
  `code_type` varchar(255) NULL COMMENT "素材分类",
  `material_type` varchar(200) NULL COMMENT "素材类型",
  `date_key` date NULL COMMENT "投放日期",
  `is_mai` varchar(500) NULL COMMENT "mai标识",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `spend` decimal(16, 6) NULL COMMENT "当日花费",
  `impressions` int(11) NULL COMMENT "当日展示量",
  `clicks` int(11) NULL COMMENT "当日点击互动",
  `link_clicks` int(11) NULL COMMENT "当日链接点击",
  `installs` int(11) NULL COMMENT "当日激活",
  `amount` decimal(16, 6) NULL COMMENT "当日H24收入",
  `amount_std` decimal(16, 6) NULL COMMENT "收入目标",
  `channel` varchar(2000) NULL COMMENT "频道",
  `new_cid_name` varchar(2000) NULL COMMENT "分类",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`md5_key`)
COMMENT "海阅-素材评分和概率-底表一"
DISTRIBUTED BY HASH(`md5_key`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);