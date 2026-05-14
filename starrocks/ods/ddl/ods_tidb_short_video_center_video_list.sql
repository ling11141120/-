CREATE TABLE `ods_tidb_short_video_center_video_list` (
  `Id` bigint(20) NOT NULL COMMENT "主键Id",
  `StrategyCode` varchar(300) NULL COMMENT "策略代号",
  `Name` varchar(300) NULL COMMENT "榜单名称",
  `TitleId` bigint(20) NULL COMMENT "标题Id",
  `FirstType` int(11) NULL COMMENT "榜单一级样式:1：排行榜，2：上下滑,3:推剧通用 4折扣限时榜单 5 广告限免榜单",
  `SecondType` varchar(30) NULL COMMENT "榜单二级样式:S1:排行榜 S2 :信息流上下滑 A1:三列多行 A2:一列带详情 A3:两列多行 H1:小图横滑 H2:大图横滑 H3:轮播",
  `Rows` int(11) NULL DEFAULT "0" COMMENT "行数",
  `Columns` int(11) NULL DEFAULT "0" COMMENT "列数",
  `HideRule` int(11) NULL COMMENT "榜单隐藏规则：1 主推内容 2 主推及兜底",
  `HideRow` int(11) NULL COMMENT "最小隐藏条数",
  `MainContentType` int(11) NULL COMMENT "主推内容类型：1.剧目 2.算法",
  `BillId` bigint(20) NULL COMMENT "剧单列表",
  `ArithmeticId` int(11) NULL COMMENT "算法Id",
  `ClimbChartsType` int(11) NULL DEFAULT "0" COMMENT "主推爬榜类型 0不爬榜，1新书榜，2榜1，3榜2",
  `ShowRule` int(11) NULL COMMENT "显示规则： 1,权重排序 2,随机排序 3,定时轮播",
  `ShowRow` int(11) NULL COMMENT "滚动条数",
  `ShowMinute` int(11) NULL COMMENT "显示分钟",
  `ExposureRule` int(11) NULL COMMENT "曝光规则：0,无限制 1,单用户曝光N次后，当天不展示 2,单用户点击N次后，当天不展示 3,单用户点击N次后，活动期间不展示 4,单用户曝光N次后，活动期间不展示 5,所有用户累计点击N次后，活动期间不展示 6,所有用户累计点击N次后，当天不展示",
  `ExposureCount` int(11) NULL COMMENT "曝光次数",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NOT NULL COMMENT "修改时间",
  `ExcludeColumn` varchar(1500) NULL COMMENT "",
  `ApplyType` int(11) NULL COMMENT "应用场景：1 首页",
  `FilterType` varchar(150) NULL COMMENT "过滤规则：0,不限制 1,过滤已购买的短剧 2,过滤加入追剧的短剧 3,过滤已观看过的短剧 4,过滤观看记录是最后一集的所有完结剧 5,过滤加入追剧中最新的N部、浏览历史中最新的M部",
  `FilterNnum` int(11) NULL COMMENT "过滤加入追剧中最新的N值",
  `FilterMnum` int(11) NULL COMMENT "过滤浏览历史中最新的M值",
  `ListType` int(11) NOT NULL DEFAULT "0" COMMENT "列表进入样式（0无，1使用单本样式，2使用多本样式）",
  `SecondArithmeticId` int(11) NULL COMMENT "兜底算法ID2",
  `SecondClimbChartsType` int(11) NULL DEFAULT "0" COMMENT "兜底爬榜类型 0不爬榜，1新书榜，2榜1，3榜2",
  `LimitTimeStart` datetime NULL COMMENT "限时时间开始(限时榜单)",
  `LimitTimeEnd` datetime NULL COMMENT "限时时间结束(限时榜单)",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "榜单管理表信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BillId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
