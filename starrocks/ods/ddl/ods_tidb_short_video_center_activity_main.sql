CREATE TABLE `ods_tidb_short_video_center_activity_main` (
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `Name` varchar(200) NULL COMMENT "名称",
  `StartTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `Status` int(11) NULL COMMENT "状态1 开启，2 关闭",
  `ExposureStatus` int(11) NULL COMMENT "过曝开关 1开0关",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `LangId` int(11) NULL COMMENT "语言Id",
  `ActityType` int(11) NULL COMMENT "活动类型 1：充值档位推荐，2：VIP档位推荐,3:签到卡档位推荐,4:自定义活动,5:组合活动,6:推剧(剧目单),7:推剧(指定短剧)",
  `SecondType` int(11) NULL COMMENT "二级类型 1：阅读打卡 ,2指定书籍（后展示书籍配置控件）,3章节更新（AdvanceOndemand2）",
  `CombinPageId` bigint(20) NULL COMMENT "组合页面id",
  `AppType` int(11) NULL COMMENT "应用类型： 1：短剧，2：阅读",
  `FlowType` int(11) NULL COMMENT "流量类型 1全局流量 2实验流量",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧-活动主表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
