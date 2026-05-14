CREATE TABLE `ods_tidb_readernovel_tidb_xx_userworldcupdata` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `AssistValue` int(11) NULL COMMENT "助力值",
  `Today` datetime NULL COMMENT "今日",
  `ReceivedDayAssist` tinyint(4) NULL COMMENT "是否已领取每日助力值",
  `IsSettlement` tinyint(4) NULL COMMENT "是否结算奖励(冠军赛公布结果后 结算使用)",
  `SettlementAssistValue` int(11) NULL COMMENT "结算的助力值",
  `SettlementGetGift` int(11) NULL COMMENT "结算获得礼券",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "书城标题使用表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
