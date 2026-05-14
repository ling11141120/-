CREATE TABLE `ods_tidb_sharpengine_ads_global_TopOnFullReport` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `Date` datetime NOT NULL COMMENT "日期",
  `AppId` varchar(100) NOT NULL COMMENT "应用程序",
  `PlacementId` varchar(100) NOT NULL COMMENT "广告位信息，group_by有选placement维度时才返回",
  `Adformat` varchar(100) NOT NULL COMMENT "广告样式，group_by有选adformat维度时才有返回，枚举值：Rewarded Video、Interstitial、Banner、Native、Splash",
  `Revenue` decimal(10, 5) NULL COMMENT "收益",
  `Ecpm` decimal(30, 5) NULL COMMENT "TopOn通过报表API向广告平台拉取到的实际收益和展示API计算出eCPM API，计算公式：（收益/展示API）*1000。注：eCPM API延迟1天提供",
  `Request` int(11) NULL COMMENT "三方广告平台的广告请求数",
  `Fillrate` varchar(50) NULL COMMENT "匹配率（无匹配数，需基于请求数自行计算）",
  `Impression` int(11) NULL COMMENT "三方广告平台的展示数",
  `Click` int(11) NULL COMMENT "三方广告平台的点击数",
  `Ctr` varchar(50) NULL COMMENT "（三方广告平台的点击率）",
  `NetworkFirmId` int(11) NOT NULL COMMENT "广告平台ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  `Response` int(11) NULL COMMENT "三方广告平台的广告请求数"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "阅读app内广告相关：TopOn广告聚合平台收益报表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Date",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
