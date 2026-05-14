CREATE TABLE `ods_tidb_readernovel_tidb_en_worldcupguessrecord` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `UserId` bigint(20) NULL COMMENT "用户id",
  `ActionNo` varchar(65533) NULL COMMENT "竞猜赛事编号",
  `TeamNo` varchar(65533) NULL COMMENT "竞猜队伍编号",
  `GuessType` int(11) NULL COMMENT "竞猜类型 1:猜胜负 2:猜冠军",
  `GuessTime` datetime NULL COMMENT "竞猜时间",
  `GuessAssistValue` int(11) NULL COMMENT "竞猜助力值",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_ProductId (`product_id`) USING BITMAP COMMENT 'index_Product_Id'
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "世界杯竞猜"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "GuessType, ActionNo",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
