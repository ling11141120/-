CREATE TABLE `ods_tidb_sharpengine_bi_aitag_book` (
  `bookId` int(11) NOT NULL COMMENT "书籍Id，主键",
  `status` int(11) NULL COMMENT "任务状态,-1待处理 0处理中 1已完成 2失败 3超出预算 4 超出绝对预算失败 5 章节失败率超限",
  `cost` decimal(10, 5) NULL DEFAULT "0" COMMENT "预算",
  `tags` varchar(65533) NULL COMMENT "标签",
  `updateTime` datetime NULL COMMENT "执行完成时间",
  `costLimit` decimal(10, 2) NULL DEFAULT "0" COMMENT "预算限制",
  `realCost` decimal(10, 5) NULL DEFAULT "0" COMMENT "实际消费",
  `siteId` int(11) NULL COMMENT "站点Id，书籍Id末3位",
  `totalCost` decimal(10, 5) NULL COMMENT "累计消费",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`bookId`)
COMMENT "tag-ai书籍tag标签"
DISTRIBUTED BY HASH(`bookId`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
