CREATE TABLE `ads_sr_looklike_user_label` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `login_days` int(11) NULL COMMENT "登录天数",
  `login_re` datetime NULL COMMENT "最近登录日期",
  `first_recharge` decimal(18, 2) NULL COMMENT "首次充值金额",
  `recharge_cnt` int(11) NULL COMMENT "累计充值次数",
  `total_recharge` decimal(18, 2) NULL COMMENT "累计充值金额",
  `recharge_avg` decimal(20, 4) NULL COMMENT "平均充值金额",
  `total_subscribe_money` decimal(18, 2) NULL COMMENT "累计订阅金额",
  `charge_mode` decimal(18, 6) NULL COMMENT "充值众数",
  `coupon_mode` decimal(11, 2) NULL COMMENT "充值优惠众数(充值获得礼券数/阅币数)",
  `last_recharge_time` datetime NULL COMMENT "最近充值时间",
  `chapter_total` int(11) NULL COMMENT "累计付费解锁章节数",
  `chapter_days_avg` decimal(20, 2) NULL COMMENT " 日均付费解锁章节数",
  `consume_total` decimal(20, 4) NULL COMMENT "用户累计消耗（阅币+礼券）数",
  `consume_days_avg` decimal(20, 4) NULL COMMENT "日均消费货币数（阅币+礼券）",
  `total_read_time` bigint(20) NULL COMMENT "累计阅读时长",
  `read_time_da_avg` decimal(20, 2) NULL COMMENT " 日均阅读时长",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`)
COMMENT "海阅-looklike用户指标"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);