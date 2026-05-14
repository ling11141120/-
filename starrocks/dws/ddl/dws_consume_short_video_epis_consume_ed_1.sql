CREATE TABLE `dws_consume_short_video_epis_consume_ed_1` (
  `dt` date NOT NULL COMMENT "统计日期，昨日",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `epis_num` smallint(6) NOT NULL COMMENT "剧集序号",
  `consume_user_bitmap` bitmap NULL COMMENT "消费用户bitmap",
  `consume_amt` decimal(20, 6) NULL COMMENT "总消耗数量",
  `consume_cnt` bigint(20) NULL COMMENT "总消耗次数",
  `consume_money_user_bitmap` bitmap NULL COMMENT "观看币消耗用户bitmap",
  `consume_money_amt` decimal(20, 6) NULL COMMENT "观看币消耗数量",
  `consume_money_cnt` bigint(20) NULL COMMENT "观看币消耗次数",
  `consume_cert_user_bitmap` bitmap NULL COMMENT "观看券消耗用户bitmap",
  `consume_cert_amt` decimal(20, 6) NULL COMMENT "观看券消耗数量",
  `consume_cert_cnt` bigint(20) NULL COMMENT "观看券消耗次数",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`, `epis_num`)
COMMENT "海外短剧消耗域剧集粒度消费1日汇总表"
DISTRIBUTED BY HASH(`dt`, `series_id`, `epis_num`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, epis_num, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
