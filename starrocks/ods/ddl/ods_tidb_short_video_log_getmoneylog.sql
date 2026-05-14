CREATE TABLE `ods_tidb_short_video_log_getmoneylog` (
  `Id` int(11) NOT NULL COMMENT "",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `VipLv` int(11) NULL COMMENT "vip等级",
  `PayChl` varchar(50) NULL COMMENT "payorder.type",
  `Charge` int(11) NULL COMMENT "充值金额",
  `RealGet` int(11) NULL COMMENT "实际获取到的阅币数量",
  `Give` int(11) NULL COMMENT "实际获取到的赠送币数量",
  `CurMoney` int(11) NULL COMMENT "用户当前阅币数量",
  `GetTime` datetime NULL COMMENT "获得时间",
  `reforderid` varchar(255) NULL COMMENT "payorder.orderid",
  `Seq` bigint(20) NULL COMMENT "自增的序号",
  `cps` int(11) NULL COMMENT "",
  `chl2` varchar(255) NULL COMMENT "",
  `ChargeType` int(11) NULL COMMENT "充值类型：",
  `DeviceGUID` varchar(255) NULL COMMENT "当前用户的设备id",
  `GiftMoney` int(11) NULL COMMENT "获得的礼券数量",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "领卡获取到的阅币，礼券记录日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
