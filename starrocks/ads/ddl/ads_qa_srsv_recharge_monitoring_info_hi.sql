CREATE TABLE `ads_qa_srsv_recharge_monitoring_info_hi` (
  `dt` date NOT NULL COMMENT "日期",
  `hour` int(11) NOT NULL COMMENT "小时段",
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `mt` int(11) NOT NULL COMMENT "平台,mt,1-iOS,4-安卓,其他",
  `core` int(11) NOT NULL COMMENT "core",
  `exposure_pv` int(11) NULL COMMENT "曝光pv",
  `exposure_uv` int(11) NULL COMMENT "曝光uv",
  `order_num` int(11) NULL COMMENT "订单数",
  `amount` decimal(11, 2) NULL COMMENT "充值金额",
  `base_amount` decimal(11, 2) NULL COMMENT "实收金额",
  `recharge_uv` int(11) NULL COMMENT "充值人数",
  `exposure_arpu` decimal(11, 4) NULL COMMENT "单人曝光ARPU",
  `exposure_cvr` decimal(11, 4) NULL COMMENT "单人曝光转化率",
  `etl_time` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `hour`, `product_id`, `mt`, `core`)
COMMENT "qa，海剧海阅充值、曝光小时级监控"
DISTRIBUTED BY HASH(`dt`, `hour`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);