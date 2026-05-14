CREATE TABLE `ods_tidb_short_video_tt_consume` (
  `id` bigint(20) NOT NULL COMMENT "",
  `account_id` bigint(20) NOT NULL COMMENT "用户id",
  `tt_payorder_id` bigint(20) NULL COMMENT "系统订单号",
  `trade_order_id` varchar(1000) NULL COMMENT "TikTok生成的订单号",
  `series_id` bigint(20) NULL COMMENT "购买的剧id",
  `start_epis_num` int(11) NULL COMMENT "起始集数",
  `end_epis_num` int(11) NULL COMMENT "结束集数",
  `coin` int(11) NULL COMMENT "消费的抖币",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "Tiktok消耗表"
DISTRIBUTED BY HASH(`id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"compression" = "LZ4"
);
