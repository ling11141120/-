CREATE TABLE `dwm_ab_exp_recharge_index_di` (
  `dt` date NOT NULL COMMENT "日期天分区",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `exp_grp_ver_id` bigint(20) NOT NULL COMMENT "实验组版本ID",
  `recharge_amount` decimal(20, 2) NULL COMMENT "充值金额(分成后)",
  `recharge_amount_pre` decimal(20, 2) NULL COMMENT "充值金额(分成前)",
  `normal_recharge_amount` decimal(20, 2) NULL COMMENT "普通充值金额",
  `svip_recharge_amount` decimal(20, 2) NULL COMMENT "SVIP-充值金额",
  `signin_recharge_amount` decimal(20, 2) NULL COMMENT "签到卡-充值金额",
  `recharge_uv` int(11) NULL COMMENT "充值人数",
  `normal_recharge_uv` int(11) NULL COMMENT "普通充值人数",
  `svip_recharge_uvt` int(11) NULL COMMENT "SVIP-充值人数",
  `signin_recharge_uv` int(11) NULL COMMENT "签到卡-充值人数",
  `recharge_times` int(11) NULL COMMENT "充值次数",
  `normal_recharge_times` int(11) NULL COMMENT "普通充值次数",
  `svip_recharge_times` int(11) NULL COMMENT "SVIP-充值次数",
  `signin_recharge_times` int(11) NULL COMMENT "签到卡-充值次数",
  `exposure_pv` int(11) NULL COMMENT "充值曝光pv",
  `exposure_uv` int(11) NULL COMMENT "充值曝光uv",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `exp_id`, `exp_grp_id`, `exp_grp_ver_id`)
COMMENT "海剧-AB实验-充值原子指标"
DISTRIBUTED BY HASH(`exp_id`, `exp_grp_id`, `exp_grp_ver_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "exp_id, exp_grp_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
