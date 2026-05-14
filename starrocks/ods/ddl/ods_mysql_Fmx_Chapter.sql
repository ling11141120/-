CREATE TABLE `ods_mysql_Fmx_Chapter` (
  `ChapterId` bigint(20) NOT NULL COMMENT "章节Id",
  `BookId` int(11) NOT NULL COMMENT "",
  `ChapterName` varchar(1255) NOT NULL COMMENT "",
  `ChapterContent` varchar(65533) NOT NULL COMMENT "",
  `PublishTime` datetime NOT NULL COMMENT "发布时间，如果时间未到，表示定时在这个时间发布",
  `Status` int(11) NULL COMMENT "状态 0:草稿 1:提交等待审核 2:已发布",
  `IsReject` tinyint(4) NULL COMMENT "是否审核驳回",
  `RejectReason` varchar(1255) NULL COMMENT "驳回原因",
  `IsVip` tinyint(4) NULL COMMENT "是否需要付费",
  `FontLength` int(11) NULL COMMENT "字数",
  `SequenceNum` int(11) NULL COMMENT "章节序号",
  `AuthorComment` varchar(65533) NULL COMMENT "作者的话",
  `DelStatus` int(11) NULL DEFAULT "0" COMMENT "",
  `IsSuccess` int(11) NULL DEFAULT "0" COMMENT "",
  `ModifyType` int(11) NULL DEFAULT "0" COMMENT "",
  `AudityType` int(11) NULL DEFAULT "0" COMMENT "",
  `LockType` int(11) NULL DEFAULT "0" COMMENT "",
  `LockTime` datetime NULL COMMENT "",
  `RepeatId` bigint(20) NULL DEFAULT "0" COMMENT "",
  `RepeatType` int(11) NULL DEFAULT "0" COMMENT "",
  `RepeatName` varchar(1500) NULL COMMENT "",
  `Repeat` varchar(6000) NULL COMMENT "",
  `RepeatCover` varchar(1500) NULL COMMENT "",
  `RepeatBatch` int(11) NULL DEFAULT "0" COMMENT "",
  `RepeatTime` datetime NULL COMMENT "",
  `CheckContentStatus` double NULL DEFAULT "0" COMMENT "",
  `IsTiming` int(11) NOT NULL DEFAULT "0" COMMENT "",
  `VolumeNumber` int(11) NULL DEFAULT "0" COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `UpdateTime` datetime NULL COMMENT "",
  `FirstFontLength` int(11) NULL COMMENT "",
  `RejectStatus` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`ChapterId`)
COMMENT "凤鸣轩--章节表"
DISTRIBUTED BY HASH(`ChapterId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
