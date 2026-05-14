CREATE TABLE `ads_sv_new_series_external_campaigns_user` (
  `project_id` int(11) NOT NULL COMMENT "项目类型 1=海阅|2=海剧",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `language_id` int(11) NULL COMMENT "语言id",
  `begin_date` date NULL COMMENT "开始测投时间（预测投时间）",
  `is_plan_created` int(11) NULL COMMENT "是否创建计划（已创建计划为1，未创建计划为0）",
  `is_toufang` int(11) NULL COMMENT "是否投放（符合投放条件为1，不符合条件为0）",
  `sync_time` datetime NULL COMMENT "同步时间",
  `create_time` datetime NULL COMMENT "创建时间",
  `creator` varchar(255) NULL COMMENT "创建人",
  `creator_uid` varchar(255) NULL COMMENT "创建人",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`project_id`, `product_id`, `series_id`)
COMMENT "海剧-自动化-新剧站外测投用户配置"
DISTRIBUTED BY HASH(`project_id`, `product_id`, `series_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);