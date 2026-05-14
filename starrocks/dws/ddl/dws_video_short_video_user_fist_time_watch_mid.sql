CREATE TABLE `dws_video_short_video_user_fist_time_watch_mid` (
  `dt` date NOT NULL COMMENT "日期，create_time转化而来",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `epis_num` smallint(6) NULL COMMENT "首次观看的剧集序号",
  `create_time` datetime NULL COMMENT "创建时间-首次观看时间",
  `h12_time` datetime NULL COMMENT "首次观看时间+12h",
  `h24_time` datetime NULL COMMENT "首次观看时间+24h",
  `d7_time` datetime NULL COMMENT "首次观看时间+168h",
  `d30_time` datetime NULL COMMENT "首次观看时间+720h",
  `user_tp` smallint(6) NOT NULL COMMENT "用户类型：1 新用户；2新增观看老用户；3 观看老用户",
  `source_user_tp` smallint(6) NOT NULL COMMENT "媒体用户类型:1 注册当天 2 再营销安装 3 其它",
  `source` varchar(65533) NULL COMMENT "媒体值（广告投放平台,取首次观看的媒体指）",
  `corever` smallint(6) NULL COMMENT "core",
  `mt` smallint(6) NULL COMMENT "平台",
  `ad_id` varchar(250) NULL COMMENT "广告id",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `series_id`)
COMMENT "短剧域用户首次观看剧粒度明细表-西五区时间"
DISTRIBUTED BY HASH(`dt`, `user_id`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, user_id, series_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
