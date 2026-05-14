CREATE TABLE `ods_tidb_sv_short_video_log_ad_preload_revenue_di` (
  `Id` bigint(20) NOT NULL COMMENT "唯一ID",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `AccountId` bigint(20) NULL COMMENT "账户id",
  `PrecisionType` int(11) NULL COMMENT "精准投放类型",
  `ValueMicros` double NULL COMMENT "值",
  `CurrencyCode` varchar(65533) NULL COMMENT "货币代码",
  `AdUnitId` varchar(65533) NULL COMMENT "广告id",
  `MediationAdapterClassName` varchar(65533) NULL COMMENT "媒体适配器类名",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Userid` bigint(20) NULL COMMENT "用户ID",
  `Mt` varchar(65533) NULL COMMENT "类型",
  `Appver` varchar(65533) NULL COMMENT "版本号",
  `Appid` varchar(65533) NULL COMMENT "应用ID",
  `Chl` varchar(65533) NULL COMMENT "渠道",
  `Langid` varchar(65533) NULL COMMENT "语言ID",
  `position` int(11) NULL COMMENT "广告位置",
  `adsPlatform` varchar(65533) NULL COMMENT "广告商，218 max广告版本开始上报，旧版本为空",
  `core` int(11) NULL COMMENT "core",
  `RevenuePrecision` varchar(65533) NULL COMMENT "精准投放类型(String)",
  `adType` int(11) NULL COMMENT "广告类型：3激励 5插屏",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `CreateTime`)
COMMENT "广告预加载事件上报表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
