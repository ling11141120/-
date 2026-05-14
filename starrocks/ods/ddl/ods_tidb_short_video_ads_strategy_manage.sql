CREATE TABLE `ods_tidb_short_video_ads_strategy_manage` (
  `id` bigint(20) NOT NULL COMMENT "主键Id",
  `strategy_code` varchar(300) NULL COMMENT "策略代号",
  `name` varchar(300) NULL COMMENT "策略名称",
  `ad_positon` int(11) NULL COMMENT "应用广告位：1-福利中心额外奖励，2-剧情内嵌广告|In-story原生广告，3-原生广告，4-签到额外广告，13-半屏额外解锁剧集",
  `strategy_type` int(11) NULL COMMENT "方案属性：1.兜底 2自定义",
  `status` int(11) NULL COMMENT "状态：1开启 2关闭",
  `weight` int(11) NULL COMMENT "权重",
  `begin_time` datetime NULL COMMENT "策略开始时间",
  `end_time` datetime NULL COMMENT "策略结束时间",
  `group_ids` varchar(6000) NULL COMMENT "人群包",
  `exclude_group_ids` varchar(6000) NULL COMMENT "剔除人群包",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `flow_type` int(11) NULL COMMENT "流量类型 1全局流量 2实验流量",
  `ab_status` int(11) NULL COMMENT "ab配置启动状态0关1开",
  `ab_id` bigint(20) NULL COMMENT "abid",
  `ab_version_id` bigint(20) NULL COMMENT "ab实验组id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
