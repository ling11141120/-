CREATE TABLE `ads_ab_exp_core_index_ln` (
  `experimentId` bigint(20) NOT NULL COMMENT "实验id",
  `experimentGroupId` bigint(20) NOT NULL COMMENT "实验组id",
  `dt` date NOT NULL COMMENT "日期分区",
  `projectId` int(11) NOT NULL COMMENT "项目id",
  `trackficVersion` varchar(200) NOT NULL COMMENT "流量版本",
  `l14_payRate` varchar(50) NULL COMMENT "付费率-L14",
  `l30_payRate` varchar(50) NULL COMMENT "付费率-L30",
  `l14_oneExposureArpu` decimal(20, 6) NULL COMMENT "单人曝光ARPU-L14",
  `l30_oneExposureArpu` decimal(20, 6) NULL COMMENT "单人曝光ARPU-L30",
  `l14_dingYueAmountPercent` decimal(20, 6) NULL COMMENT "订阅金额占比-L14",
  `l30_dingYueAmountPercent` decimal(20, 6) NULL COMMENT "订阅金额占比-L30",
  `l14_predictARPU` decimal(20, 6) NULL COMMENT "付费率-L14",
  `l30_predictARPU` decimal(20, 6) NULL COMMENT "付费率-L30",
  `saveTime` datetime NULL COMMENT "入库时间",
  `updateTime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`experimentId`, `experimentGroupId`, `dt`, `projectId`, `trackficVersion`)
DISTRIBUTED BY HASH(`experimentId`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);