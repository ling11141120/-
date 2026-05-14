CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_merchandise_item` (
  `Id` int(11) NOT NULL COMMENT "Id",
  `ApplyType` int(11) NOT NULL COMMENT "应用场景（1App,2Edm）",
  `MerchandiseType` int(11) NOT NULL COMMENT "商品类型（0充值,850Vip,840新福利包，830福利包，810Svip）",
  `Price` int(11) NOT NULL COMMENT "价格（美元）",
  `LangId` int(11) NOT NULL COMMENT "App语言",
  `ProductId` int(11) NOT NULL COMMENT "充值产品Id",
  `Core` int(11) NOT NULL COMMENT "Core（1core1，2core2，3core3，4core4）",
  `PayType` int(11) NOT NULL COMMENT "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外），9PayPal，10Stripe，11Antom-订阅）",
  `ItemId` varchar(765) NOT NULL COMMENT "ItemId",
  `IsShow` int(11) NOT NULL COMMENT "审核期间是否显示（0否，1是）",
  `Status` int(11) NOT NULL COMMENT "状态（0禁用，1启用，2申请中）",
  `IsDelete` int(11) NOT NULL COMMENT "是否删除（0否，1是）",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `PayConfigId` int(11) NOT NULL DEFAULT "0" COMMENT "PayConfig表关联Id",
  `FirstChargeType` int(11) NOT NULL DEFAULT "0" COMMENT "首充属性",
  `Validity` int(11) NOT NULL DEFAULT "0" COMMENT "有效期 (0:无,1:1月,3:1季,12:1年)(月)",
  `FirstValidity` int(11) NOT NULL DEFAULT "0" COMMENT "首充有效期(天)",
  `FirstPrice` int(11) NOT NULL DEFAULT "0" COMMENT "首充价格",
  `ActualPrice` decimal(18, 2) NOT NULL DEFAULT "0" COMMENT "实际精准金额",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_productid (`productid`) USING BITMAP COMMENT 'index_productid',
  INDEX index_LangId (`LangId`) USING BITMAP COMMENT 'index_LangId'
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读-充值项item信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
