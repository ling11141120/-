CREATE TABLE `ods_tidb_short_video_center_video_schema` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `StrategyCode` varchar(300) NULL COMMENT "策略代号",
  `UseType` int(11) NULL COMMENT "应用类型 1正式数据，2测试数据，3IOS审核模式",
  `Name` varchar(300) NULL COMMENT "方案名称",
  `SchemeType` int(11) NULL COMMENT "方案属性：1.兜底 2自定义",
  `Status` int(11) NULL COMMENT "状态：1开启 2关闭",
  `Weight` int(11) NULL COMMENT "权重",
  `BeginTime` datetime NULL COMMENT "方案开始时间",
  `EndTime` datetime NULL COMMENT "方案结束时间",
  `GroupIds` varchar(1000) NULL COMMENT "人群包",
  `ExcludeGroupIds` varchar(1000) NULL COMMENT "剔除人群包",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `AuditStatus` int(11) NULL COMMENT "审核状态（0审核中，1通过，2不通过）",
  `ProcessInstanceId` varchar(300) NULL COMMENT "钉钉发起审批实例id",
  `ApplyType` int(11) NULL COMMENT "应用场景:1首页",
  `SecondApplyType` int(11) NULL COMMENT "子应用场景(短剧暂未使用)",
  `UnreadTime` int(11) NULL COMMENT "未阅读时长(短剧暂未使用)",
  `FlowType` int(11) NULL COMMENT "流量类型 1全局流量 2实验流量",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "方案管理表信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
