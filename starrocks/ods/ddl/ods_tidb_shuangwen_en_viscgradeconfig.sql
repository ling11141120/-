CREATE TABLE `ods_tidb_shuangwen_en_viscgradeconfig` (
  `dt` date NOT NULL COMMENT "日期，根据monthtime创建",
  `SiteId` int(11) NOT NULL COMMENT "语言id",
  `GradeType` int(11) NOT NULL COMMENT "档位",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `MonthTime` datetime NOT NULL COMMENT "月份",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `CapacityTarget` int(11) NOT NULL COMMENT "产能目标",
  `CostRateTarget` decimal(19, 2) NOT NULL COMMENT "成本达标率目标",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间",
  INDEX index_SiteId (`SiteId`) USING BITMAP COMMENT '语言id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `SiteId`, `GradeType`)
COMMENT "编辑书籍语言产能配置表"
DISTRIBUTED BY HASH(`SiteId`, `GradeType`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
