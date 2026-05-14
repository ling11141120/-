CREATE TABLE `dws_sv_material_result_ed` (
  `date_key` date NULL COMMENT "投放日期",
  `material_id` bigint(20) NULL COMMENT "素材任务id",
  `material_type` varchar(65533) NULL COMMENT "素材类型",
  `source_chl` varchar(65533) NULL COMMENT "媒体",
  `language_name` varchar(65533) NULL COMMENT "语言",
  `code` varchar(65533) NULL COMMENT "短剧code",
  `materia_uid` varchar(500) NULL COMMENT "剪辑师工号",
  `nick_name` varchar(500) NULL COMMENT "剪辑师名称",
  `materia_name` varchar(1000) NULL COMMENT "素材名称",
  `spend` decimal(16, 6) NULL COMMENT "当日花费",
  `impressions` int(11) NULL COMMENT "当日展示量",
  `clicks` int(11) NULL COMMENT "当日点击互动",
  `link_clicks` int(11) NULL COMMENT "当日链接点击",
  `installs` int(11) NULL COMMENT "当日激活",
  `amount` decimal(16, 6) NULL COMMENT "当日H24收入",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`date_key`, `material_id`)
COMMENT "海剧素材每日统计表"
DISTRIBUTED BY HASH(`date_key`, `material_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
