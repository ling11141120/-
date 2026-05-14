CREATE TABLE `ods_tidb_readernovel_tidb_xx_userchallengetaskrecord` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `Pid` bigint(20) NULL COMMENT "用户id",
  `ActId` int(11) NULL COMMENT "活动id",
  `ChallengeId` int(11) NULL COMMENT "挑战模板id",
  `TaskId` int(11) NULL COMMENT "挑战任务id",
  `ChallengeBeginTime` datetime NULL COMMENT "挑战开始时间",
  `ChallengeEndTime` datetime NULL COMMENT "挑战结束时间",
  `Today` datetime NULL COMMENT "今日",
  `TodayReadTime` bigint(20) NULL COMMENT "今日阅读时长(s)",
  `TodayReadRecord` varchar(65533) NULL COMMENT "今日阅读记录",
  `ReadTime` bigint(20) NULL COMMENT "挑战期间累计阅读时长(s)",
  `ReadRecord` varchar(65533) NULL COMMENT "挑战期间阅读记录",
  `ClockInRecord` varchar(65533) NULL COMMENT "挑战打卡记录",
  `ChallengeStatus` int(11) NULL COMMENT "挑战状态 0 挑战中 1 挑战失败 2 挑战成功",
  `RefundType` int(11) NULL COMMENT "返还类型 0无，1商品价值，2充值金额",
  `RefundStatus` int(11) NULL COMMENT "退款状态 0：未退款 1：已退款",
  `TaskType` int(11) NULL COMMENT " 0阅读时长普通任务，1阅读时长加强任务，2阅读书籍普通任务，3阅读书籍加强任务",
  `GamblingType` int(11) NULL COMMENT " 对赌类型 0充值，1阅币，2Svip",
  `ChallengeFee` int(11) NULL COMMENT "挑战费用(价格/阅币消耗数量)",
  `DailyGoalNum` int(11) NULL COMMENT "每日目标数量(阅读量-分钟/阅读书籍数量)",
  `TotalReadNum` int(11) NULL COMMENT "累计阅读时长-小时",
  `TotalBookNum` int(11) NULL COMMENT "累计阅读书籍数量",
  `SingleReadNum` int(11) NULL COMMENT "单本阅读数量(分钟)",
  `PayOrderId` varchar(65533) NULL COMMENT "支付订单id",
  `CostId` int(11) NULL COMMENT "价值方案id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `ChallengeActualFee` decimal(18, 2) NULL COMMENT "挑战费用(价格),小数类型",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据进sr时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数据sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "用户挑战任务记录"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ChallengeId, Pid, ActId",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
