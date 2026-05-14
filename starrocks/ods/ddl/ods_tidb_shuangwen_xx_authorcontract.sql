CREATE TABLE `ods_tidb_shuangwen_xx_authorcontract` (
  `productid` smallint(6) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `ContractNo` varchar(65533) NOT NULL COMMENT "合同编号",
  `ContractType` int(11) NOT NULL COMMENT "签约类型",
  `Price` decimal(18, 2) NOT NULL COMMENT "签约单价",
  `Currency` tinyint(4) NOT NULL COMMENT "签约币种 1：人民币、2：美元",
  `AuthorId` bigint(20) NOT NULL COMMENT "译员Id",
  `AuthorName` varchar(65533) NOT NULL COMMENT "译名",
  `RealName` varchar(65533) NOT NULL COMMENT "姓名",
  `Phone` varchar(65533) NULL COMMENT "电话",
  `Email` varchar(65533) NOT NULL COMMENT "邮箱",
  `IdCar` varchar(65533) NULL COMMENT "身份证",
  `Address` varchar(65533) NULL COMMENT "居住地",
  `PayAccount` varchar(65533) NOT NULL COMMENT "打款账号",
  `BankName` varchar(65533) NULL COMMENT "银行名称",
  `PayType` tinyint(4) NOT NULL COMMENT "付款方式",
  `ContractUrl` varchar(65533) NULL COMMENT "合同附件",
  `Remark` varchar(65533) NULL COMMENT "备注",
  `PaymentDate` int(11) NOT NULL COMMENT "付款日期",
  `BeginTime` datetime NOT NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `AuditStatus` tinyint(4) NOT NULL COMMENT "审核状态 0:未审核、1：通过、2：不通过",
  `ToLanguage` int(11) NOT NULL COMMENT "语言",
  `DelStatus` tinyint(4) NOT NULL COMMENT "是否删除 0 否，1 是",
  `BankUserName` varchar(65533) NULL COMMENT "银行支行名称",
  `BookType` tinyint(4) NOT NULL COMMENT "书籍类型",
  `Status` tinyint(4) NOT NULL DEFAULT "1" COMMENT "合同状态 1:合作中，2:合同到期",
  `AccountName` varchar(65533) NULL COMMENT "银行账号名称",
  `Country` varchar(65533) NULL COMMENT "国家",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "译员合同表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
