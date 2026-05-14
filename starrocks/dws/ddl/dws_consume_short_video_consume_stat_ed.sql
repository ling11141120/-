CREATE TABLE `dws_consume_short_video_consume_stat_ed` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `product_id` smallint(6) NOT NULL COMMENT "产品名称",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `consume_amt` decimal(20, 6) NULL COMMENT "消耗货币数",
  `consume_cnt` bigint(20) NULL COMMENT "消耗次数(消耗为0不算)",
  `consume_epis_bitmap` bitmap NULL COMMENT "消耗剧集bitmap(剧id+集序号,消耗为0不算)",
  `consume_money_amt` decimal(20, 6) NULL COMMENT "消耗观看币(代币)数",
  `consume_money_cnt` bigint(20) NULL COMMENT "消耗观看币(代币)次数",
  `consume_money_epis_bitmap` bitmap NULL COMMENT "观看币(代币)消耗剧集bitmap(剧id+集序号)",
  `consume_cert_amt` decimal(20, 6) NULL COMMENT "消耗观看券(赠币)数",
  `consume_cert_cnt` bigint(20) NULL COMMENT "消耗观看券(赠币)次数",
  `consume_cert_epis_bitmap` bitmap NULL COMMENT "观看券(赠币)消耗剧集bitmap(剧id+集序号)",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "海外短剧消耗域用户粒度剧集消费1日汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 21 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
