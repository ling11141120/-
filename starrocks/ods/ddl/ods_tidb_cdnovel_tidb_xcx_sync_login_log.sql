CREATE TABLE `ods_tidb_cdnovel_tidb_xcx_sync_login_log` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NOT NULL COMMENT "原表主键_id",
  `user_id` varchar(65533) NULL DEFAULT "" COMMENT "用户ID",
  `scene` varchar(65533) NULL DEFAULT "" COMMENT "启动场景值",
  `app_id` varchar(65533) NULL DEFAULT "" COMMENT "小程序ID",
  `type` varchar(65533) NULL DEFAULT "" COMMENT "类型,weixin、toutiao",
  `query` varchar(65533) NULL COMMENT "启动参数JSON",
  `tf_id` varchar(65533) NULL DEFAULT "" COMMENT "投放链ID",
  `book_id` varchar(65533) NULL DEFAULT "" COMMENT "书籍ID",
  `agent_id` varchar(65533) NULL DEFAULT "" COMMENT "代理商ID",
  `promotion_id` varchar(65533) NULL DEFAULT "" COMMENT "广告计划ID",
  `ua` varchar(65533) NULL DEFAULT "" COMMENT "User-Agent",
  `os` varchar(65533) NULL DEFAULT "" COMMENT "系统",
  `ip` varchar(65533) NULL DEFAULT "" COMMENT "IP地址",
  `status` int(11) NOT NULL DEFAULT "0" COMMENT "状态：1 - 成功，0 - 失败",
  `description` varchar(65533) NOT NULL DEFAULT "" COMMENT "描述",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国内小程序阅读-用户登录日志表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
