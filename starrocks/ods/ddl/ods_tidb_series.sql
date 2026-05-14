CREATE TABLE `ods_tidb_series` (
  `SeriesId` bigint(20) NOT NULL COMMENT "id",
  `Language` int(11) NOT NULL COMMENT "语言",
  `SeriesName` varchar(6000) NULL COMMENT "",
  `Description` varchar(65533) NULL COMMENT "短剧简介",
  `CoverUrl` varchar(1600) NULL COMMENT "封面",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `CreateUser` varchar(300) NULL COMMENT "上传人",
  `PublishStatus` int(11) NOT NULL COMMENT "上架状态(1上架 2下架)",
  `PublishedAt` datetime NULL COMMENT "上架时间",
  `UnPublishedAt` datetime NULL COMMENT "下架时间",
  `LastEpis` int(11) NULL COMMENT "更新至第几集",
  `AllEpis` int(11) NULL COMMENT "总集数",
  `PayEpisFrom` int(11) NULL COMMENT "收费起始集数",
  `IsDelete` tinyint(4) NULL COMMENT "是否删除",
  `Producer` varchar(3000) NULL COMMENT "",
  `Recommend` varchar(1500) NULL COMMENT "",
  `SourceSeriesId` bigint(20) NULL COMMENT "源语言短剧",
  `Price` int(11) NULL COMMENT "单集价格（分）",
  `Ending` int(11) NULL COMMENT "完结状态（1连载中 2已完结）",
  `SeriesNameKey` varchar(6000) NULL COMMENT "",
  `DescriptionKey` varchar(65533) NULL COMMENT "短剧简介转换key",
  `RecommendKey` varchar(1500) NULL COMMENT "",
  `SeriesLevel` int(11) NULL COMMENT "等级 1.S 2.A 3.B 4.C",
  `OperateLevel` int(11) NULL COMMENT "运营等级 1.S 2.A 3.B 4.C",
  `WorkType` int(11) NULL COMMENT "作品类型 1.男频  2.女频 3.双番",
  `ImageKey` int(11) NULL COMMENT "轮播榜单配图id",
  `ListRecommendKey` varchar(65533) NULL COMMENT "轮播榜单推荐语key",
  `ListRecommend` varchar(65533) NULL COMMENT "轮播榜单推荐语",
  `Core` varchar(300) NULL COMMENT "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)",
  `sr_createtime` datetime NULL COMMENT "数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`SeriesId`)
COMMENT "短集表"
DISTRIBUTED BY HASH(`SeriesId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "SeriesId, Language",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
