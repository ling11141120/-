CREATE TABLE `dim_tag_center_activity_da` (
  `dt` date NOT NULL COMMENT "日期",
  `activity_id` int(11) NOT NULL COMMENT "活动id",
  `activity_type` int(11) NOT NULL COMMENT "活动类型",
  `tactics_id` int(11) NOT NULL COMMENT "策略id",
  `activity_name` varchar(1024) NULL COMMENT "活动名称",
  `tactics_name` varchar(1024) NULL COMMENT "策略名称",
  `j_group_ids` varchar(3000) NULL COMMENT "极光人群包",
  `exclude_j_group_ids` varchar(3000) NULL COMMENT "剔除极光人群包",
  `begin_time` datetime NULL COMMENT "开始时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `create_id` varchar(1024) NULL COMMENT "账号",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `activity_id`, `activity_type`, `tactics_id`)
COMMENT "活动中心"
DISTRIBUTED BY HASH(`activity_id`, `activity_type`, `tactics_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);