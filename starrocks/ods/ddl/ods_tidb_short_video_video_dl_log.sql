CREATE TABLE `ods_tidb_short_video_video_dl_log` (
  `id` bigint(20) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `AppId` int(11) NULL COMMENT "",
  `Appver` varchar(255) NULL COMMENT "",
  `Chl` varchar(255) NULL COMMENT "",
  `Mt` int(11) NULL COMMENT "",
  `Core` int(11) NULL COMMENT "",
  `RowData` varchar(65533) NULL COMMENT "",
  `DecryptData` varchar(65533) NULL COMMENT "",
  `UniqueCdReaderId` varchar(255) NULL COMMENT "",
  `CurrentLanguage` int(11) NULL COMMENT "",
  `Sdk` int(11) NULL COMMENT "",
  `regionId` smallint(6) NULL DEFAULT "1" COMMENT "归属区域 id，1：香港，2：北美；",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `HasOpen` int(11) NULL COMMENT "客户端上报isOpen,首次打开",
  `SeriesId` varchar(100) NULL COMMENT "拉起短剧id",
  `DefaultDLType` int(11) NULL COMMENT "1029上报使用 归因类型 0:DL=0,1: UAC归因 2:IP+UA匹配，3 IP匹配 （归因判断条件就是 sdk=7时候 DefaultDLType 字段类型判断）"
) ENGINE=OLAP 
PRIMARY KEY(`id`, `CreateTime`)
COMMENT "短剧-短剧deeplink数据（ 用户站外看的书或者剧  到APP里吗直接给你打开了）"
DISTRIBUTED BY HASH(`id`) BUCKETS 400 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
