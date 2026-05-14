CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_sync_b_user_group_setting` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `_id` varchar(100) NOT NULL COMMENT "用户组ID",
  `group_id` bigint(20) NULL COMMENT "分组ID",
  `name` varchar(100) NULL COMMENT "用户组名称",
  `status` int(11) NULL COMMENT "用户组状态",
  `type` int(11) NULL COMMENT "1 实时包 2静态包,-1表示类型转换失败",
  `join_days` int(11) NULL COMMENT "入组天数",
  `can_repeated` int(11) NULL COMMENT "是否允许重复加入，1表示允许，0表示不允许,-1表示类型转换失败",
  `immediate_out_group` int(11) NULL COMMENT "不符合条件立即出包，1表示是，0表示否,-1表示类型转换失败",
  `hash` bigint(20) NULL COMMENT "哈希ID",
  `exec_start_time` datetime NULL COMMENT "执行开始时间",
  `exec_end_time` datetime NULL COMMENT "执行结束时间",
  `user_count` bigint(20) NULL COMMENT "用户数量",
  `remainder` int(11) NULL COMMENT "分组取模",
  `is_init` int(11) NULL COMMENT "是否初始化，1表示是，0表示否,-1表示类型转换失败",
  `runtime` datetime NULL COMMENT "开始跑包时间",
  `create_time` datetime NOT NULL COMMENT "添加时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `has_used` int(11) NULL COMMENT "是否已使用，1表示是，0表示否,-1表示类型转换失败",
  `creator` varchar(2000) NULL COMMENT "创建者名称",
  `modifier` varchar(2000) NULL COMMENT "修改者名称",
  `setting` varchar(65533) NULL COMMENT "配置",
  `update_time` datetime NOT NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "人群包配置表，author:510161"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
