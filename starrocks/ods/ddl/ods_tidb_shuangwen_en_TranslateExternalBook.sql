CREATE TABLE `ods_tidb_shuangwen_en_TranslateExternalBook` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `Sort` int(11) NOT NULL DEFAULT "0" COMMENT "序号",
  `DingNo` varchar(50) NULL COMMENT "钉钉单号",
  `OAType` varchar(150) NULL COMMENT "业务线类型",
  `BusinessId` varchar(150) NULL COMMENT "",
  `BusinessType` varchar(150) NULL COMMENT "营收业务分类",
  `ContractType` varchar(150) NULL COMMENT "合同类型",
  `BookId` bigint(20) NOT NULL DEFAULT "0" COMMENT "书籍id",
  `BookCode` varchar(250) NULL COMMENT "书籍编号",
  `BookName` varchar(250) NULL COMMENT "书籍名称",
  `UpdateState` varchar(150) NULL COMMENT "中文书籍状态",
  `Length` int(11) NOT NULL DEFAULT "0" COMMENT "中文字数",
  `Authorizer` varchar(250) NULL COMMENT "授权方名称",
  `AuthorName` varchar(250) NULL COMMENT "授权笔名",
  `AuthType` varchar(50) NULL COMMENT "授权类型",
  `AuthorizerId` int(11) NOT NULL DEFAULT "0" COMMENT "授权方id",
  `Cooperation` varchar(250) NULL COMMENT "合作方式",
  `Price` decimal(18, 3) NOT NULL DEFAULT "0" COMMENT "价格",
  `PriceType` varchar(250) NULL COMMENT "币种类型",
  `EmpowerLangIds` varchar(500) NULL COMMENT "授权语言",
  `SignBody` varchar(500) NULL COMMENT "签约主体",
  `StartTime` datetime NOT NULL COMMENT "开始时间",
  `EndTime` datetime NOT NULL COMMENT "结束时间",
  `PredictionTime` datetime NULL COMMENT "预测时间",
  `ContractTypeNum` int(11) NOT NULL DEFAULT "0" COMMENT "合同份数",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `CreateUser` varchar(250) NULL COMMENT "创建人",
  `Remarks` varchar(1000) NULL COMMENT "附加信息备注",
  `IsUse` varchar(50) NULL COMMENT "是否使用模板",
  `RowVersion` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "外采书籍表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
