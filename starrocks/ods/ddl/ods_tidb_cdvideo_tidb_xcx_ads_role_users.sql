CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_ads_role_users` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `ref_id` varchar(65533) NOT NULL COMMENT "用户id",
  `username` varchar(65533) NULL COMMENT "用户名",
  `nickname` varchar(65533) NULL COMMENT "昵称",
  `role_json` varchar(65533) NULL COMMENT "角色类型",
  `mobile` varchar(65533) NULL COMMENT "手机号",
  `gender` int(11) NOT NULL COMMENT "性别",
  `agent` int(11) NOT NULL COMMENT "是否代理商",
  `status` int(11) NOT NULL COMMENT "状态",
  `commission_rate` float NOT NULL COMMENT "会扣率",
  `is_computed` int(11) NOT NULL COMMENT "",
  `middleman_id` varchar(65533) NULL COMMENT "机构id",
  `middleman_username` varchar(65533) NULL COMMENT "机构名称",
  `middleman_nickname` varchar(65533) NULL COMMENT "机构昵称",
  `create_time` datetime NULL COMMENT "创建时间",
  `last_login_ip` varchar(65533) NULL COMMENT "上次登录ip",
  `last_login_date` datetime NULL COMMENT "上次登录日期",
  `alias_id` varchar(600) NULL COMMENT "别名id",
  `alias_name` varchar(600) NULL COMMENT "别名",
  `operation_type` int(11) NULL COMMENT "机构类型，1 自营，2 非自营",
  `type` int(11) NOT NULL DEFAULT "0" COMMENT "类型, 2 星图",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧广告用户角色表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ref_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
