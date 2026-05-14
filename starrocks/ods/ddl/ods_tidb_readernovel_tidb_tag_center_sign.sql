CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_sign` (
  `Id` int(11) NOT NULL COMMENT "主键",
  `Name` varchar(65533) NULL COMMENT "名称",
  `UseType` int(11) NULL COMMENT "应用场景（0活动，1福利中心）",
  `IsMakeupSign` int(11) NULL COMMENT "是否开启补签（0否，1是）",
  `IsFullReward` int(11) NULL COMMENT "是否开启满勤奖励（0否，1是）",
  `IsOtherTask` int(11) NULL COMMENT "是否开启额外任务 (0否，1是)",
  `FirstDayMarker` int(11) NULL COMMENT "DAY1大奖标识（0关，1开）",
  `SecondDayMarker` int(11) NULL COMMENT "DAY2大奖标识（0关，1开）",
  `ThirdDayMarker` int(11) NULL COMMENT "DAY3大奖标识（0关，1开）",
  `FourthDayMarker` int(11) NULL COMMENT "DAY4大奖标识（0关，1开）",
  `FifthDayMarker` int(11) NULL COMMENT "DAY5大奖标识（0关，1开）",
  `SixthDayMarker` int(11) NULL COMMENT "DAY6大奖标识（0关，1开）",
  `SeventhDayMarker` int(11) NULL COMMENT "DAY7大奖标识（0关，1开）",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "修改时间",
  `OtherTaskId` int(11) NULL COMMENT "额外任务Id",
  `IsAutoSign` int(11) NULL COMMENT "是否自动签到（0否，1是）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据进sr时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "福利中心-签到配置表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
