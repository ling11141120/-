CREATE TABLE `ods_tidb_sv_short_video_package_sale_log` (
  `id` bigint(20) NOT NULL COMMENT "主键",
  `templateId` bigint(20) NULL COMMENT "打包售卖模板ID",
  `accountId` bigint(20) NULL COMMENT "用户ID",
  `orderId` bigint(20) NULL COMMENT "订单ID",
  `seriesList` varchar(65533) NULL COMMENT "打包购买的剧，剧id,分割",
  `createTime` datetime NULL COMMENT "创建时间",
  `updateTime` datetime NULL COMMENT "更新时间",
  `orderType` tinyint(4) NULL COMMENT "订单类型：1购买2退订",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "打包售卖购买记录"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "createTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
