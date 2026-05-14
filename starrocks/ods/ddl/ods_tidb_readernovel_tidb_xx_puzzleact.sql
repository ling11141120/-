CREATE TABLE `ods_tidb_readernovel_tidb_xx_puzzleact` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "Desc:id
 Default: 2
 Nullable:False",
  `ActName` varchar(955) NOT NULL COMMENT "名称",
  `Rule` varchar(955) NOT NULL COMMENT "规则",
  `Positon` int(11) NOT NULL COMMENT "位置0 H5活动页,1冷却弹窗",
  `Status` int(11) NOT NULL COMMENT "状态 0关闭 1开启",
  `PowerMax` int(11) NOT NULL COMMENT "体力上限",
  `ThirdMulTwoPower` int(11) NOT NULL COMMENT "3*2体力消耗",
  `ThirdMulThirdPower` int(11) NOT NULL COMMENT "3*3体力消耗",
  `ThirdMulFourPower` int(11) NOT NULL COMMENT "3*4体力消耗",
  `ThirdMulTwoTime` int(11) NOT NULL COMMENT "3*2时长",
  `ThirdMulThirdTime` int(11) NOT NULL COMMENT "3*3时长",
  `ThirdMulFourTime` int(11) NOT NULL COMMENT "3*4时长",
  `RePowerTime` int(11) NOT NULL COMMENT "体力回复次数",
  `RePoweNum` int(11) NOT NULL COMMENT "回复体力值",
  `RePowerJifen` int(11) NOT NULL COMMENT "回复体力积分",
  `RePoweNumByJifen` int(11) NOT NULL COMMENT "积分回复体力",
  `ReTimeByAdCount` int(11) NOT NULL COMMENT "广告续时次数",
  `ReTimeByAdTime` int(11) NOT NULL COMMENT "广告续时时间",
  `Language` int(11) NOT NULL COMMENT "语言",
  `AddTime` datetime NOT NULL COMMENT "添加时间",
  `FourMulFourPower` int(11) NOT NULL DEFAULT "0" COMMENT "4*4体力消耗",
  `FourMulFourTime` int(11) NOT NULL DEFAULT "0" COMMENT "4*4时长",
  `UnlockNum` int(11) NOT NULL DEFAULT "0" COMMENT "解锁关卡数",
  `PkJifen` int(11) NOT NULL DEFAULT "0" COMMENT "PK模式消耗积分",
  `PkTakePercent` int(11) NOT NULL DEFAULT "0" COMMENT "PK每局抽成百分比",
  `AddTrophy` int(11) NOT NULL DEFAULT "0" COMMENT "获胜获得奖杯数",
  `LessTrophy` int(11) NOT NULL DEFAULT "0" COMMENT "失败扣除奖杯数",
  `PkCycle` int(11) NOT NULL DEFAULT "0" COMMENT "PK赛季周期 0无 1每月",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "拼图活动"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
