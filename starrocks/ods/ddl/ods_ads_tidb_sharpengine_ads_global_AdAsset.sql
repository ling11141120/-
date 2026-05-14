CREATE TABLE `ods_ads_tidb_sharpengine_ads_global_AdAsset` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `AssetSource` int(11) NULL COMMENT "素材来源 0=fb",
  `AssetId` varchar(500) NULL COMMENT "素材Id",
  `AdId` varchar(500) NULL COMMENT "广告id",
  `AdSetId` varchar(500) NULL COMMENT "广告组Id",
  `AdCampId` varchar(500) NULL COMMENT "广告组Id",
  `FbAccount` varchar(500) NULL COMMENT "广告账号Id",
  `ProductId` int(11) NULL COMMENT "语言",
  `AssetTitle` varchar(2000) NULL COMMENT "素材标题",
  `AssetUrl` varchar(2000) NULL COMMENT "素材Url",
  `AssetThumbUrl` varchar(2000) NULL COMMENT "素材ThumbUrl",
  `AssetType` int(11) NULL COMMENT "素材类型 0=图片|1=视频",
  `AssetImgUrl` varchar(2000) NULL COMMENT "素材图片地址",
  `DateStart` datetime NULL COMMENT "素材开始时间",
  `DateStop` datetime NULL COMMENT "素材结束时间",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `AdPlanner` varchar(500) NULL COMMENT "素材策划师拼音缩写",
  `Tag1` varchar(500) NULL COMMENT "素材Tag1",
  `Tag2` varchar(500) NULL COMMENT "素材Tag2",
  `Tag3` varchar(500) NULL COMMENT "素材Tag3",
  `DataSource` int(11) NULL COMMENT "数据来源 0=素材原生数据|1=广告名匹配",
  `VideoId` varchar(1000) NULL COMMENT "视频Id",
  `ImageHash` varchar(1000) NULL COMMENT "图片素材Hash",
  `AssetGuid` varchar(1000) NULL COMMENT "素材唯一标识",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告素材信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
