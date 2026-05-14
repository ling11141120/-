CREATE TABLE `ads_srsv_bi_mt_push_mon` (
  `stat_time` datetime NOT NULL COMMENT "统计时间",
  `product_id` int(11) NOT NULL COMMENT "product_id",
  `core` int(11) NOT NULL COMMENT "core",
  `mt` int(11) NOT NULL COMMENT "移动终端",
  `mt_name` varchar(15) NULL COMMENT "移动终端名称",
  `svr_push_tsk_num` decimal(20, 0) NULL COMMENT "服务端下发任务数",
  `svr_push_uv` bitmap NULL COMMENT "服务端下发UV",
  `svr_push_succ_tsk_num` decimal(20, 0) NULL COMMENT "服务端下发成功任务数",
  `push_cli_arr_dev_num` bitmap NULL COMMENT "下发到达客户端设备数",
  `cli_push_uv` bitmap NULL COMMENT "客户端下发UV",
  `cli_clk_uv` bitmap NULL COMMENT "客户端点击UV",
  `cli_dau` bitmap NULL COMMENT "客户端dau",
  `cli_push_act_uv` bitmap NULL COMMENT "客户端下发活跃UV"
) ENGINE=OLAP 
PRIMARY KEY(`stat_time`, `product_id`, `core`, `mt`)
COMMENT "BI-海剧海阅移动终端Push监控"
PARTITION BY date_trunc('year', stat_time)
DISTRIBUTED BY HASH(`stat_time`, `product_id`, `core`, `mt`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);