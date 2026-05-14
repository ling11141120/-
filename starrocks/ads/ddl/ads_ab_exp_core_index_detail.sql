CREATE TABLE `ads_ab_exp_core_index_detail` (
  `userId` bigint(20) NOT NULL COMMENT "userId",
  `experimentId` bigint(20) NOT NULL COMMENT "实验id",
  `experimentGroupId` bigint(20) NOT NULL COMMENT "实验组id",
  `dt` date NOT NULL COMMENT "日期分区",
  `projectId` int(11) NOT NULL COMMENT "项目id",
  `trackficVersion` varchar(500) NOT NULL COMMENT "流量版本",
  `windowNum` int(11) NOT NULL COMMENT "窗口大小(过去n天)",
  `experimentName` varchar(500) NULL COMMENT "实验名称",
  `experimentGroupName` varchar(500) NULL COMMENT "实验组名称",
  `experimentType` int(11) NOT NULL COMMENT "实验类型(1对照组、2实验组)",
  `totalNumber` bigint(20) NULL COMMENT "实验的总的样本量",
  `totalNumberGroup` bigint(20) NULL COMMENT "实验组的总的样本量(用策略命中人数)",
  `arpu` varchar(50) NULL COMMENT "ARPU",
  `adverArpu` varchar(50) NULL COMMENT "广告ARPU",
  `totalAdverArpu` varchar(50) NULL COMMENT "总广告ARPU",
  `adverUnlockEpisodeNum` varchar(50) NULL COMMENT "人均广告解锁剧集",
  `saveTime` datetime NULL COMMENT "入库时间",
  `updateTime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`userId`, `experimentId`, `experimentGroupId`, `dt`, `projectId`, `trackficVersion`, `windowNum`)
DISTRIBUTED BY HASH(`experimentId`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);