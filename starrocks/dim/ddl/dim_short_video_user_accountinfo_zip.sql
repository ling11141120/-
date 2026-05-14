CREATE TABLE `dim_short_video_user_accountinfo_zip` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `start_dt` date NOT NULL COMMENT "开始日期",
  `end_dt` date NOT NULL COMMENT "结束日期",
  `mt` int(11) NULL COMMENT "最新平台号,1为ios 4为安卓",
  `corever` int(11) NULL COMMENT "core,默认1",
  `app_ver` varchar(200) NULL COMMENT "版本号",
  `current_language` int(11) NULL COMMENT "最新用户使用语言",
  `app_id` int(11) NULL COMMENT "应用id",
  `app_notify` int(11) NULL COMMENT "app_notify",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `user_id`, `start_dt`)
COMMENT "海剧-用户基本信息按天拉链表"
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);