CREATE TABLE `ods_cdmoney_report_tidb_cn_dispute_order_paypal` (
  `id` bigint(20) NOT NULL COMMENT "自增ID",
  `dispute_id` varchar(300) NULL COMMENT "争议ID",
  `pay_channel_id` varchar(300) NULL COMMENT "渠道ID",
  `pay_channel_name` varchar(300) NULL COMMENT "渠道名称",
  `seller_transaction_id` varchar(300) NULL COMMENT "卖方交易ID",
  `buyer_transaction_id` varchar(300) NULL COMMENT "买方交易ID",
  `coo_order_id` varchar(600) NULL COMMENT "支付订单号,合作方回传的,paypal提供的",
  `order_id` varchar(600) NULL COMMENT "订单表>订单号,对应接口字段invoice_number",
  `account` varchar(600) NULL COMMENT "订单表>用户账号",
  `user_id` varchar(600) NULL COMMENT "订单表>用户ID",
  `amount` decimal(18, 2) NULL COMMENT "订单表>订单金额",
  `coins` decimal(18, 2) NULL COMMENT "订单表>代币",
  `product_id` varchar(300) NULL COMMENT "订单表>产品ID",
  `shop_item_id` varchar(300) NULL COMMENT "订单表>商品ID",
  `core` int(11) NULL COMMENT "订单表>core",
  `os_type` int(11) NULL COMMENT "订单表>平台,相当于mt,1-iOS,4-安卓,其他",
  `order_create_time` datetime NULL COMMENT "订单表>创建时间",
  `coo_notify_time` datetime NULL COMMENT "订单表>到账时间",
  `coo_order_status` int(11) NULL COMMENT "订单表>合作方扣款状态：1 成功",
  `insert_time` datetime NULL COMMENT "添加时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `moneylog_data` varchar(1048576) NULL COMMENT "用户消费明细 shop_item_id = 800/830/840需提供",
  `watchlog_data` varchar(1048576) NULL COMMENT "观看/阅读记录 shop_item_id=810/850需提供",
  `is_order_sync` int(11) NULL COMMENT "订单基础数据同步状态 1 已同步 0 待同步  2 同步失败",
  `is_moneylog_sync` int(11) NULL COMMENT "消费明细数据同步状态 1 已同步 0 待同步 shop_item_id = 800/830/840需提供",
  `is_watchlog_sync` int(11) NULL COMMENT "观看/阅读数据同步状态 1 已同步 0 待同步 shop_item_id=810/850需提供",
  `is_finish_sync` int(11) NULL COMMENT "同步数据是否完整 1 是, 0 否",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "paypal争议订单表"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
