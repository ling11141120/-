CREATE TABLE `ods_tidb_shuangwen_en_viscauthorconfig` (
  `dt` date NOT NULL COMMENT "日期，根据MonthTime映射",
  `SiteId` int(11) NOT NULL COMMENT "站点id",
  `AuthorId` bigint(20) NOT NULL COMMENT "译员id",
  `RoleType` int(11) NOT NULL COMMENT "角色",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `AuthorName` varchar(500) NULL COMMENT "译员名称",
  `MonthTime` datetime NOT NULL COMMENT "月份",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `DayTarget` int(11) NOT NULL COMMENT "日目标",
  `MonthTarget` int(11) NOT NULL COMMENT "月目标",
  `WorkDays` decimal(19, 2) NOT NULL COMMENT "出勤天数",
  `CooperateMode` int(11) NOT NULL COMMENT "合作方式",
  `RowVersion` bigint(20) NULL COMMENT "数据更新版本",
  `EntryTime` datetime NULL COMMENT "入职时间",
  `DepartTime` datetime NULL COMMENT "离职时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间",
  INDEX index_SiteId (`SiteId`) USING BITMAP COMMENT '语言id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `SiteId`, `AuthorId`, `RoleType`)
COMMENT "翻译人员目标配置表"
DISTRIBUTED BY HASH(`SiteId`, `AuthorId`, `RoleType`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "AuthorId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
