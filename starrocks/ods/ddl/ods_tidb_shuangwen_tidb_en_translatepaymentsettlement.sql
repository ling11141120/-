CREATE TABLE `ods_tidb_shuangwen_tidb_en_translatepaymentsettlement` (
  `Id` int(11) NOT NULL COMMENT "",
  `BillDate` int(11) NULL COMMENT "",
  `AuthorId` bigint(20) NULL COMMENT "",
  `ToLanguage` int(11) NULL COMMENT "",
  `InvoiceUrl` varchar(3000) NULL COMMENT "",
  `Remark` varchar(3000) NULL COMMENT "",
  `Status` int(11) NULL COMMENT "",
  `PayAccount` varchar(1000) NULL COMMENT "",
  `BankName` varchar(1000) NULL COMMENT "",
  `AccountName` varchar(500) NULL COMMENT "",
  `BankSubBranch` varchar(6000) NULL COMMENT "",
  `IDCard` varchar(500) NULL COMMENT "",
  `Phone` varchar(200) NULL COMMENT "",
  `AuthorName` varchar(1000) NULL COMMENT "",
  `CurrencyType` int(11) NULL COMMENT "",
  `PaymentDate` int(11) NULL COMMENT "",
  `IsInvoices` int(11) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `PayType` int(11) NULL COMMENT "",
  `PayTime` datetime NULL COMMENT "",
  `InvoiceStatus` int(11) NULL COMMENT "",
  `RealName` varchar(1000) NULL COMMENT "",
  `PaymentType` int(11) NULL COMMENT "",
  `IDType` int(11) NULL COMMENT "证件类型",
  `PayoneerPayStatus` int(11) NULL COMMENT "payoneer支付状态 0不支持，1待支付，2支付中，3已支付，4支付失败",
  `PayoneerErrorReason` varchar(65533) NULL COMMENT "payoneer取消理由",
  `PayoneerClientReferenceId` varchar(200) NULL COMMENT "payoneer订单Id",
  `PayoneerPayTime` datetime NULL COMMENT "Payoneer支付时间",
  `PayoneerCreateTime` datetime NULL COMMENT "Payoneer创建时间",
  `PayoneerCanceledTime` datetime NULL COMMENT "Payoneer支付失败时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
DUPLICATE KEY(`Id`)
COMMENT "爆款内容-新稿酬支付"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
