CREATE TABLE `ods_tidb_sv_short_video_coin_di` (
  `id` bigint(20) NOT NULL COMMENT "充值币主键id",
  `AccountId` bigint(20) NULL COMMENT "所属账户id",
  `Value` int(11) NULL COMMENT "钱币数量",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `regionId` smallint(6) NULL COMMENT "归属区域 id，1：香港，2：北美；",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "充值币表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
