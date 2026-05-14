CREATE TABLE `ods_mysql_zhangzhong_xzz_authorwithdrawalpayrecord` (
  `Id` bigint(20) NOT NULL COMMENT "编号",
  `AuthorId` bigint(20) NULL COMMENT "作者id",
  `PayMonth` datetime NULL COMMENT "付款月",
  `PayMoney` decimal(18, 2) NULL COMMENT "应发",
  `Tax` decimal(18, 2) NULL COMMENT "个税",
  `RealPay` decimal(18, 2) NULL COMMENT "实发金额",
  `PayTime` datetime NULL COMMENT "支付时间",
  `PayRemark` varchar(1255) NULL COMMENT "付款说明",
  `BusinessId` varchar(1255) NULL COMMENT "付款OA单号",
  `Process_instance_id` varchar(1255) NULL COMMENT "",
  `PayStatus` int(11) NOT NULL COMMENT "支付状态",
  `BankAccount` varchar(1255) NULL COMMENT "银行账号",
  `BankName` varchar(1255) NULL COMMENT "开户行",
  `BankName_Province` varchar(1255) NULL COMMENT "开户地",
  `RealName` varchar(1255) NULL COMMENT "姓名",
  `AuditTime` datetime NULL COMMENT "",
  `AddTime` datetime NULL COMMENT "",
  `IsDelete` int(11) NULL COMMENT "",
  `PayMoneySystem` decimal(18, 2) NULL COMMENT "稿酬金额",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国内编辑系统-稿酬"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
