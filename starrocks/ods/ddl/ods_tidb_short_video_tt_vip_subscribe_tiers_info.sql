CREATE TABLE `ods_tidb_short_video_tt_vip_subscribe_tiers_info` (
  `id` bigint(20) NOT NULL COMMENT "id",
  `tier_id` varchar(1000) NULL COMMENT "层级id",
  `deduct_cycle` varchar(255) NULL COMMENT "扣费周期",
  `deduct_type` varchar(255) NULL COMMENT "扣费方式",
  `price` varchar(255) NULL COMMENT "价格",
  `currency` varchar(255) NULL COMMENT "币种",
  `symbol` varchar(255) NULL COMMENT "货币符号",
  `is_delete` int(11) NULL COMMENT "是否删除",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "Tiktok vip订阅订单表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);
