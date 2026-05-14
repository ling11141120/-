CREATE TABLE `ods_tidb_sr_cdcreator_tidb_cn_cp_userinfo` (
  `id` bigint(20) NOT NULL COMMENT "自增ID",
  `uuid` varchar(65533) NULL COMMENT "Guid",
  `cp_name` varchar(65533) NULL COMMENT "版权方名称",
  `cp_type` int(11) NULL COMMENT "版权方类型(1-引入,2-自研)",
  `product_type` int(11) NULL COMMENT "产品类型(1-短剧,2-阅读)",
  `company_name` varchar(65533) NULL COMMENT "公司名称",
  `userid` varchar(65533) NULL COMMENT "用户Id，b_userinfo_tb.UserId",
  `account` varchar(65533) NULL COMMENT "登录账号，b_userinfo_tb.account",
  `status` varchar(65533) NULL COMMENT "账号状态(1-启用,2-禁用)",
  `is_allowed_login` varchar(65533) NULL COMMENT "是否允许登录(1-是,0-否)",
  `add_user` varchar(65533) NULL COMMENT "添加人",
  `add_time` datetime NULL COMMENT "添加时间",
  `update_user` varchar(65533) NULL COMMENT "更新人",
  `update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "各业务线版权方用户表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
