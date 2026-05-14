CREATE TABLE `ods_tidb_sharpengine_ads_global_AdCopyInfo_da` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `CopyId` varchar(65533) NULL COMMENT "文案ID",
  `CopyIdx` int(11) NULL COMMENT "文案序号",
  `CopyName` varchar(65533) NULL COMMENT "文案名称",
  `ProductId` int(11) NULL COMMENT "语言ID",
  `BookId` bigint(20) NULL COMMENT "书籍ID",
  `IsTop` int(11) NULL COMMENT "是否置顶 0=否|1=是",
  `Status` int(11) NULL COMMENT "状态 0=被拒|1=清水",
  `Remark` varchar(65533) NULL COMMENT "备注",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `CreateBy` varchar(65533) NULL COMMENT "创建人",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `UpdateBy` varchar(65533) NULL COMMENT "更新人",
  `AuditTime` datetime NULL COMMENT "审核时间",
  `AuditBy` varchar(65533) NULL COMMENT "审核人",
  `ProjectCode` int(11) NULL COMMENT "项目 1海阅 2海剧",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "文案记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime, ProductId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
