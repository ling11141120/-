CREATE TABLE `ods_tidb_bd_user_group_group_info` (
  `group_id` int(11) NOT NULL COMMENT "分群id",
  `group_name` varchar(955) NOT NULL COMMENT "名称",
  `status` int(11) NOT NULL COMMENT "状态（1启用 、2禁用）",
  `group_type` int(11) NOT NULL COMMENT "包类型（1静态-文件包、2静态-系统包、3动态-系统包）",
  `join_days` int(11) NOT NULL COMMENT "可参与天数",
  `can_repeated` int(11) NULL COMMENT "可重复入包(0不可重复 、1 可重复)",
  `effect_time` datetime NULL COMMENT "生效时间",
  `exec_start_time` datetime NULL COMMENT "跑包周期开始",
  `exec_end_time` datetime NULL COMMENT "跑包周期截止",
  `setting_info` varchar(65533) NULL COMMENT "配置信息json",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(56) NULL COMMENT "创建人",
  `update_time` datetime NULL COMMENT "修改时间",
  `update_user` varchar(56) NULL COMMENT "修改人",
  `used_scene` varchar(65533) NULL COMMENT "是否被使用(0 未使用、 1已使用)",
  `run_status` int(11) NULL COMMENT "跑包状态(1 等待计算中、2 计算中、3 计算成功、4计算失败)",
  `user_count` int(11) NULL COMMENT "人数",
  `product_id` varchar(300) NULL COMMENT "产品id",
  `remainder` int(11) NULL COMMENT "取模（0/10/100/1000/10000）",
  `run_time` datetime NULL COMMENT "跑包时间",
  `is_delete` int(11) NULL DEFAULT "0" COMMENT "是否删除",
  `execl_url` varchar(1500) NULL COMMENT "静态包地址",
  `status_change_time` datetime NULL COMMENT "禁用状态时间",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`group_id`)
COMMENT "分群包主息表"
DISTRIBUTED BY HASH(`group_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
