CREATE TABLE `ods_tidb_short_video_third_payment_rate` (
  `id` bigint(20) NOT NULL COMMENT "",
  `channel_id` varchar(300) NOT NULL COMMENT "大渠道id",
  `pay_code` varchar(300) NULL COMMENT "渠道code",
  `pay_way` varchar(300) NOT NULL COMMENT "支付方式",
  `pay_channel` varchar(300) NOT NULL COMMENT "支付渠道",
  `pay_id` varchar(300) NOT NULL COMMENT "支付id",
  `account_country` varchar(300) NULL COMMENT "账户归属",
  `bill_country` varchar(300) NOT NULL COMMENT "订单国家",
  `pay_type` int(11) NOT NULL COMMENT "支付类型 1统一 2本地 3跨境",
  `rate` double NOT NULL COMMENT "支付费率 （0,50]，支持小数点后两位，单位为%",
  `tax` double NOT NULL COMMENT "固定税费",
  `tax_point` double NULL COMMENT "固定税费分界点",
  `min_prize` double NULL COMMENT "最小支付金额",
  `send` int(11) NOT NULL COMMENT "基础加赠%",
  `sort` int(11) NOT NULL COMMENT "基础排序",
  `max_icon` varchar(2000) NOT NULL COMMENT "大图标key",
  `min_icon` varchar(2000) NOT NULL COMMENT "小图标key",
  `status` int(11) NOT NULL COMMENT "启用 0关1开",
  `create_time` datetime NOT NULL COMMENT "创建时间",
  `update_time` datetime NOT NULL COMMENT "更新时间",
  `is_delete` int(11) NOT NULL DEFAULT "0" COMMENT "删除状态 0正常0删除",
  `sr_createtime` datetime NULL COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "短剧-三方支付费率"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
