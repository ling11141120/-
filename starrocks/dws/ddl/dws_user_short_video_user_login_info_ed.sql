CREATE TABLE `dws_user_short_video_user_login_info_ed` (
  `dt` date NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `corever` int(11) NULL COMMENT "corever",
  `current_language` int(11) NULL COMMENT "当前语言 从dwd层lang_id获取",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `appver` varchar(50) NULL COMMENT "版本号",
  `mt` int(11) NULL COMMENT "平台",
  `ver` varchar(50) NULL COMMENT "服务端版本号",
  `device` varchar(300) NULL COMMENT "设备",
  `device2` varchar(300) NULL COMMENT "设备2",
  `reg_country` varchar(50) NULL COMMENT "注册时国家",
  `reg_time` datetime NULL COMMENT "用户注册时间",
  `reg_days` int(11) NULL COMMENT "用户留存天数（活跃时间-注册时间）",
  `login_times` int(11) NULL DEFAULT "0" COMMENT "登录次数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "按天轻度汇总表：短剧用户登录统计表，一个用户一天会存在多条数据的情况，例如 用户可能切换界面语言，或者切换终端等,在算用户留存的时候需要去重处理"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
