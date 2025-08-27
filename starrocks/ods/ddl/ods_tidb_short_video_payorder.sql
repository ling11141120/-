CREATE TABLE ods.ods_tidb_short_video_payorder(
 `dt` date   NOT NULL  "createtime分区",
  `id` int(11) NOT NULL  COMMENT "自增id",
  `type` int(11) NOT NULL DEFAULT '0',
  `userid` bigint(20) NOT NULL COMMENT "用户id",
  `used` int(11) NOT NULL DEFAULT COMMENT "是否执行",
  `orderid` varchar(128)  NOT NULL  COMMENT "订单id",
  `flag` int(11) NOT NULL DEFAULT '0' COMMENT "标识",
  `createtime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00.000',
  `gettime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00.000',
  `itemcount` int(11) NOT NULL DEFAULT '0' COMMENT "金额数",
  `systemtype` int(11) NOT NULL DEFAULT '0' COMMENT "系统类型",
  `receivedate` datetime DEFAULT NULL COMMENT "被接收时间",
  `MT` int(11) NOT NULL DEFAULT '0' COMMENT "终端",
  `CouponId` varchar(128)  DEFAULT NULL COMMENT "礼券id",
  `PackageId` varchar(255)  DEFAULT NULL COMMENT "存放充值页面来源",
  `ShopItem` varchar(128) DEFAULT NULL COMMENT "充值类型",
  `ExtInfo` varchar(128) DEFAULT NULL COMMENT "信息",
  `VipExpireTime` varchar(20) DEFAULT NULL COMMENT "充值订阅卡时，过期时间",
  `RealMoney` int(11) DEFAULT NULL COMMENT "给的阅币数",
  `GiveMoney` int(11) DEFAULT NULL  COMMENT "暂时无用",
  `Amount` int(11) DEFAULT NULL  COMMENT "暂时无用",
  `ProdId` int(11) NOT NULL DEFAULT '0'  COMMENT "暂时无用",
  `PayConfigId` int(11) DEFAULT NULL COMMENT "充值项的Id，可能不准确",
  `CoreVer` int(11) DEFAULT NULL COMMENT "包体",
  `UniqueGuid` varchar(255)  DEFAULT NULL COMMENT '用户设备id',
  `TestFlag` int(11) NOT NULL DEFAULT '0'  COMMENT "是否是测试号充值（0正式，1测试）",
  `BuyToken` varchar(255) DEFAULT NULL COMMENT '购买时候的google的token',
  `BaseAmount` int(11) NOT NULL DEFAULT  COMMENT "分成后的数量",
  `Version` varchar(255)  DEFAULT NULL COMMENT '购买时，用户客户端的版本号',
  `SubPayType` varchar(50)  DEFAULT NULL COMMENT "充值渠道",
  `GiftMoney` int(11) DEFAULT NULL COMMENT "充值赠送的礼券数(可能不准确)",
  `OrderInitTime` datetime DEFAULT NULL COMMENT '用户订单创建时间',
  `CooOrderExtInfo` varchar(1000)  DEFAULT NULL COMMENT '合作方订单扩展',
  `CustomData` string  DEFAULT NULL COMMENT '自定义数据，透传，json格式',
      `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)ENGINE = olap
PRIMARY KEY(dt,Id)
comment '海外短剧-用户充值表'
PARTITION BY RANGE(dt)
(START ("2023-07-05") END ("2023-11-24") EVERY (INTERVAL 1 day))
DISTRIBUTED BY HASH(dt,Id)  BUCKETS 1
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "UserId,orderid",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "day",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"storage_format" = "DEFAULT",
"enable_persistent_index" = "true",
"compression" = "LZ4"
);



 



 
  
  
  

