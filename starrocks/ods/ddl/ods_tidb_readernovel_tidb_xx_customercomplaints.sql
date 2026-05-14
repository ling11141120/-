CREATE TABLE `ods_tidb_readernovel_tidb_xx_customercomplaints` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `id` int(11) NOT NULL COMMENT "自增id",
  `date` datetime NULL COMMENT "统计日期",
  `complaintType` varchar(300) NULL COMMENT "客诉类型",
  `timeClock1` varchar(300) NULL COMMENT "0 -4 点",
  `timeClock2` varchar(300) NULL COMMENT "4 -8 点",
  `timeClock3` varchar(300) NULL COMMENT "8 -12 点",
  `timeClock4` varchar(300) NULL COMMENT "12 -16 点",
  `timeClock5` varchar(300) NULL COMMENT "16 -20 点",
  `timeClock6` varchar(300) NULL COMMENT "20 -24 点",
  `sumCount` varchar(300) NULL COMMENT "总计",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
