CREATE TABLE `ads_sv_new_series_external_campaigns` (
  `project_id` int(11) NOT NULL COMMENT "项目类型 1=海阅|2=海剧",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `language_id` int(11) NULL COMMENT "语言id",
  `series_title` varchar(100) NULL COMMENT "剧系列",
  `series_code` varchar(100) NULL COMMENT "剧代号",
  `series_name` varchar(2000) NULL COMMENT "剧名",
  `publish_status` int(11) NULL COMMENT "上架状态(1上架、3软下架、4定时上架)",
  `publish_date` datetime NULL COMMENT "上架时间",
  `series_level` int(11) NULL COMMENT "等级 1.S 2.A 3.B 4.C",
  `begin_date` date NULL COMMENT "开始测投时间（预测投时间）",
  `is_plan_created` int(11) NULL COMMENT "是否创建计划（已创建计划为1，未创建计划为0）",
  `is_toufang` int(11) NULL COMMENT "是否投放（符合投放条件为1，不符合条件为0）",
  `advanced_languages` varchar(2000) NULL COMMENT "进阶语种 {语言:投放花费}",
  `rn` int(11) NULL COMMENT "优先级排序（从小到大）",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP
PRIMARY KEY(`project_id`, `product_id`, `series_id`)
COMMENT "海剧-自动化-新剧站外测投"
DISTRIBUTED BY HASH(`project_id`, `product_id`, `series_id`) BUCKETS 10
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);