CREATE TABLE `ods_adstidb_GoogleAssetDailyInsight` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `CampId` varchar(150) NOT NULL COMMENT "广告系列ID",
  `AdGroupId` varchar(150) NOT NULL COMMENT "广告组ID",
  `AdGroupName` varchar(1500) NULL COMMENT "广告组名称",
  `AssetId` varchar(150) NOT NULL COMMENT "素材id",
  `AssetName` varchar(1000) NOT NULL COMMENT "素材名",
  `AssetType` int(11) NOT NULL COMMENT "素材类型",
  `AssetDataId` varchar(150) NOT NULL COMMENT "素材数据ID",
  `AssetTitle` varchar(1000) NOT NULL COMMENT "素材标题",
  `Account` varchar(300) NOT NULL COMMENT "账号",
  `date_start` varchar(150) NOT NULL COMMENT "开始日期",
  `date_stop` varchar(150) NOT NULL COMMENT "结束日期",
  `Spend` decimal(10, 2) NOT NULL COMMENT "花费",
  `Amount` decimal(10, 2) NOT NULL COMMENT "收入",
  `Installs` bigint(20) NOT NULL COMMENT "安装数",
  `Clicks` bigint(20) NOT NULL COMMENT "点击数",
  `Impressions` bigint(20) NOT NULL COMMENT "展示数",
  `Conversions` bigint(20) NOT NULL COMMENT "转化数",
  `Ctr` varchar(150) NULL COMMENT "CTR",
  `Roas` decimal(10, 2) NOT NULL COMMENT "收入/转化价值",
  `Mt` int(11) NOT NULL COMMENT "终端",
  `ProductId` varchar(150) NULL COMMENT "产品ID",
  `PutData` varchar(65533) NULL COMMENT "",
  `RowVersion` bigint(20) NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `UpdateTime` datetime NOT NULL COMMENT "",
  `sr_createtime` datetime NULL COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
