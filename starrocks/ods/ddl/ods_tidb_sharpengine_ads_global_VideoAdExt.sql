CREATE TABLE `ods_tidb_sharpengine_ads_global_VideoAdExt` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProductId` int(11) NULL DEFAULT "0" COMMENT "产品id",
  `AdId` varchar(255) NOT NULL COMMENT "广告ID",
  `AdName` varchar(500) NULL COMMENT "广告名称",
  `AdSetId` varchar(255) NULL COMMENT "广告组ID",
  `AdSetName` varchar(500) NULL COMMENT "广告组名称",
  `AdCampId` varchar(255) NULL COMMENT "广告系列",
  `AdCampName` varchar(500) NULL COMMENT "广告系列名称",
  `AdAccountId` varchar(255) NULL COMMENT "广告账号",
  `AdAccountName` varchar(500) NULL COMMENT "广告账号名称",
  `AdsOptimizer` varchar(128) NULL COMMENT "优化师",
  `TvId` varchar(128) NULL COMMENT "短剧ID",
  `TvName` varchar(500) NULL COMMENT "短剧名称",
  `InviteCode` varchar(128) NULL COMMENT "渠道商编码",
  `InviteName` varchar(255) NULL COMMENT "渠道商名称",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "更新时间",
  `Mt` int(11) NULL DEFAULT "0" COMMENT "终端",
  `Core` int(11) NULL DEFAULT "0" COMMENT "corever",
  `CurrentLanguage2` int(11) NULL COMMENT "语言id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX idx_ProductId (`ProductId`) USING BITMAP COMMENT '语言id'
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AdId, CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
