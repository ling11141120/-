CREATE TABLE `ods_tidb_cr_cdnovel_tidb_xcx_sync_uni_id_users` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NULL COMMENT "原表主键_id",
  `type` int(11) NULL COMMENT "类型：1-管理员，2-机构，3-代理商，4-版权方，5-C端用户",
  `sub_type` int(11) NULL COMMENT "子类型：21 - 投流机构，22 - 星图机构，23 - CPS机构",
  `operate_type` int(11) NULL COMMENT "经营类型：1 - 自营，2 - 分销",
  `nickname` varchar(65533) NULL COMMENT "用户名称",
  `job_no` varchar(65533) NULL COMMENT "工号，只有代理商有填写",
  `app_id` varchar(65533) NULL COMMENT "小程序ID",
  `platform` varchar(65533) NULL COMMENT "平台：weixin - 微信，toutiao - 抖音",
  `my_invite_code` varchar(65533) NULL COMMENT "我的邀请码，C端用户和代理商携带",
  `ad_platform` varchar(65533) NULL COMMENT "广告平台：jl - 巨量引擎，gdt - 广点通",
  `tf_id` varchar(65533) NULL COMMENT "投放链接ID",
  `agent_id` varchar(65533) NULL COMMENT "代理商ID",
  `agency_id` varchar(65533) NULL COMMENT "机构ID",
  `click_id` varchar(65533) NULL COMMENT "广告点击ID",
  `clue_token` varchar(65533) NULL COMMENT "资产化token",
  `echoed` int(11) NULL COMMENT "是否回传：1 - 回传过 0 -未回传过",
  `echo_time` datetime NULL COMMENT "回传时间",
  `book_id` varchar(65533) NULL COMMENT "激活书籍ID，关联 book 表",
  `balance` int(11) NULL COMMENT "金豆余额",
  `is_vip` int(11) NULL COMMENT "是否VIP：1 - 是，0 - 否",
  `vip_expire_time` datetime NULL COMMENT "VIP失效时间",
  `os` varchar(65533) NULL COMMENT "操作系统",
  `register_date` datetime NULL COMMENT "注册时间，框架自动生成",
  `last_login_date` datetime NULL COMMENT "最近登录时间，框架自动生成",
  `last_login_ip` varchar(65533) NULL COMMENT "最近登录IP，框架自动生成",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "用户表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
