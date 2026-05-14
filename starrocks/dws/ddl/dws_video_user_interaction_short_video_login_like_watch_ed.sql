CREATE TABLE `dws_video_user_interaction_short_video_login_like_watch_ed` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `product_id` smallint(6) NOT NULL COMMENT "产品名称",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `login_cnt` bigint(20) NULL COMMENT "登录次数",
  `watch_epis_bitmap` bitmap NULL COMMENT "观看剧集bitmap(剧id+集序号)",
  `epis_watch_cnt` bigint(20) NULL COMMENT "剧集有效观看数据(一次观看开始、结束各产生一条，计算次数需要除以2并上浮取整)",
  `is_like_cnt` bigint(20) NULL COMMENT "总退款(分成前,存在跨天退款的情况)",
  `is_like_epis_bitmap` bitmap NULL COMMENT "点赞剧集bitmap(剧id+集序号)",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海外短剧用户域短剧域互动域用户粒度登录+观看+点赞1日汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 70 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
