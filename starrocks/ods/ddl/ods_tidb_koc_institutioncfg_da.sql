CREATE TABLE `ods_tidb_koc_institutioncfg_da` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `InstitutionId` bigint(20) NULL COMMENT "机构ID",
  `ProjectType` int(11) NULL COMMENT "授权范围 1=网文|2=短剧",
  `AppCfg` varchar(65533) NULL COMMENT "授权产品 多个英文逗号分隔",
  `LangCfg` varchar(65533) NULL COMMENT "授权语言 多个英文逗号分隔",
  `CooperationType` int(11) NULL COMMENT "合作模式 1=分成合作",
  `SplitRatio` int(11) NULL COMMENT "机构可获得的分成比例 30=30%",
  `TransactionFeeType` int(11) NULL COMMENT "通道费扣除类型 1=约定统一支付通道费|2=自定义支付通道费|3=约定实际支付通道费|4=免除通道费",
  `TransactionFee` int(11) NULL COMMENT "通通道费 30=30%",
  `CostFactorType` int(11) NULL COMMENT "成本系数类型 1=约定统一成本系数|2=自定义成本系数|3=免除成本系数",
  `CostFactor` int(11) NULL COMMENT "成本系数 30=30%",
  `BeginTime` datetime NULL COMMENT "合作开始时间",
  `EndTime` datetime NULL COMMENT "合作结束时间",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Creator` varchar(65533) NULL COMMENT "创建人",
  `CreatorUid` varchar(65533) NULL COMMENT "创建人账号ID",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Updater` varchar(65533) NULL COMMENT "更新人",
  `UpdaterUid` varchar(65533) NULL COMMENT "更新人账号ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "KOC机构合作信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
