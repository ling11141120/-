CREATE TABLE `ods_tidb_readernovel_tidb_xx_adunlockchapter` (
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Pid` bigint(20) NOT NULL COMMENT "用户id",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `ChapterId` bigint(20) NULL COMMENT "章节id",
  `UnlockTime` datetime NULL COMMENT "解锁时间",
  `UnlockCount` int(11) NULL COMMENT "解锁次数（章节解锁完过段时间会上锁，用户重新解锁后count会加1，另外unloktime会更新）",
  `DeviceId` varchar(65533) NULL COMMENT "设备id",
  `LockType` int(11) NULL COMMENT "解锁类型 0:广告 1：免费礼券",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "广告解锁章节表"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "BookId, ChapterId, Pid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
