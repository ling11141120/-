CREATE TABLE `ods_tidb_shuangwen_xx_authorwithdrawalrecordnew` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` bigint(20) NOT NULL COMMENT "",
  `AuthorId` bigint(20) NOT NULL COMMENT "",
  `PaidType` int(11) NOT NULL COMMENT "",
  `Address` varchar(855) NULL COMMENT "",
  `Payoneer` varchar(855) NULL COMMENT "",
  `BankAccountNumber` varchar(855) NULL COMMENT "",
  `BankName` varchar(855) NULL COMMENT "",
  `BankOfAccounts` varchar(855) NULL COMMENT "",
  `SWIFTCode` varchar(855) NULL COMMENT "",
  `Area` varchar(855) NULL COMMENT "",
  `Language` int(11) NOT NULL COMMENT "",
  `StaticDate` datetime NOT NULL COMMENT "",
  `WithDrawlApplyTime` datetime NOT NULL COMMENT "",
  `BankRealName` varchar(150) NULL COMMENT "",
  `BankRemark` varchar(1500) NULL COMMENT "",
  `NowResideAddress` varchar(1500) NULL COMMENT "",
  `QiwiType` int(11) NULL COMMENT "pmaxqiwi类型 0BANK_TRANSFER 1qiwi",
  `QiwiNumber` varchar(111) NULL COMMENT "pmaxqiwi账号",
  `InvoiceUrls` varchar(65533) NULL COMMENT "发票",
  `InvoiceNames` varchar(65533) NULL COMMENT "发票名称",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
