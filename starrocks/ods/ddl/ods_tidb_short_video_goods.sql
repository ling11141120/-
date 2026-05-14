CREATE TABLE `ods_tidb_short_video_goods` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `GoodsType` int(11) NULL COMMENT "商品类型：0普通充值，1vip充值，2签到卡充值",
  `UsageScenario` varchar(500) NULL COMMENT "应用场景",
  `Price` int(11) NULL COMMENT "价格",
  `EffectiveTime` int(11) NULL COMMENT "有效时间",
  `ShopItemId` int(11) NULL COMMENT "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包）",
  `VipType` int(11) NULL COMMENT "1 月卡 2 季卡 3 年卡 4 周卡",
  `FirstEffectiveTime` int(11) NULL COMMENT "首充有效期",
  `FirstPrice` int(11) NULL COMMENT "首充价格",
  `GoodsAttribute` int(11) NULL COMMENT "商品属性",
  `PriceTitle` varchar(500) NULL COMMENT "展示价格Price-0.01后的价格",
  `OriTitle` varchar(500) NULL COMMENT "原价格",
  `PayConfigId` bigint(20) NULL COMMENT "支付配置表ID",
  `ItemId` varchar(500) NULL COMMENT "申请ID",
  `Mt` int(11) NULL COMMENT "客户端，区分ios 1， android 4",
  `IsOnOff` int(11) NULL COMMENT "是否启用，启用：1，禁用：0",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `IsRemove` int(11) NULL DEFAULT "0" COMMENT "标识是否删除：1删除，0正常",
  `PayType` int(11) NULL COMMENT "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外））",
  `LangId` bigint(20) NULL COMMENT "App语言",
  `ProductId` bigint(20) NULL COMMENT "充值产品ID，阅读每种语言对应一个APP",
  `IsShow` int(11) NULL COMMENT "审核期间是否显示 (0否，1是)",
  `Core` int(11) NULL DEFAULT "1" COMMENT "Core (1core1,2core2,3core3,4core4)",
  `AppType` int(11) NULL DEFAULT "1" COMMENT "1：阅读，2：短剧",
  `ApplyType` int(11) NULL DEFAULT "1" COMMENT "应用场景（1App,2Edm）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧，充值套餐配置表 Author：135013"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
