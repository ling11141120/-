CREATE TABLE `ods_tidb_qadata_gp_app_anr_rate` (
  `id` bigint(20) NOT NULL COMMENT "自增id",
  `starttime` datetime NULL COMMENT "开始时间",
  `productid` int(11) NULL DEFAULT "0" COMMENT "产品",
  `core` int(11) NULL DEFAULT "1" COMMENT "",
  `lang` varchar(20) NULL COMMENT "语言",
  `versioncode` bigint(20) NULL COMMENT "",
  `AnrRate` decimal(15, 5) NULL COMMENT "当日anr率",
  `AnrRate7dUserWeighted` decimal(15, 5) NULL COMMENT "7日anr率",
  `AnrRate28dUserWeighted` decimal(15, 5) NULL COMMENT "28日anr率",
  `UserPerceivedAnrRate` decimal(15, 5) NULL COMMENT "",
  `UserPerceivedAnrRate7dUserWeighted` decimal(15, 5) NULL COMMENT "",
  `UserPerceivedAnrRate28dUserWeighted` decimal(15, 5) NULL COMMENT "",
  `DistinctUsers` decimal(15, 5) NULL COMMENT "",
  `updatetime` datetime NULL COMMENT "",
  `inittime` datetime NULL COMMENT "",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "qa测试 anr率表"
DISTRIBUTED BY HASH(`id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
