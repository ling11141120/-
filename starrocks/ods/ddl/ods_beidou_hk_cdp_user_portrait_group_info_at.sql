CREATE TABLE `ods_beidou_hk_cdp_user_portrait_group_info_at` (
  `id` int(11) NOT NULL COMMENT "分群id",
  `group_id` int(11) NULL COMMENT "分组id",
  `group_name` varchar(1000) NULL COMMENT "名称",
  `status` int(11) NULL COMMENT "状态（1启用 、2禁用）",
  `join_days` int(11) NULL COMMENT "可参与天数",
  `can_repeated` int(11) NULL COMMENT "可重复入包(0不可重复 、1 可重复)",
  `exec_start_time` datetime NULL COMMENT "跑包周期开始",
  `exec_end_time` datetime NULL COMMENT "跑包周期截止",
  `setting_info` varchar(65533) NULL COMMENT "配置信息json",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(100) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "修改时间",
  `update_user` varchar(100) NULL COMMENT "修改人",
  `used_scene` varchar(65533) NULL COMMENT "使用场景",
  `run_time` datetime NULL COMMENT "跑包时间",
  `user_count` int(11) NULL COMMENT "人数",
  `remainder` int(11) NULL COMMENT "取模（0/10/100/1000/10000）",
  `is_delete` int(11) NULL COMMENT "是否删除",
  `is_open_alert` int(11) NULL COMMENT "是否开启告警（0否，1是）",
  `sub_type` int(11) NULL COMMENT "子包类型（0未知，1对照组，2实验组）",
  `status_change_time` datetime NULL COMMENT "禁用状态变更时间",
  `parent_group_id` int(11) NULL COMMENT "父分群id（主包为0）",
  `groups_detail` varchar(2000) NULL COMMENT "取模明细",
  `product_id` varchar(500) NULL COMMENT "产品id",
  `is_out_of_package_not_met_condition` int(11) NULL COMMENT "不符合条件是否立即出包",
  `hash_id` bigint(20) NULL COMMENT "hash编号",
  `hash_rule` int(11) NULL COMMENT "哈希规则 1 顺序入包 2完全随机",
  `project_id` int(11) NULL COMMENT "项目id:1海阅；2国内短剧；3海外短剧",
  `white_list` varchar(65533) NULL COMMENT "白名单，用户id逗号隔开",
  `white_ids` varchar(2000) NULL COMMENT "白名单关联id列表",
  `supplement_white_list` varchar(3000) NULL COMMENT "补充白名单列表",
  `compute_status` int(11) NULL COMMENT "计算状态：1创建中；2正常运行；3创建异常",
  `create_user_id` varchar(200) NULL COMMENT "创建人id",
  `update_user_id` varchar(200) NULL COMMENT "更新人id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "北斗-实时人群包表"
DISTRIBUTED BY HASH(`id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
