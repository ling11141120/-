CREATE TABLE `dws_koc_payorderinfo` (
  `dt` date NOT NULL COMMENT "日期",
  `code` varchar(65533) NOT NULL COMMENT "口令词",
  `ref_order_id` varchar(128) NOT NULL COMMENT "外部订单号",
  `story_id` bigint(20) NOT NULL COMMENT "故事 ID",
  `story_name` varchar(65533) NULL COMMENT "故事名称",
  `amount` decimal(18, 2) NULL COMMENT "金额数",
  `project_type` int(11) NULL COMMENT "项目类型 1=网文|2=短剧",
  `coo_order_status` int(11) NULL COMMENT "扣款状态，1-成功",
  `institution_user_id` varchar(65533) NULL COMMENT "机构用户 ID",
  `star_user_id` varchar(65533) NULL COMMENT "达人用户 ID",
  `create_time` datetime NULL COMMENT "创建时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_story_id (`story_id`) USING BITMAP
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `code`, `ref_order_id`, `story_id`)
COMMENT "KOC订单信息"
DISTRIBUTED BY HASH(`dt`, `code`, `ref_order_id`, `story_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
