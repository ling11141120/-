CREATE TABLE `dwd_user_video_cn_login_info` (
  `dt` date NOT NULL COMMENT "日期，根据createtime转换而来",
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `log_id` varchar(65533) NULL COMMENT "uni-id-log._id",
  `log_type` varchar(65533) NULL COMMENT "操作类型 uni-id-log.type",
  `login_type` varchar(65533) NULL COMMENT "登录类型 uni-id-log.login_type",
  `user_id` varchar(65533) NULL COMMENT "uni-id-log.user_id",
  `ip` varchar(65533) NULL COMMENT "uni-id-log.ip",
  `os` varchar(65533) NULL COMMENT "uni-id-log.os",
  `platform` varchar(65533) NULL COMMENT "uni-id-log.platform",
  `state` int(11) NULL COMMENT "结果:0 失败,1 成功 uni-id-log.state",
  `create_time` datetime NULL COMMENT "uni-id-log._add_time",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
COMMENT "用户域用户登录信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);