CREATE TABLE `ods_tidb_readerlog_log_seriesepiswatchlog` (
  `dt` date NOT NULL COMMENT "分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "主键id",
  `seriesid` bigint(20) NULL COMMENT "剧id",
  `episid` bigint(20) NULL COMMENT "集id",
  `userid` bigint(20) NULL COMMENT "用户id",
  `createtime` datetime NULL COMMENT "创建时间",
  `appid` int(11) NULL COMMENT "应用id",
  `time` bigint(20) NULL DEFAULT "0" COMMENT "观看进度时长",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `id`)
COMMENT "剧集观看日志"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`dt`, `product_id`, `id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
