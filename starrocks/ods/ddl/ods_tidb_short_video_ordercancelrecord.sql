CREATE TABLE `ods_tidb_short_video_ordercancelrecord` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `SubId` varchar(255) NULL COMMENT "订阅Id",
  `OrderId` varchar(255) NULL COMMENT "订单Id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `Status` int(11) NULL COMMENT "是否取消订阅，1：取消订阅",
  `Source` int(11) NULL COMMENT "来源：0：阅读，1：短剧",
  `PayChannel` int(11) NULL COMMENT "1：stripe",
  `UserId` bigint(20) NULL COMMENT "用户Id",
  `CancelSource` int(11) NULL COMMENT "取消来源：0：订阅管理页面取消，1：升级或降级取消订阅",
  `CoreVer` int(11) NULL COMMENT "进入得Core",
  `EntryPosition` int(11) NULL COMMENT "进入的入库位置",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "海剧订单取消记录表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
