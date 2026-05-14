CREATE TABLE `ods_tidb_readernovel_tidb_xx_usersigncarddata` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `EnterV590Time` datetime NULL COMMENT "",
  `GroupType` int(11) NULL COMMENT "",
  `SignCards` varchar(65533) NULL COMMENT "",
  `BundleGainGift` int(11) NULL COMMENT "",
  `BundleBeginTime` datetime NULL COMMENT "",
  `BundleExpireTime` datetime NULL COMMENT "",
  `BundleGiftPerDay` int(11) NULL COMMENT "",
  `BundleCards` varchar(65533) NULL COMMENT "",
  `LastBuyCardInfos` varchar(65533) NULL COMMENT "",
  `GroupTypeSetTime` datetime NULL COMMENT "",
  `RealGroupType` int(11) NULL COMMENT "用户实时分组",
  `BuySignCardStatus` int(11) NULL COMMENT "",
  `HalfGroupIdfRecInfo` varchar(955) NULL COMMENT "半屏档位推荐，根据人群包合展示次数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
