CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_VideoInfo` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProductId` int(11) NULL COMMENT "语言",
  `VideoId` varchar(500) NULL COMMENT "短剧Id=SeriesId",
  `VideoName` varchar(1000) NULL COMMENT "短剧名称=SeriesName",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `VideoCode` varchar(500) NULL COMMENT "短剧代号=SeriesCode",
  `VideoCodeSeries` varchar(500) NULL COMMENT "短剧代号系列",
  `GlobalPrizeAndroid` int(11) NULL COMMENT "安卓全局定价开关 0=关闭|1=开启",
  `GlobalPrizeIos` int(11) NULL COMMENT "IOS全局定价开关 0=关闭|1=开启",
  `GlobalPrizeCore` varchar(100) NULL COMMENT "全局定价的core 逗号隔开",
  `AllEpis` int(11) NULL COMMENT "视频库的集数",
  `PublishEpis` int(11) NULL COMMENT "视频上架集数",
  `SubtitlesEpis` int(11) NULL COMMENT "字幕集数",
  `PayEpisFrom` int(11) NULL COMMENT "卡点",
  `Price` decimal(10, 2) NULL COMMENT "单集价格(元)",
  `Description` varchar(65533) NULL COMMENT "短剧简介",
  `Language` int(11) NULL COMMENT "语言",
  `CoverUrl` varchar(2000) NULL COMMENT "封面",
  `LocalType` int(11) NULL COMMENT "剧集类别 1本土剧 2 翻译剧",
  `LanguageCode` varchar(500) NULL COMMENT "语言编码",
  `Core` varchar(100) NULL COMMENT "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)",
  `PublishStatus` int(11) NULL COMMENT "上架状态(1上架 2下架)",
  `PublishedAt` datetime NULL COMMENT "上架时间",
  `IsScheduledPublish` int(11) NULL COMMENT "是否定时上架",
  `ScheduledPublishTime` datetime NULL COMMENT "定时上架时间",
  `SeriesLevel` int(11) NULL COMMENT "等级 1.S 2.A 3.B 4.C",
  `OperateLevel` int(11) NULL COMMENT "运营等级 1.S 2.A 3.B 4.C",
  `IsDelete` int(11) NULL COMMENT "是否删除 1 删除 0 未删除",
  `SourceIsDelete` int(11) NULL COMMENT "是否删除 1 删除 0 未删除",
  `VideoCreateTime` datetime NULL COMMENT "短剧创建时间",
  `VideoUpdateTime` datetime NULL COMMENT "短剧修改时间",
  `VideoLabels` varchar(65533) NULL COMMENT "分类标签 英文逗号分隔",
  `WorkType` int(11) NULL COMMENT "作品类型 1.男频  2.女频 3.双番",
  `PlanContentType` int(11) NULL COMMENT "方案内容类型 1001=女频现言|1002=女频古言|1003=女频狼人|1004=男频|2001=女频译制|2002=女频本土|2003=男频译制|2004=男频本土",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "短剧信息,author:102094"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
