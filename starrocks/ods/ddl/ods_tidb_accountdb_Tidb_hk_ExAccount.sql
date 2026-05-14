CREATE TABLE `ods_tidb_accountdb_Tidb_hk_ExAccount` (
  `ExType` int(11) NOT NULL COMMENT "第三方账号绑定类型：
1：QQ
2：新浪
3：微信
4：Facebook
5：Line
6：Google
7：Twitter
8：华为
9：百度小程序
10：支付宝小程序
11：手Q小程序
12：头条小程序
13：AppleId",
  `ExId` varchar(512) NOT NULL COMMENT "第三方账号Id",
  `Id` bigint(20) NOT NULL COMMENT "用户id",
  `ExNick` varchar(256) NOT NULL COMMENT "第三方账号昵称",
  `BindTime` datetime NOT NULL COMMENT "绑定时间",
  `AccessToken` varchar(65533) NOT NULL COMMENT "无用",
  `TempToken` varchar(32) NOT NULL COMMENT "无用",
  `TempTokenTime` datetime NOT NULL COMMENT "无用",
  `Password` varchar(128) NULL COMMENT "密码",
  `UnionId` varchar(128) NULL COMMENT "合并id",
  `OpenId` varchar(128) NULL COMMENT "打开id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`ExType`, `ExId`)
COMMENT "阅读-第三方账号绑定邮箱信息"
DISTRIBUTED BY HASH(`ExType`, `ExId`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BindTime, Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
