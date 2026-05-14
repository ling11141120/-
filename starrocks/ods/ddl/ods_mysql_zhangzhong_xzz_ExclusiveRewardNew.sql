CREATE TABLE `ods_mysql_zhangzhong_xzz_ExclusiveRewardNew` (
  `Id` bigint(20) NOT NULL COMMENT "Id",
  `BookId` int(11) NOT NULL COMMENT "BookId",
  `AuthorId` bigint(20) NOT NULL COMMENT "作者id",
  `RewardType` int(11) NULL COMMENT "奖励类型	1001:伯乐奖励,1002:新书续签奖励,1003:完本奖,1004:全勤奖励,1005:衍生收益,1007:翻译收入,1008:千字稿酬,1010:三方收益,1011:签约奖励,1012:激励奖金包,1013:短篇收入",
  `AdjustReason` varchar(1500) NULL COMMENT "调整原因",
  `RemunerationMoney` decimal(18, 2) NOT NULL COMMENT "稿酬金额",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `StaticDate` datetime NULL COMMENT "账期",
  `RemunerationStatus` int(11) NULL COMMENT "稿酬审核状态  0 : 责编未审核 1 :责任编辑审核待定 2 :系统自动审核通过 3:责任编辑审核通过 4:责编审核拒绝 5:主编审核通过 6:主编审核拒绝 7:主编审核待定",
  `EditorRemunerationReason` varchar(1500) NULL COMMENT "责编审批意见",
  `ManagerRemunerationReason` varchar(1500) NULL COMMENT "主编审批意见",
  `EditorId` bigint(20) NULL COMMENT "责编ID",
  `EditorName` varchar(1255) NULL COMMENT "责编名称",
  `DailyTime` datetime NOT NULL COMMENT "稿酬生成时间",
  `IsBanWithdrawl` int(11) NULL COMMENT "是否禁止支付 0:否,1:是",
  `PayRecordId` bigint(20) NULL COMMENT "支付记录id",
  `SignType` int(11) NULL COMMENT "签约类型	-1:未签约,0:作品授权协议（买断）,1:作品授权协议（分成）,5:作品授权协议（保底分成）",
  `CpMode` int(11) NULL COMMENT "合作模式	0:保底 ,1:分成",
  `MoneySale` decimal(18, 2) NULL COMMENT "总收入",
  `RewardSale` decimal(18, 2) NULL COMMENT "打赏收入",
  `OtherSale` decimal(18, 2) NULL COMMENT "其他收入",
  `BookSalle` decimal(18, 2) NULL COMMENT "书籍总收入",
  `ToBookId` bigint(20) NULL COMMENT "翻译书籍id",
  `AuthorSaleRate` varchar(1300) NULL COMMENT "第三方阶梯比例",
  `ToLanguae` int(11) NULL COMMENT "翻译语言",
  `ChannelAppId` varchar(1300) NULL COMMENT "渠道appid",
  `DailyTimeStr` varchar(120) NULL COMMENT "统计时间",
  `RemunerationMoneySystem` decimal(18, 2) NULL COMMENT "系统稿酬金额",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国内编辑 稿酬表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
