CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdsCreationAdSetTaskCreativeLog` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `TaskId` bigint(20) NULL COMMENT "任务Id",
  `AdSetId` varchar(1000) NULL COMMENT "广告组Id",
  `AdId` varchar(1000) NULL COMMENT "广告Id",
  `AssetGuid` varchar(1000) NULL COMMENT "素材Guid",
  `BusinessId` varchar(1000) NULL COMMENT "BM唯一Id",
  `VideoId` varchar(1000) NULL COMMENT "视频Id",
  `ImgHash` varchar(1000) NULL COMMENT "图片哈希",
  `LogStatus` int(11) NULL COMMENT "状态 0 待执行 1 成功 2 失败",
  `EstCreateTime` varchar(200) NULL COMMENT "西五区创建时间",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Mt` int(11) NULL COMMENT "终端",
  `CreateByUid` varchar(200) NULL COMMENT "创建人",
  `AdsType` varchar(200) NULL COMMENT "AdsType",
  `CurrentLanguage` int(11) NULL COMMENT "投放语言",
  `Account` varchar(1000) NULL COMMENT "广告账号Id",
  `AdCampId` varchar(1000) NULL COMMENT "系列Id",
  `ProjectCode` int(11) NULL COMMENT "项目类型 1 阅读 2 海剧",
  `ProductId` int(11) NULL COMMENT "语言",
  `AdOptimizerGroup` varchar(500) NULL COMMENT "优化师组别",
  `MasterUid` varchar(500) NULL COMMENT "导师工号",
  `Core` int(11) NULL COMMENT "Core",
  `SourceChl` varchar(500) NULL COMMENT "媒体",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `AssetId` varchar(1000) NULL COMMENT "素材中心唯一Id",
  `AssetReportFilterId` bigint(20) NULL COMMENT "素材筛选ID",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "创编广告 广告素材 日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
