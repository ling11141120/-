CREATE TABLE `ods_tidb_short_video_goods_strategy_condition` (
  `Id` bigint(20) NOT NULL COMMENT "id",
  `ParentId` bigint(20) NOT NULL COMMENT "父级id（策略id）",
  `Mt` varchar(20) NULL COMMENT "客户端，区分ios 1， android 4",
  `PayType` varchar(20) NULL COMMENT "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外））",
  `LangIds` varchar(512) NULL COMMENT "语言id数组",
  `AppLangIds` varchar(512) NULL COMMENT "APP语言id数组",
  `AppLangs` varchar(512) NULL COMMENT "APP语言数组",
  `Langs` varchar(512) NULL COMMENT "语言数组",
  `VerMax` int(11) NOT NULL COMMENT "最大版本号",
  `VerMin` int(11) NOT NULL COMMENT "最小版本号",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ParentType` int(11) NOT NULL COMMENT "父级类型 （策略类型 1：方案，2：购买策略，3：充值挡位（商品策略），4：定价系统，5：半屏，6：即充即消，7：千字价格系数定投 ）",
  `Core` varchar(20) NULL COMMENT "Core (1core1，2core2，3core3，4core4)",
  `AppType` int(11) NULL COMMENT "应用类型： 1：短剧，2：阅读",
  `IsDelete` int(11) NULL COMMENT "是否删除（0否，1是）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-策略条件过滤表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
