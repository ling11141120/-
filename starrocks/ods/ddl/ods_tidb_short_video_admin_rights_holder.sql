CREATE TABLE `ods_tidb_short_video_admin_rights_holder` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `Holder` varchar(65533) NULL COMMENT "版权方",
  `Company` varchar(65533) NULL COMMENT "公司名称",
  `Type` int(11) NULL COMMENT "类别 1引入 2自研",
  `Status` int(11) NULL COMMENT "状态 1启用 2禁用",
  `UserName` varchar(65533) NULL COMMENT "用户名",
  `Password` varchar(65533) NULL COMMENT "密码",
  `Login` int(11) NULL COMMENT "能否登陆 1 能 0 不能",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CreateUser` varchar(65533) NULL COMMENT "创建人",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `Coef` decimal(18, 2) NULL COMMENT "海剧剧分成系数",
  `LangIds` varchar(65533) NULL COMMENT "海剧结算语言,逗号分隔",
  `CnCoef` decimal(18, 2) NULL COMMENT "国剧分成系数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "版权方表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
