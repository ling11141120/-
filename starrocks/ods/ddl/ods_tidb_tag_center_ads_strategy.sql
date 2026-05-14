CREATE TABLE `ods_tidb_tag_center_ads_strategy` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `Name` varchar(1000) NULL COMMENT "策略名称",
  `AdShowType` int(11) NULL COMMENT "广告类型",
  `AdPosition` int(11) NULL COMMENT "广告位置（8阅读页底部横幅，23每日任务领取奖励，35积分排行榜，26福利中心首页激励视频，18半屏（N个激励视频），7章节末，17阅读页插页广告，15书架）",
  `BeginTime` datetime NULL COMMENT "开始时间",
  `EndTime` datetime NULL COMMENT "结束时间",
  `Status` int(11) NULL COMMENT "状态（0关闭，1开启）",
  `Sort` int(11) NULL COMMENT "排序",
  `TaskCriteria` int(11) NULL COMMENT "任务条件值（观看几次）",
  `TaskRepeatCount` int(11) NULL COMMENT "任务重复次数",
  `ShowScopeType` int(11) NULL COMMENT "展示范围类型（1书单，2 算法）",
  `ShowScopeId` int(11) NULL COMMENT "展示范围Id",
  `ChapterType` int(11) NULL COMMENT "章节类型（1全部章节，2免费章节，3付费章节）",
  `StartShowSort` int(11) NULL COMMENT "起始展示位序",
  `IntervalCount` int(11) NULL COMMENT "间隔N章/本/页展示",
  `LimitDisplayCount` int(11) NULL COMMENT "展现个数上限",
  `JGroupIds` varchar(65533) NULL COMMENT "极光人群包",
  `ExcludeJGroupIds` varchar(65533) NULL COMMENT "剔除极光人群包",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `Flow` int(11) NULL COMMENT "流量类型 0全量流量，1实验流量",
  `FlipCount` int(11) NULL COMMENT "半屏翻动前置条件值",
  `FreeChapterCount` int(11) NULL COMMENT "赠送免费章节数",
  `AdsCount` int(11) NULL COMMENT "观看广告个数",
  `IntervalLength` int(11) NULL COMMENT "整送间隔时长（天）",
  `GiveType` int(11) NULL COMMENT "赠送类型 0章节，1礼券",
  `PropId` int(11) NULL COMMENT "礼券道具Id",
  `LimitGiveCount` int(11) NULL COMMENT "每日赠送上限",
  `SuccessorType` int(11) NULL COMMENT "承接内容 0无，1指定链接key",
  `SuccessorContent` varchar(5000) NULL COMMENT "承接内容",
  `AdsType` int(11) NULL COMMENT "广告类型 0激励视频，1浏览三方页面",
  `InstantTransactionId` int(11) NULL COMMENT "即充即消策略Id",
  `PlanCode` varchar(500) NULL COMMENT "策略代号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "tag,广告中心-广告策略"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
