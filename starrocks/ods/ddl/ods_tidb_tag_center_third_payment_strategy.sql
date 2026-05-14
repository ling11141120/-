CREATE TABLE `ods_tidb_tag_center_third_payment_strategy` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `Name` varchar(300) NULL COMMENT "策略名称",
  `Sort` int(11) NULL COMMENT "排序",
  `JGroupIds` varchar(300) NULL COMMENT "极光选中人群包",
  `ExcludeJGroupIds` varchar(300) NULL COMMENT "极光剔除人群包",
  `SortTags` varchar(300) NULL COMMENT "标签&优先级-逗号分割（1支付金额占比，2支付成功率，3支付费率，4排序相同逻辑）",
  `Date` int(11) NULL COMMENT "周期近3、7、14、30、60、90天",
  `TakeThirdPayNum` int(11) NULL COMMENT "支付方式数量显示上限 0不限制",
  `Rate` int(11) NULL COMMENT "加赠比例",
  `UseLastPayTypeToFirst` int(11) NULL COMMENT "上次支付渠道是否首位（0否，1是）",
  `Status` int(11) NULL COMMENT "状态（0关闭，1开启）",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `NativeSort` int(11) NULL COMMENT "原生支付位置",
  `BeginTime` datetime NULL COMMENT "策略开始时间",
  `EndTime` datetime NULL COMMENT "策略结束时间",
  `AddBonusNum` int(11) NULL COMMENT "加赠次数",
  `DataType` int(11) NULL COMMENT "数据类型 1正式，2测试",
  `IsBubbleGuideOpen` int(11) NULL COMMENT "是否开启气泡引导",
  `BubbleGuideId` int(11) NULL COMMENT "气泡引导文案Id",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "第三方支付策略表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);
