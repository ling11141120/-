CREATE TABLE `ods_tidb_readernovel_tidb_coinlotteryreadfree` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `ActId` int(11) NULL COMMENT "活动ID",
  `PropId` int(11) NOT NULL COMMENT "道具Id",
  `Minutes` int(11) NOT NULL DEFAULT "0" COMMENT "分钟数",
  `DateGuidNo` varchar(100) NULL COMMENT "来源id 取数据用 guid",
  `SourceKey` varchar(100) NULL COMMENT "来源KEy",
  `OutTime` datetime NULL COMMENT "过期时间",
  `ImgKey` varchar(100) NULL COMMENT "图片来源KEy",
  `ReadFreeSourceType` int(11) NULL COMMENT "来源类型，author:350625",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "用户限免卡领取记录（特殊说明tidb中此表会删除数据，当OutTime 小于当前时间减3个月的并且近三个月有获取过限免卡信息的数据将会被删除）"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime, Pid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
