CREATE TABLE `ods_ads_tidb_FbAdLpTz` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `DateKey` varchar(900) NOT NULL COMMENT "日期yyyy-MM-dd",
  `AdId` varchar(900) NOT NULL COMMENT "广告id",
  `ProductId` int(11) NULL COMMENT "语言",
  `Country` varchar(900) NULL COMMENT "国家字段",
  `Tz` int(11) NULL COMMENT "时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区",
  `LpClicks` int(11) NOT NULL COMMENT "点击次数",
  `LpImpressions` int(11) NOT NULL COMMENT "展示次数",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `LpInitialization` int(11) NOT NULL DEFAULT "0" COMMENT "LP初始化",
  `FirstLpClicks` int(11) NOT NULL DEFAULT "0" COMMENT "点击次数(isretry=0)只计算首次",
  `FirstLpImpressions` int(11) NOT NULL DEFAULT "0" COMMENT "展示次数(isretry=0)只计算首次",
  `FirstLpInitialization` int(11) NOT NULL DEFAULT "0" COMMENT "初始化界面展示次数(isretry=0)只计算首次",
  `ExtidLpClicks` int(11) NOT NULL DEFAULT "0" COMMENT "点击次数(增加了extid的去重)",
  `ExtidLpImpressions` int(11) NOT NULL DEFAULT "0" COMMENT "展示次数(增加了extid的去重)",
  `ExtidLpInitialization` int(11) NOT NULL DEFAULT "0" COMMENT "初始化界面展示次数(增加了extid的去重)",
  `sr_createtime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告每日国家(分时区)级别Lp信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 10 
ORDER BY(`DateKey`, `Tz`)
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId, ProductId, DateKey",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
