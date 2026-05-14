CREATE TABLE `ods_tidb_short_video_center_activity` (
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `StrategyCode` varchar(500) NULL COMMENT "策略代号",
  `Name` varchar(1000) NULL COMMENT "名称",
  `LangId` int(11) NULL COMMENT "语言Id",
  `GroupIds` varchar(1000) NULL COMMENT "人群包Id（逗号分隔）",
  `StartTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `Status` int(11) NULL COMMENT "状态1 开启，2 关闭",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `TemplateId` bigint(20) NULL COMMENT "充值或抽奖活动模板或限免活动模板Id",
  `MainId` bigint(20) NULL COMMENT "活动主表Id",
  `ActivityUrl` varchar(1000) NULL COMMENT "活动跳转地址",
  `ReceptPage` int(11) NULL COMMENT "承接页  0-空 1-书籍详情页  2-书籍阅读页",
  `JGroupIds` varchar(1000) NULL COMMENT "极光人群包",
  `BillId` bigint(20) NULL COMMENT "书单Id",
  `ArithmeticId` bigint(20) NULL COMMENT "算法Id",
  `ShowRule` int(11) NULL COMMENT "展示规则",
  `FilterType` varchar(50) NULL COMMENT "过滤规则",
  `ExposureRule` int(11) NULL COMMENT "过曝规则",
  `ExposureCount` int(11) NULL COMMENT "过曝次数",
  `CostId` bigint(20) NULL COMMENT "方案Id",
  `CombinPageId` bigint(20) NULL COMMENT "组合页面id",
  `SecondArithmeticId` bigint(20) NULL COMMENT "算法ID2",
  `IsRemove` int(11) NULL COMMENT "是否删除 1 是，0否",
  `AppType` int(11) NULL COMMENT "应用类型： 1：短剧，2：阅读",
  `Core` varchar(20) NULL COMMENT "Core (1core1，2core2，3core3，4core4)",
  `BottomType` int(11) NULL COMMENT "推剧兜底内容类型 1算法 2不使用",
  `BottomId` bigint(20) NULL COMMENT "推剧兜底内容id",
  `MainContentType` int(11) NULL COMMENT "推剧主推内容类型 1 剧目 2算法",
  `IsHideNativePay` int(11) NULL COMMENT "隐藏原生支付，0：关闭隐藏，1：开启隐藏",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-活动策略表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
