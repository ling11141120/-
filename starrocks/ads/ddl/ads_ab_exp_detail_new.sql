CREATE TABLE `ads_ab_exp_detail_new` (
  `dt` date NOT NULL COMMENT "日期分区",
  `experimentId` bigint(20) NOT NULL COMMENT "实验id",
  `experimentGroupId` bigint(20) NOT NULL COMMENT "实验组id",
  `projectId` int(11) NOT NULL COMMENT "项目id",
  `experimentType` int(11) NOT NULL COMMENT "实验类型(1对照组、2实验组)",
  `trackficVersion` varchar(50) NOT NULL COMMENT "流量版本",
  `windowNum` int(11) NOT NULL COMMENT "窗口大小(过去n天)",
  `totalNumberGroup` bigint(20) NULL COMMENT "实验组的总的样本量(用策略命中人数)",
  `arpuMean` varchar(50) NULL COMMENT "ARPU均值",
  `arpuVar` varchar(50) NULL COMMENT "ARPU方差",
  `adverArpuMean` varchar(50) NULL COMMENT "广告ARPU均值",
  `adverArpuVar` varchar(50) NULL COMMENT "广告ARPU方差",
  `totalAdverArpuMean` varchar(50) NULL COMMENT "总广告ARPU均值",
  `totalAdverArpuVar` varchar(50) NULL COMMENT "总广告ARPU方差",
  `adverUnlockEpisodeNumMean` varchar(50) NULL COMMENT "人均广告解锁剧集均值",
  `adverUnlockEpisodeNumVar` varchar(50) NULL COMMENT "人均广告解锁剧集方差",
  `oneExposureArpuMean` decimal(20, 6) NULL COMMENT "单人曝光ARPU均值",
  `oneExposureArpuVar` decimal(20, 6) NULL COMMENT "单人曝光ARPU方差",
  `oneExposureArpuDingYueMean` decimal(20, 6) NULL COMMENT "单人曝光ARPU(订阅)均值",
  `oneExposureArpuDingYueVar` decimal(20, 6) NULL COMMENT "单人曝光ARPU(订阅)方差",
  `saveTime` datetime NULL COMMENT "入库时间",
  `updateTime` datetime NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `experimentId`, `experimentGroupId`, `projectId`, `experimentType`, `trackficVersion`, `windowNum`)
DISTRIBUTED BY HASH(`experimentId`) BUCKETS 6 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);