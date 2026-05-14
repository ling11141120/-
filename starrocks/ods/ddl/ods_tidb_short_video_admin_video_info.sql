CREATE TABLE `ods_tidb_short_video_admin_video_info` (
  `Id` bigint(20) NOT NULL COMMENT "主键",
  `SeriesName` varchar(65533) NULL COMMENT "剧名",
  `SeriesId` varchar(65533) NULL COMMENT "剧ID",
  `Folder` varchar(65533) NULL COMMENT "剧目录",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `FolderNum` int(11) NULL COMMENT "目录序号",
  `FirstLetter` varchar(65533) NULL COMMENT "剧名首字母",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `RightsHolderId` bigint(20) NULL COMMENT "版权方id",
  `CooperateType` int(11) NULL COMMENT "合作方式(1买断、2分成、3保底分成)",
  `ShareRatio` decimal(18, 2) NULL COMMENT "分成比例",
  `Coef` decimal(18, 2) NULL COMMENT "分成系数",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧目录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
