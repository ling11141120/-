CREATE TABLE `ods_tidb_sharpengine_kpi_b_userinfo_tb` (
  `UserId` varchar(65533) NOT NULL COMMENT "主键",
  `RealUserId` varchar(65533) NULL COMMENT "真实用户id",
  `Account` varchar(65533) NULL COMMENT "登录账号",
  `NickName` varchar(65533) NULL COMMENT "用户姓名",
  `Pwd` varchar(65533) NULL COMMENT "密码 MD5加密存储",
  `UserType` int(11) NULL COMMENT "用户类型 1：超级管理员，2：普通用户",
  `RoleId` varchar(65533) NULL COMMENT "角色",
  `Phone` varchar(65533) NULL COMMENT "手机",
  `DingId` varchar(65533) NULL COMMENT "钉钉id",
  `Email` varchar(65533) NULL COMMENT "邮箱",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CreateTimeEnd` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `DelFlag` int(11) NULL COMMENT "删除标志 0：未删除 1：已删除",
  `LastLoginTime` datetime NULL COMMENT "最后登录时间",
  `EmployeeType` int(11) NULL DEFAULT "0" COMMENT "雇佣类型",
  `Attribute` varchar(65533) NULL COMMENT "管理特性分类",
  `Deadline_3` int(11) NULL DEFAULT "0" COMMENT "最后时间线",
  `Deadline` varchar(65533) NULL DEFAULT "4,8,8,10" COMMENT "4,8,8,10",
  `DingUserId` varchar(65533) NULL COMMENT "DingDingUserId",
  `DingTalkId` varchar(65533) NULL COMMENT "DingTalkId",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`UserId`)
COMMENT "绩效系统-员工工号姓名"
DISTRIBUTED BY HASH(`UserId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Account, UserId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
