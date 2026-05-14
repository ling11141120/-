CREATE TABLE `ods_tidb_shuangwen_xx_bonusrole` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `BonusId` int(11) NOT NULL COMMENT "奖金包Id",
  `RoleType` int(11) NOT NULL COMMENT "奖金包角色类型 0：附加稿酬、1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "奖金包角色表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
