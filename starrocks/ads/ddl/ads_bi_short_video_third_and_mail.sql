CREATE TABLE `ads_bi_short_video_third_and_mail` (
  `dt` date NOT NULL COMMENT "统计周期",
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `active_dau` bitmap NULL COMMENT "活跃dau,当日登录，充值，消耗，观看用户数",
  `third_party_dau` bitmap NULL COMMENT "第三方登录用户数（第三方账号登录或设置了，或设置了密码的用户）",
  `mail_dau` bitmap NULL COMMENT "邮箱登录用户数（绑定或其他渠道获取）",
  `new_unt` bitmap NULL COMMENT "新增用户数",
  `new_third_party_unt` bitmap NULL COMMENT "新增三方账号登录用户数",
  `new_mail_unt` bitmap NULL COMMENT "新增邮箱登录用户数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`)
COMMENT "海剧登录和邮箱获取指标的底表"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);