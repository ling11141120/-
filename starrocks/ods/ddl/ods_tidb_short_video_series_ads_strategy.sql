CREATE TABLE `ods_tidb_short_video_series_ads_strategy` (
  `id` bigint(20) NOT NULL COMMENT "唯一ID",
  `strategy_code` varchar(300) NULL COMMENT "策略代号",
  `strategy_name` varchar(500) NULL COMMENT "广告解锁策略名称",
  `flow_type` int(11) NULL COMMENT "流量类型 1全局流量 2实验流量",
  `status` int(11) NULL COMMENT "状态1 开启，2 关闭",
  `weight` int(11) NULL COMMENT "权重:默认51",
  `start_time` datetime NULL COMMENT "策略开始时间",
  `end_time` datetime NULL COMMENT "策略结束时间",
  `group_ids` varchar(255) NULL COMMENT "人群包Id（逗号分隔）",
  `exclude_group_ids` varchar(65533) NULL COMMENT "剔除人群包",
  `full_type` int(11) NULL COMMENT "全量类型，0全量，1部分（不配置剧目包为全量）",
  `series_group_id` bigint(20) NULL COMMENT "剧目包Id",
  `ads_unlock` int(11) NULL COMMENT "是否支持广告解锁：0否 1是",
  `ads_unlock_num` int(11) NULL COMMENT "广告可解锁集数",
  `audit_status` int(11) NULL COMMENT "审核状态（0审核中，1通过，2不通过）",
  `process_instance_id` varchar(600) NULL COMMENT "钉钉发起审批实例id",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `ads_count` int(11) NULL COMMENT "解锁单集广告数量",
  `user_count` int(11) NULL COMMENT "用户每日解锁上限",
  `unlock_type` int(11) NULL COMMENT "解锁类型 1半屏广告解锁 2返回推广告解锁",
  `strategy_type` int(11) NULL COMMENT "策略类型：1激励视频，2浏览三方页面，3阶梯混合模式",
  `relation_ids` varchar(10000) NULL COMMENT "【strategy_type为2浏览三方页面，需要配置】关联承接内容（ndaction_url表主键）id,多个逗号隔开",
  `task_second` int(11) NULL COMMENT "【strategy_type为2浏览三方页面，需要配置】浏览完成秒数",
  `unlock_limit_dimension` int(11) NULL COMMENT "解锁上限维度。取值：1-全局限制、2-按剧限制。默认是：1-全局限制",
  `ab_status` int(11) NULL COMMENT "ab配置启动状态0关1开",
  `ab_id` bigint(20) NULL COMMENT "abid",
  `ab_version_id` bigint(20) NULL COMMENT "ab实验组id",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "广告解锁定投信息"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
