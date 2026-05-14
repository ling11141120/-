CREATE TABLE `ods_tidb_accountdb_Tidb_hk_Account` (
  `Id` bigint(20) NOT NULL COMMENT "用户id",
  `Account` varchar(50) NOT NULL COMMENT "用户账户",
  `Password` varchar(64) NOT NULL COMMENT "密码",
  `Salt` varchar(32) NOT NULL COMMENT "加密",
  `Sex` tinyint(4) NOT NULL COMMENT "性别",
  `Nick` varchar(200) NOT NULL COMMENT "昵称",
  `WrongNum` int(11) NOT NULL COMMENT "设置密码错误次数",
  `WrongTime` datetime NOT NULL COMMENT "设置密码错误时间",
  `IsLock` tinyint(4) NOT NULL COMMENT "是否锁住",
  `LockTime` datetime NOT NULL COMMENT "锁住时间",
  `RegTime` datetime NOT NULL COMMENT "注册时间",
  `LastLoginTime` datetime NOT NULL COMMENT "最近一次登录时间",
  `EMail` varchar(255) NULL COMMENT "邮箱",
  `Phone` varchar(50) NULL COMMENT "手机号",
  `IMEI` varchar(128) NULL COMMENT "设备imei",
  `SMSCode` varchar(128) NULL COMMENT "短信验证码",
  `HasUserSetPwd` tinyint(4) NULL COMMENT "是否设置过密码",
  `RegIP` varchar(50) NULL COMMENT "注册时ip",
  `LoginIP` varchar(50) NULL COMMENT "登录IP",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读-用户信息，是否设置过密码"
DISTRIBUTED BY HASH(`Id`) BUCKETS 168 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "RegTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
