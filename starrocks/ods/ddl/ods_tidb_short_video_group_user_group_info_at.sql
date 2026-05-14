CREATE TABLE `ods_tidb_short_video_group_user_group_info_at` (
  `group_id` int(11) NOT NULL COMMENT "分群id",
  `group_name` varchar(65533) NOT NULL COMMENT "名称",
  `status` int(11) NOT NULL COMMENT "状态（1启用 、2禁用）",
  `join_days` int(11) NOT NULL COMMENT "可参与天数",
  `can_repeated` int(11) NULL COMMENT "可重复入包(0不可重复 、1 可重复)",
  `exec_start_time` datetime NULL COMMENT "跑包周期开始",
  `exec_end_time` datetime NULL COMMENT "跑包周期截止",
  `setting_info` varchar(65533) NULL COMMENT "配置信息json",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(65533) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "修改时间",
  `update_user` varchar(65533) NULL COMMENT "修改人",
  `used_scene` varchar(65533) NULL COMMENT "使用场景",
  `run_time` datetime NULL COMMENT "跑包时间",
  `user_count` int(11) NULL COMMENT "人数",
  `remainder` int(11) NULL COMMENT "取模（0/10/100/1000/10000）",
  `is_delete` int(11) NULL COMMENT "是否删除",
  `status_change_time` datetime NULL COMMENT "禁用状态变更时间",
  `parent_group_id` int(11) NULL COMMENT "父分群id（主包为0）",
  `groups_detail` varchar(65533) NULL COMMENT "取模明细",
  `product_id` varchar(65533) NULL COMMENT "产品id",
  `is_out_of_package_not_met_condition` datetime NULL COMMENT "不符合条件是否立即出包",
  `system_type` int(11) NULL COMMENT "目类别(1 阅读项目 、2 短剧项目)",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`group_id`)
COMMENT "海外短剧人群包表"
DISTRIBUTED BY HASH(`group_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "group_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
