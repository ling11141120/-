CREATE TABLE `ods_tidb_short_video_tt_vip_subscribe` (
  `id` bigint(20) NOT NULL COMMENT "主键ID",
  `account_id` bigint(20) NULL COMMENT "用户ID",
  `tt_open_id` varchar(765) NULL COMMENT "TT用户openId",
  `tt_payorder_id` bigint(20) NULL COMMENT "系统订单号，关联tt_payorder.id",
  `tier_id` varchar(765) NULL COMMENT "订阅层级id",
  `subscription_id` varchar(765) NULL COMMENT "订阅id",
  `trade_order_id` varchar(765) NULL COMMENT "TikTok生成的订单号",
  `benefit_begin_time` bigint(20) NULL COMMENT "订阅开始时间(时间戳)",
  `benefit_end_time` bigint(20) NULL COMMENT "订阅结束时间(时间戳)",
  `subscription_status` int(11) NULL COMMENT "订阅状态：0-待生效，1-生效中，2-已失效",
  `is_sandbox` tinyint(4) NULL COMMENT "是否沙箱：0-否，1-是（需剔除）",
  `event_id` bigint(20) NULL COMMENT "TikTok回调事件id",
  `is_expire` tinyint(4) NULL COMMENT "是否过期：0-未过期，1-过期",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧TikTok订阅表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
