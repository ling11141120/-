CREATE TABLE `ods_tidb_readernovel_xx_mysql_bookweeksale` (
  `productid` int(11) NOT NULL COMMENT "",
  `Id` int(11) NOT NULL COMMENT "",
  `bookid` bigint(20) NULL COMMENT "",
  `money_sale` decimal(18, 2) NULL COMMENT "",
  `money_count` bigint(20) NULL COMMENT "",
  `money_person` bigint(20) NULL COMMENT "",
  `money_orgin_sale` decimal(18, 2) NULL COMMENT "",
  `money_orgin_count` bigint(20) NULL COMMENT "",
  `money_orgin_person` bigint(20) NULL COMMENT "",
  `money_pirate_sale` decimal(18, 2) NULL COMMENT "",
  `money_pirate_count` bigint(20) NULL COMMENT "",
  `money_pirate_person` bigint(20) NULL COMMENT "",
  `gift_sale` decimal(18, 2) NULL COMMENT "",
  `gift_count` bigint(20) NULL COMMENT "",
  `gift_person` bigint(20) NULL COMMENT "",
  `reward` decimal(18, 2) NULL COMMENT "",
  `tick_total` bigint(20) NULL COMMENT "",
  `award_money` decimal(18, 2) NULL COMMENT "",
  `award_person` bigint(20) NULL COMMENT "",
  `award_count` bigint(20) NULL COMMENT "",
  `award_reward` decimal(18, 2) NULL COMMENT "",
  `cps_money` decimal(18, 2) NULL COMMENT "",
  `money_package` decimal(18, 2) NULL COMMENT "",
  `startTime` datetime NULL COMMENT "",
  `endTime` datetime NULL COMMENT "",
  `isDel` int(11) NULL COMMENT "",
  `CID` int(11) NULL COMMENT "",
  `CName` varchar(500) NULL COMMENT "",
  `FullStat` int(11) NULL COMMENT "",
  `Channel` int(11) NULL COMMENT "",
  `BuildTime` datetime NULL COMMENT "",
  `NormalChapterNum` int(11) NULL COMMENT "",
  `Sexy` int(11) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `Id`)
COMMENT "海阅-"
DISTRIBUTED BY HASH(`productid`, `Id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
