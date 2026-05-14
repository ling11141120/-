CREATE TABLE `ods_tidb_short_video_tt_payorder` (
  `id` bigint(20) NOT NULL COMMENT "主键ID",
  `order_incr_id` bigint(20) NULL COMMENT "自增的订单id，为了与阅读订单保持一致",
  `account_id` bigint(20) NULL COMMENT "用户ID",
  `goods_option_id` bigint(20) NULL COMMENT "商品价值方案ID",
  `series_id` bigint(20) NULL COMMENT "购买的剧id",
  `token_type` varchar(765) NULL COMMENT "令牌类型，目前仅支持BEANS",
  `token_amount` int(11) NULL COMMENT "令牌数量，当前版本特指BEANS的数量",
  `order_url` varchar(1500) NULL COMMENT "订单信息页面访问链接，用于Tiktok站内跳转",
  `product_name` varchar(765) NULL COMMENT "商品名称",
  `product_id` varchar(765) NULL COMMENT "商品ID",
  `quantity` int(11) NULL COMMENT "商品数量",
  `quantity_unit` varchar(300) NULL COMMENT "商品数量单位",
  `image_url` varchar(1500) NULL COMMENT "订单封面图URL",
  `trade_order_id` varchar(765) NULL COMMENT "TikTok生成的订单号",
  `trade_order_status` int(11) NULL COMMENT "tiktok订单状态：0-初始化，1-待支付，2-支付成功，-1-退款，-2-支付取消",
  `order_type` int(11) NULL COMMENT "订单类型：0-普通订单，1-整剧购买订单",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧TikTok订单表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
