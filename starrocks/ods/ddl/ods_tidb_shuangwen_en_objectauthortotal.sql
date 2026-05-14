CREATE TABLE `ods_tidb_shuangwen_en_objectauthortotal` (
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `ToLanguage` int(11) NOT NULL COMMENT "语言",
  `AuthorId` bigint(20) NOT NULL COMMENT "译员编号",
  `AuthorType` int(11) NOT NULL COMMENT "译员类型",
  `PenName` varchar(65533) NULL COMMENT "译名",
  `AccountName` varchar(65533) NULL COMMENT "账号名称",
  `NickName` varchar(65533) NULL COMMENT "昵称",
  `RNumber` varchar(65533) NULL COMMENT "推荐编号",
  `Chl` varchar(65533) NULL COMMENT "渠道",
  `IsAudit` int(11) NOT NULL COMMENT "是否审核",
  `IsPsq` tinyint(4) NOT NULL COMMENT "是否通过问卷",
  `IsReal` tinyint(4) NOT NULL COMMENT "是否实名",
  `IsSign` tinyint(4) NOT NULL COMMENT "是否签约",
  `FirstCount` int(11) NOT NULL COMMENT "试译条数",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `IsFirst` tinyint(4) NOT NULL COMMENT "试译条数",
  `FirstAudit` int(11) NOT NULL COMMENT "最新审核状态",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "译员信息统计报表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
