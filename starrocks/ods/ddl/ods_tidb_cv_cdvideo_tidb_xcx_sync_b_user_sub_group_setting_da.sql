CREATE TABLE `ods_tidb_cv_cdvideo_tidb_xcx_sync_b_user_sub_group_setting_da` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NULL COMMENT "原表主键_id",
  `parent_id` bigint(20) NULL COMMENT "是父包id",
  `group_id` bigint(20) NULL COMMENT "分组id",
  `name` varchar(65533) NULL COMMENT "用户组名",
  `type` int(11) NULL COMMENT "1 实时包 2静态包",
  `remainder_range_start` int(11) NULL COMMENT "取模余数起点",
  `remainder_range_end` int(11) NULL COMMENT "取模余数重点",
  `status` varchar(65533) NULL COMMENT "用户组状态活，-1 软删除",
  `immediate_out_group` int(11) NULL COMMENT "不符合条件立即出包，1表示是，0表示否",
  `user_count` bigint(20) NULL COMMENT "用户数量",
  `runtime` datetime NULL COMMENT "跑包时间",
  `calc_time` datetime NULL COMMENT "计算时间",
  `creator` varchar(65533) NULL COMMENT "创建人",
  `modifier` varchar(65533) NULL COMMENT "修改人",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "人群包分组配置"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time, _update_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
