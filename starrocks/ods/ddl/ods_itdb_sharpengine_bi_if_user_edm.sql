CREATE TABLE `ods_itdb_sharpengine_bi_if_user_edm` (
  `Id` bigint(20) NOT NULL COMMENT "",
  `AdType` varchar(512) NULL DEFAULT "edm" COMMENT "",
  `ProductId` int(11) NULL COMMENT "",
  `UserId` bigint(20) NULL DEFAULT "-1" COMMENT "",
  `Source` varchar(512) NULL COMMENT "",
  `AdId` varchar(512) NULL COMMENT "",
  `InstallDate` datetime NULL COMMENT "",
  `AdSetId` varchar(512) NULL COMMENT "",
  `BookId` bigint(20) NULL COMMENT "",
  `Creative` varchar(1024) NULL COMMENT "",
  `InstallOriginalRequest` varchar(65533) NULL COMMENT "",
  `UniqueCdReaderId` varchar(512) NULL COMMENT "",
  `Country` varchar(512) NULL COMMENT "",
  `Mt` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `DataInsertDate` varchar(50) NULL COMMENT "",
  `Networkname` varchar(512) NULL COMMENT "",
  `Chl2` varchar(128) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "新增时间",
  `SendId` bigint(20) NULL DEFAULT "0" COMMENT "",
  `CurrentLangId` int(11) NULL DEFAULT "0" COMMENT "海剧-界面语言",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
