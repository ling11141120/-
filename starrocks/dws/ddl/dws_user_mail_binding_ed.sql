CREATE TABLE `dws_user_mail_binding_ed` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `core` int(11) NOT NULL COMMENT "core",
  `mt` int(11) NOT NULL COMMENT "终端",
  `is_new` int(11) NOT NULL COMMENT "用户类型：区分新老用户",
  `total_cnt` int(11) NULL COMMENT "绑定邮箱用户总数",
  `fb_bandding_cnt` int(11) NULL COMMENT "fb邮箱绑定",
  `kefu_guidance_cnt` int(11) NULL COMMENT "客服引导绑定",
  `kefu_guidance_fb_cnt` int(11) NULL COMMENT "客服引导一键绑定fb邮箱用户数",
  `etl_time` datetime NULL COMMENT "处理时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT 'index_product_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `core`, `mt`, `is_new`)
COMMENT "用户域邮箱绑定指标"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
