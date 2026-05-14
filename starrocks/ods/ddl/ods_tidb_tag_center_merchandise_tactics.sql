CREATE TABLE `ods_tidb_tag_center_merchandise_tactics` (
  `scene_type` int(11) NOT NULL COMMENT "场景id：1-商品策略，2-半屏推，3-即充即消",
  `tactics_id` int(11) NOT NULL COMMENT "策略id",
  `tactics_name` varchar(1024) NULL COMMENT "策略名称",
  `data_type` int(11) NOT NULL COMMENT "数据类型（1正式，2测试）",
  `begin_time` datetime NULL COMMENT "开始时间",
  `end_time` datetime NULL COMMENT "结束时间",
  `j_group_ids` varchar(1024) NULL COMMENT "极光人群包",
  `exclude_j_group_ids` varchar(1024) NULL COMMENT "剔除极光人群包",
  `pattern_type` int(11) NULL COMMENT "档位模式 1灵活配置,2活动专区",
  `merchandise_type` int(11) NULL COMMENT "商品类型（1充值)",
  `status` int(11) NULL COMMENT "状态（0关闭，1开启）",
  `audit_status` int(11) NULL COMMENT "审核状态（0审核中，1通过，2不通过）",
  `sort` int(11) NULL COMMENT "排序",
  `plan_code` varchar(500) NULL COMMENT "策略代号",
  `create_id` varchar(1024) NULL COMMENT "账号",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`scene_type`, `tactics_id`)
COMMENT "tag,商品策略"
DISTRIBUTED BY HASH(`scene_type`, `tactics_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
