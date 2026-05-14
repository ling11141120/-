CREATE TABLE `ads_sv_new_user_watch_series` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `publish_time` datetime NULL COMMENT "上架时间",
  `type_id` varchar(255) NULL COMMENT "最近内容的分类标签",
  `local_type` int(11) NULL COMMENT "最近内容的短剧类型（本土剧、译制剧）",
  `series_level` int(11) NULL COMMENT "最近内容的短剧等级（1.S 2.A 3.B 4.C）",
  `epis_num` int(11) NULL COMMENT "累计观看集数（单集进度=80% 视为完整观看）",
  `watch_progress` int(11) NULL COMMENT "累计用户观看进度（累计观看集数/剧集总集数）×100%",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `series_id`)
COMMENT "海剧-新用户观看剧信息"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);