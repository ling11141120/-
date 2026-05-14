CREATE TABLE `ods_tidb_sv_short_video_group_user_group_tag_metric_mapping_da` (
  `tag_id` int(11) NOT NULL COMMENT "标签id",
  `system_type` int(11) NULL COMMENT "项目类别(1 阅读项目 、2 短剧项目)",
  `tag_name_en` varchar(512) NULL COMMENT "标签英文名",
  `metric_name_en` varchar(512) NULL COMMENT "指标英文名",
  `mapping_type` int(11) NULL COMMENT "映射类型（1一致、2映射字段、3映射天数差、4映射小时差）",
  `is_delete` int(11) NULL COMMENT "是否删除",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`tag_id`)
COMMENT "人群包标签-指标关系映射表"
DISTRIBUTED BY HASH(`tag_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "metric_name_en, tag_name_en",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
