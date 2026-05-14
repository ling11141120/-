CREATE TABLE `ods_tidb_shuangwen_xx_authortorole` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `BookId` bigint(20) NOT NULL COMMENT "书籍id",
  `AuthorId` bigint(20) NOT NULL COMMENT "作者id",
  `RoleType` int(11) NOT NULL COMMENT "角色类型",
  `Price` decimal(18, 2) NOT NULL COMMENT "千字价",
  `RemunerationType` int(11) NOT NULL COMMENT "稿酬类型",
  `TaxType` int(11) NOT NULL COMMENT "个税类型",
  `RecevieStatus` tinyint(4) NOT NULL COMMENT "领稿状态",
  `TranslatedChaptersNumber` int(11) NOT NULL COMMENT "可以领取数量",
  `TranslationAuditTel` varchar(20) NULL COMMENT "审核人电话",
  `ChapterIds` varchar(255) NULL COMMENT "二校章节Id组",
  `Status` tinyint(4) NOT NULL COMMENT "角色状态",
  `UpdateTime` datetime NOT NULL COMMENT "编辑时间",
  `YieldNumber` int(11) NOT NULL COMMENT "预计产量",
  `ToLanguage` int(11) NOT NULL DEFAULT "322" COMMENT "输出语言",
  `AuditStatus` tinyint(4) NOT NULL DEFAULT "1" COMMENT "审核状态 0：审批未通过、1：审批通过、2：审批中",
  `BookType` tinyint(4) NOT NULL DEFAULT "0" COMMENT "书籍类型",
  `IsModifyDictionary` int(11) NOT NULL DEFAULT "1" COMMENT "是否修改词典权限，默认是，1是，0否",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "译员角色表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
