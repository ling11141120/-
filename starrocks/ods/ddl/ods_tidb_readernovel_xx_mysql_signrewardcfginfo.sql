CREATE TABLE `ods_tidb_readernovel_xx_mysql_signrewardcfginfo` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "主键ID",
  `SignRewardCfgId` int(11) NOT NULL COMMENT "签到奖励ID",
  `GoodsId` bigint(20) NOT NULL COMMENT "商品ID",
  `ShopGoodsType` int(11) NOT NULL COMMENT "奖品类型",
  `SendType` int(11) NOT NULL COMMENT "发放类型 0礼券 1直接发放 2购买权限",
  `SendNum` int(11) NOT NULL COMMENT "发放数量",
  `Sort` int(11) NOT NULL COMMENT "排序",
  `ModifId` varchar(150) NULL COMMENT "",
  `ModifyTime` datetime NULL COMMENT "",
  `CreateId` varchar(150) NOT NULL COMMENT "",
  `CreateTime` datetime NOT NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "Id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
