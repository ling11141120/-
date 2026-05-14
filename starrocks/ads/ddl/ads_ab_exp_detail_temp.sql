CREATE TABLE `ads_ab_exp_detail_temp` (
  `dt` date NULL COMMENT "",
  `experimentId` bigint(20) NULL COMMENT "",
  `experimentGroupId` bigint(20) NULL COMMENT "",
  `projectId` int(11) NULL COMMENT "",
  `experimentType` int(11) NULL COMMENT "",
  `trackficVersion` varchar(50) NULL COMMENT "",
  `windowNum` int(11) NULL COMMENT "",
  `totalNumberGroup` bigint(20) NULL COMMENT "",
  `arpuMean` varchar(50) NULL COMMENT "",
  `arpuVar` varchar(50) NULL COMMENT "",
  `adverArpuMean` varchar(50) NULL COMMENT "",
  `adverArpuVar` varchar(50) NULL COMMENT "",
  `totalAdverArpuMean` varchar(50) NULL COMMENT "",
  `totalAdverArpuVar` varchar(50) NULL COMMENT "",
  `adverUnlockEpisodeNumMean` varchar(50) NULL COMMENT "",
  `adverUnlockEpisodeNumVar` varchar(50) NULL COMMENT "",
  `oneExposureArpuMean` decimal(20, 6) NULL COMMENT "",
  `oneExposureArpuVar` decimal(20, 6) NULL COMMENT "",
  `oneExposureArpuDingYueMean` decimal(20, 6) NULL COMMENT "",
  `oneExposureArpuDingYueVar` decimal(20, 6) NULL COMMENT "",
  `predictARPUMean` decimal(20, 6) NULL COMMENT "",
  `predictARPUVar` decimal(20, 6) NULL COMMENT "",
  `saveTime` datetime NULL COMMENT "",
  `updateTime` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `experimentId`, `experimentGroupId`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);