CREATE TABLE `dwm_video_short_video_watch_consume_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `epis_num` smallint(6) NOT NULL COMMENT "剧集序号",
  `epis_id` bigint(20) NULL COMMENT "剧集id",
  `core` smallint(6) NULL COMMENT "core",
  `mt` varchar(65533) NULL COMMENT "平台",
  `source` varchar(65533) NULL COMMENT "来源媒体",
  `series_name` varchar(65533) NULL COMMENT "短剧名称",
  `series_language` smallint(6) NULL COMMENT "短剧语言",
  `epis_length` bigint(20) NULL COMMENT "剧集时长",
  `epis_amount` bigint(20) NULL COMMENT "剧集价位(代笔/赠币)",
  `start_first_time` datetime NULL COMMENT "最早开始时间",
  `end_last_time` datetime NULL COMMENT "最晚结束时间",
  `epis_watch_num` bigint(20) NULL COMMENT "剧集观看次数(上滑未加载也会有一条数据)",
  `epis_watch_num_real` bigint(20) NULL COMMENT "剧集有效观看数据(一次观看开始、结束各产生一条，计算次数需要除以2并上浮取整)",
  `epis_coin_consume_amount` decimal(20, 6) NULL COMMENT "观看币花费金额",
  `epis_cert_consume_amount` decimal(20, 6) NULL COMMENT "观看券花费金额",
  `is_like_num` smallint(6) NULL COMMENT "喜欢次数，为1的时间代表点赞时间",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `user_id`, `series_id`, `epis_num`)
COMMENT "海外短剧剧集消费+观看+喜欢一日汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`, `series_id`, `epis_num`) BUCKETS 150 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
