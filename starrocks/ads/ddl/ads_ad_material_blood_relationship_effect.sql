CREATE TABLE `ads_ad_material_blood_relationship_effect` (
  `asset_guid` varchar(200) NOT NULL COMMENT "素材id",
  `project_id` bigint(20) NULL COMMENT "项目",
  `current_language` varchar(50) NULL COMMENT "投放语言",
  `source_chl_type` bigint(20) NULL COMMENT "媒体",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `meterial_id` bigint(20) NULL COMMENT "上传任务id",
  `fission_parent_id` varchar(200) NULL COMMENT "父级素材id",
  `is_replica` bigint(20) NULL COMMENT "是否复刻",
  `ad_group_count` bigint(20) NULL COMMENT "广告组数",
  `ad_spend` decimal(12, 2) NULL COMMENT "广告花费",
  `ad_revenue` decimal(12, 2) NULL COMMENT "广告收入",
  `activation_count` bigint(20) NULL COMMENT "激活数",
  `impression_count` bigint(20) NULL COMMENT "展示数",
  `link_click_count` bigint(20) NULL COMMENT "链接点击数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`asset_guid`)
COMMENT "素材血缘关系效果"
DISTRIBUTED BY HASH(`asset_guid`) BUCKETS 4 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);